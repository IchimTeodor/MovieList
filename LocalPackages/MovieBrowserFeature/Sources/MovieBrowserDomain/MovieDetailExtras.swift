import Foundation

public struct MovieDetailExtras: Equatable {
    package let cast: [MovieCastMember]

    package init(cast: [MovieCastMember]) {
        self.cast = cast
    }

    package static let empty = MovieDetailExtras(cast: [])
}
