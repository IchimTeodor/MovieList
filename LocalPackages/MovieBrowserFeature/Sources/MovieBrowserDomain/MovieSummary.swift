import Foundation

public struct MovieSummary: Identifiable, Hashable {
    public let id: Int
    public let title: String
    public let subtitle: String
    public let score: MovieScore
    public let genres: [String]
    public let coverImageURL: URL?
    public let isFavorite: Bool

    public init(
        id: Int,
        title: String,
        subtitle: String,
        score: MovieScore,
        genres: [String],
        coverImageURL: URL?,
        isFavorite: Bool
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.score = score
        self.genres = genres
        self.coverImageURL = coverImageURL
        self.isFavorite = isFavorite
    }
}

public extension MovieSummary {
    var imdbScoreText: String {
        score.imdbText
    }
}
