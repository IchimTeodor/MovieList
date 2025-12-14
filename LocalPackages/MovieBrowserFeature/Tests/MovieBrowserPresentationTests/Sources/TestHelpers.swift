import Foundation
@testable import MovieBrowserDomain
@testable import MovieBrowserService

final class MovieServiceStub: MovieServicing {
    private(set) var requestedPages: [Int] = []
    private(set) var fetchDetailInfoCallCount = 0
    private(set) var fetchDetailExtrasCallCount = 0

    var topMoviesResults: [Result<MoviePage, Error>] = []
    var detailInfoResult: Result<MovieDetail, Error>?
    var detailExtrasResult: Result<MovieDetailExtras, Error>?

    func enqueueTopMoviesResult(_ result: Result<MoviePage, Error>) {
        topMoviesResults.append(result)
    }

    func fetchTopMovies(page: Int, perPage _: Int, format _: MediaFormatFilter) async throws -> MoviePage {
        requestedPages.append(page)
        guard !topMoviesResults.isEmpty else {
            fatalError("No stubbed result for fetchTopMovies")
        }
        let result = topMoviesResults.removeFirst()
        return try result.get()
    }

    func fetchDetailInfo(id _: Int, type _: MediaTypeFilter) async throws -> MovieDetail {
        fetchDetailInfoCallCount += 1
        guard let detailInfoResult else {
            fatalError("No stubbed result for fetchDetailInfo")
        }
        return try detailInfoResult.get()
    }

    func fetchDetailExtras(id _: Int, type _: MediaTypeFilter) async throws -> MovieDetailExtras {
        fetchDetailExtrasCallCount += 1
        guard let detailExtrasResult else {
            fatalError("No stubbed result for fetchDetailExtras")
        }
        return try detailExtrasResult.get()
    }
}

enum MovieTestData {
    static func makeSummary(id: Int = 1, isFavorite: Bool = false, title: String? = nil) -> MovieSummary {
        MovieSummary(
            id: id,
            title: title ?? "Movie \(id)",
            subtitle: "Movie Subtitle",
            score: MovieScore(value: 82),
            genres: ["Action", "Drama"],
            coverImageURL: URL(string: "https://example.com/\(id).png"),
            isFavorite: isFavorite
        )
    }

    static func makePage(index: Int = 1, hasNextPage: Bool = false, movies: [MovieSummary]? = nil) -> MoviePage {
        MoviePage(index: index, hasNextPage: hasNextPage, movies: movies ?? [makeSummary()])
    }

    static func makeDetail(
        movieID: Int = 1,
        title: String? = nil,
        trailerSite: String? = nil,
        trailerVideoID: String? = nil,
        trailerURL: URL? = nil,
        cast: [MovieCastMember] = []
    ) -> MovieDetail {
        MovieDetail(
            id: movieID,
            title: title ?? "Detail \(movieID)",
            synopsis: "Synopsis",
            bannerURL: URL(string: "https://example.com/banner\(movieID).png"),
            score: MovieScore(value: 90),
            genres: ["Adventure"],
            length: "120 min",
            language: "English",
            rating: "PG-13",
            trailerURL: trailerURL,
            trailerVideoID: trailerVideoID,
            trailerSite: trailerSite,
            isFavorite: false,
            cast: cast
        )
    }

    static func makeExtras(
        cast: [MovieCastMember] = [makeCastMember(id: 1)]
    ) -> MovieDetailExtras {
        MovieDetailExtras(cast: cast)
    }

    static func makeCastMember(id: Int) -> MovieCastMember {
        MovieCastMember(
            id: id,
            name: "Actor \(id)",
            role: "Lead",
            imageURL: URL(string: "https://example.com/cast\(id).png"),
            voiceActor: "Voice \(id)"
        )
    }
}

struct TestError: LocalizedError, Equatable {
    var errorDescription: String? { "stub-error" }
}
