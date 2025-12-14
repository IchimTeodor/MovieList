import Apollo
import Foundation
import MovieBrowserAPI
import MovieBrowserDomain
import OSLog

public enum MediaTypeFilter: Equatable {
    case anime
    case manga
    case custom(String)
}

public enum MediaFormatFilter: Equatable {
    case movie
    case tv
    case tvShort
    case ova
    case ona
    case special
    case music
    case manga
    case novel
    case oneShot
    case custom(String)
}

public protocol MovieServicing {
    func fetchTopMovies(page: Int, perPage: Int, format: MediaFormatFilter) async throws -> MoviePage
    func fetchDetailInfo(id: Int, type: MediaTypeFilter) async throws -> MovieDetail
    func fetchDetailExtras(id: Int, type: MediaTypeFilter) async throws -> MovieDetailExtras
}

public extension MovieServicing {
    func fetchTopMovies(page: Int, perPage: Int) async throws -> MoviePage {
        try await fetchTopMovies(page: page, perPage: perPage, format: .movie)
    }

    func fetchDetailInfo(id: Int) async throws -> MovieDetail {
        try await fetchDetailInfo(id: id, type: .anime)
    }

    func fetchDetailExtras(id: Int) async throws -> MovieDetailExtras {
        try await fetchDetailExtras(id: id, type: .anime)
    }
}

public enum MovieServiceError: Error, LocalizedError {
    case missingPayload
    case server(message: String)

    public var errorDescription: String? {
        switch self {
        case .missingPayload:
            return "The server response was empty."
        case let .server(message):
            return message
        }
    }
}

public final class MovieService: MovieServicing {
    private let graphQLClient: GraphQLClientPerforming
    private static let logger = Logger(subsystem: "com.agilefreaks.moviebrowser", category: "MovieService")

    public init(graphQLClient: GraphQLClientPerforming) {
        self.graphQLClient = graphQLClient
    }

    public func fetchTopMovies(page: Int, perPage: Int, format: MediaFormatFilter) async throws -> MoviePage {
        debugLog("➡️ Fetching top media page=\(page) perPage=\(perPage) format=\(format)")
        let data = try await execute(
            TopMoviesQuery(
                page: .some(page),
                perPage: .some(perPage),
                format: .some(format.graphQLValue)
            )
        )
        let pageModel = try makeMoviePage(from: data?.page, fallbackPage: page)
        debugLog("✅ Received \(pageModel.movies.count) movies (hasNext=\(pageModel.hasNextPage))")
        return pageModel
    }

    public func fetchDetailInfo(id: Int, type: MediaTypeFilter) async throws -> MovieDetail {
        debugLog("➡️ Fetching detail info id=\(id) type=\(type)")
        let data = try await execute(
            MovieDetailInfoQuery(
                id: .some(id),
                type: .some(type.graphQLValue)
            )
        )
        guard let baseMedia = data?.media else {
            throw MovieServiceError.missingPayload
        }

        let detail = baseMedia.toDetail()
        debugLog("✅ Detail info loaded id=\(detail.id)")
        return detail
    }

    public func fetchDetailExtras(id: Int, type: MediaTypeFilter) async throws -> MovieDetailExtras {
        debugLog("➡️ Fetching detail extras id=\(id) type=\(type)")
        let data = try await execute(
            MovieDetailExtrasQuery(
                id: .some(id),
                type: .some(type.graphQLValue)
            ),
            allowEmptyData: true
        )

        guard let extraMedia = data?.media else {
            return .empty
        }

        let cast = extraMedia.toCastMembers()
        let extras = MovieDetailExtras(cast: cast)
        debugLog("✅ Extras loaded id=\(id) cast=\(extras.cast.count)")
        return extras
    }

}

private extension TopMoviesQuery.Data.Page.Medium {
    func toSummary() -> MovieSummary {
        let readableTitle = title?.english ?? title?.romaji ?? "N/A"
        let releaseYear = startDate?.year ?? endDate?.year
        let subtitleComponents = [
            format.flatMap { $0.rawValue.replacingOccurrences(of: "_", with: " ").capitalized },
            releaseYear.map { "\($0)" }
        ].compactMap { $0 }
        let subtitle = subtitleComponents.joined(separator: " • ")
        let genres = (self.genres ?? []).compactMap { $0 }.prefix(3)
        let cover = coverImage?.resolvedURL
        return MovieSummary(
            id: id,
            title: readableTitle,
            subtitle: subtitle,
            score: MovieScore(value: averageScore),
            genres: Array(genres),
            coverImageURL: cover,
            isFavorite: isFavourite
        )
    }
}

private extension MovieDetailExtrasQuery.Data.Media {
    func toCastMembers() -> [MovieCastMember] {
        characters?.edges?.compactMap { edge in
            guard let node = edge?.node else { return nil }
            let imageURL = node.image?.large.flatMap(URL.init(string:))
            let voiceActor = edge?.voiceActors?.first??.name?.full
            return MovieCastMember(
                id: node.id,
                name: node.name?.full ?? "Unknown",
                role: edge?.role?.rawValue.replacingOccurrences(of: "_", with: " ").capitalized,
                imageURL: imageURL,
                voiceActor: voiceActor
            )
        } ?? []
    }
}

