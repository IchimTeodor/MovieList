import Foundation
import MovieBrowserDomain
import MovieBrowserNavigation

typealias Route = MovieBrowserRoute

enum MovieBrowserRoute: NavigationRoute {
    case home
    case detail(movie: MovieSummary)

    var identifier: String {
        switch self {
        case .home:
            return "home"
        case let .detail(movie):
            return "detail-\(movie.id)"
        }
    }

    var title: String {
        switch self {
        case .home:
            return "Movies"
        case let .detail(movie):
            return movie.title
        }
    }

    var id: String { identifier }
}
