import Foundation

public struct MovieDetail: Identifiable, Hashable {
    public let id: Int
    package let title: String
    package let synopsis: String
    package let bannerURL: URL?
    package let score: MovieScore
    package let genres: [String]
    package let length: String?
    package let language: String?
    package let rating: String?
    package let trailerURL: URL?
    package let trailerVideoID: String?
    package let trailerSite: String?
    package let isFavorite: Bool
    package let cast: [MovieCastMember]

    package init(
        id: Int,
        title: String,
        synopsis: String,
        bannerURL: URL?,
        score: MovieScore,
        genres: [String],
        length: String?,
        language: String?,
        rating: String?,
        trailerURL: URL?,
        trailerVideoID: String?,
        trailerSite: String?,
        isFavorite: Bool,
        cast: [MovieCastMember]
    ) {
        self.id = id
        self.title = title
        self.synopsis = synopsis
        self.bannerURL = bannerURL
        self.score = score
        self.genres = genres
        self.length = length
        self.language = language
        self.rating = rating
        self.trailerURL = trailerURL
        self.trailerVideoID = trailerVideoID
        self.trailerSite = trailerSite
        self.isFavorite = isFavorite
        self.cast = cast
    }

    package func mergingExtras(cast: [MovieCastMember]) -> MovieDetail {
        MovieDetail(
            id: id,
            title: title,
            synopsis: synopsis,
            bannerURL: bannerURL,
            score: score,
            genres: genres,
            length: length,
            language: language,
            rating: rating,
            trailerURL: trailerURL,
            trailerVideoID: trailerVideoID,
            trailerSite: trailerSite,
            isFavorite: isFavorite,
            cast: cast.isEmpty ? self.cast : cast
        )
    }

    package func mergingExtras(_ extras: MovieDetailExtras) -> MovieDetail {
        mergingExtras(cast: extras.cast)
    }
}

package extension MovieDetail {
    var imdbScoreText: String {
        score.imdbText
    }
}