private extension MovieDetailInfoQuery.Data.Media {
    func toDetail() -> MovieDetail {
        let readableTitle = title?.english ?? title?.romaji ?? "Unknown"
        let synopsis = HTMLTextFormatter.plainText(from: description) ?? "No synopsis available."

        let trailerURL = trailer?.directURL
        let trailerVideoID = trailer?.id
        let trailerSite = trailer?.site

        return MovieDetail(
            id: id,
            title: readableTitle,
            synopsis: synopsis,
            bannerURL: URL(string: bannerImage ?? ""),
            score: MovieScore(value: averageScore ?? meanScore),
            genres: genres?.compactMap { $0 } ?? [],
            length: duration.map(MovieService.formatDuration),
            language: countryOfOrigin.flatMap(MovieService.languageDisplay(for:)),
            rating: MovieService.ratingLabel(isAdult: isAdult),
            trailerURL: trailerURL,
            trailerVideoID: trailerVideoID,
            trailerSite: trailerSite,
            isFavorite: isFavourite,
            cast: []
        )
    }
}

private extension TopMoviesQuery.Data.Page.Medium.CoverImage {
    var resolvedURL: URL? {
        if let extraLarge, let url = URL(string: extraLarge) {
            return url
        }
        if let large, let url = URL(string: large) {
            return url
        }
        return nil
    }
}

private extension MovieDetailInfoQuery.Data.Media.Trailer {
    var directURL: URL? {
        guard let id, let site else { return nil }
        switch site.lowercased() {
        case "youtube":
            return URL(string: "https://www.youtube.com/watch?v=\(id)")
        case "dailymotion":
            return URL(string: "https://www.dailymotion.com/video/\(id)")
        default:
            return URL(string: id)
        }
    }

}

private extension MovieService {
    func execute<Query: GraphQLQuery>(
        _ query: Query,
        allowEmptyData: Bool = false
    ) async throws -> Query.Data? {
        let result = try await graphQLClient.fetch(
            query: query,
            cachePolicy: .fetchIgnoringCacheData
        )
        try validate(errors: result.errors)

        guard let data = result.data else {
            if allowEmptyData {
                return nil
            } else {
                throw MovieServiceError.missingPayload
            }
        }

        return data
    }

    func validate(errors: [GraphQLError]?) throws {
        guard
            let message = errors?.first?.message,
            !message.isEmpty
        else { return }
        throw MovieServiceError.server(message: message)
    }

    func makeMoviePage(
        from page: TopMoviesQuery.Data.Page?,
        fallbackPage: Int
    ) throws -> MoviePage {
        guard
            let page,
            let pageInfo = page.pageInfo,
            let mediaList = page.media
        else {
            throw MovieServiceError.missingPayload
        }

        let movies = mediaList.compactMap { $0?.toSummary() }
        return MoviePage(
            index: pageInfo.currentPage ?? fallbackPage,
            hasNextPage: pageInfo.hasNextPage ?? false,
            movies: movies
        )
    }

    static func formatDuration(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        if hours > 0 {
            return mins > 0 ? "\(hours)h \(mins)min" : "\(hours)h"
        }
        return "\(mins)min"
    }

    static func languageDisplay(for code: String) -> String {
        let normalized = code.uppercased()
        let languages = [
            "JP": "Japanese",
            "CN": "Chinese",
            "TW": "Chinese",
            "KR": "Korean",
            "US": "English",
            "GB": "English",
            "CA": "English",
            "AU": "English",
            "FR": "French",
            "DE": "German",
            "ES": "Spanish",
            "IT": "Italian"
        ]
        if let match = languages[normalized] {
            return match
        }
        return Locale(identifier: "en").localizedString(forRegionCode: normalized) ?? normalized
    }

    static func ratingLabel(isAdult: Bool?) -> String? {
        guard let isAdult else { return nil }
        return isAdult ? "R18+" : "PG-13"
    }

    func debugLog(_ message: String) {
#if DEBUG
        Self.logger.debug("\(message, privacy: .public)")
#endif
    }
}

private extension MediaTypeFilter {
    var graphQLValue: GraphQLEnum<MovieBrowserAPI.MediaType> {
        switch self {
        case .anime:
            return GraphQLEnum(.anime)
        case .manga:
            return GraphQLEnum(.manga)
        case let .custom(rawValue):
            return GraphQLEnum(MovieBrowserAPI.MediaType(rawValue: rawValue) ?? .anime)
        }
    }
}

private extension MediaFormatFilter {
    var graphQLValue: GraphQLEnum<MovieBrowserAPI.MediaFormat> {
        switch self {
        case .movie:
            return GraphQLEnum(.movie)
        case .tv:
            return GraphQLEnum(.tv)
        case .tvShort:
            return GraphQLEnum(.tvShort)
        case .ova:
            return GraphQLEnum(.ova)
        case .ona:
            return GraphQLEnum(.ona)
        case .special:
            return GraphQLEnum(.special)
        case .music:
            return GraphQLEnum(.music)
        case .manga:
            return GraphQLEnum(.manga)
        case .novel:
            return GraphQLEnum(.novel)
        case .oneShot:
            return GraphQLEnum(.oneShot)
        case let .custom(rawValue):
            return GraphQLEnum(MovieBrowserAPI.MediaFormat(rawValue: rawValue) ?? .movie)
        }
    }
}
