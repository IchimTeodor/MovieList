import Foundation

public struct MoviePage {
    package let index: Int
    package let hasNextPage: Bool
    package let movies: [MovieSummary]

    package init(index: Int, hasNextPage: Bool, movies: [MovieSummary]) {
        self.index = index
        self.hasNextPage = hasNextPage
        self.movies = movies
    }
}
