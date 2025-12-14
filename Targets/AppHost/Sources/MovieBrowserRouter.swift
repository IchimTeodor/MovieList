import Foundation
import Observation
import MovieBrowserDomain
import MovieBrowserNavigation
import MovieBrowserPresentation

@Observable
@MainActor
final class AppMovieBrowserRouter: Router {
    typealias Route = MovieBrowserRoute

    var path: [Route] = []
    var presentedSheet: Route?
    var presentedFullScreenCover: Route?
}

extension AppMovieBrowserRouter {
    func handleList(destination: MovieListDestination) {
        switch destination {
        case let .detail(movie):
            navigate(to: .detail(movie: movie))
        }
    }

    func handleDetail(destination: MovieDetailDestination) {
        switch destination {
        case .dismiss:
            navigateBack()
        }
    }
}
