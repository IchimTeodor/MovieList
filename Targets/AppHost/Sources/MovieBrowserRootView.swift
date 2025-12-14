import SwiftUI
import Observation
import MovieBrowserComposition
import MovieBrowserNavigation

struct MovieBrowserRootView: View {
    @Bindable var router: AppMovieBrowserRouter
    private let composer: MovieBrowserComposer
    private let navigationFactory: NavigationFactory<AppMovieBrowserRouter>

    init(router: AppMovieBrowserRouter, composer: MovieBrowserComposer) {
        self.router = router
        self.composer = composer
        let navigationComposer = NavigationComposer<AppMovieBrowserRouter> { route, router in
            MovieBrowserRootView.buildView(for: route, router: router, composer: composer)
        }
        self.navigationFactory = NavigationFactory(composer: navigationComposer)
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            navigationFactory.view(for: .home, router: router)
                .withRouteNavigation(router: router, factory: navigationFactory)
        }
    }
    
    @ViewBuilder
    private static func buildView(
        for route: Route,
        router: AppMovieBrowserRouter,
        composer: MovieBrowserComposer
    ) -> some View {
        switch route {
        case .home:
            composer.makeMovieListView(onNavigate: router.handleList(destination:))
        case let .detail(movie):
            composer.makeMovieDetailView(
                for: movie,
                onNavigate: router.handleDetail(destination:)
            )
        }
    }
}
