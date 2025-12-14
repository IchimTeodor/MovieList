import SwiftUI

public struct NavigationComposer<RouterType: Router> {
    private let viewBuilder: (RouterType.Route, RouterType) -> AnyView

    public init<RouteView: View>(
        @ViewBuilder build: @escaping (RouterType.Route, RouterType) -> RouteView
    ) {
        self.viewBuilder = { route, router in AnyView(build(route, router)) }
    }

    @MainActor
    @ViewBuilder
    func view(for route: RouterType.Route, router: RouterType) -> some View {
        viewBuilder(route, router)
    }
}

public struct NavigationFactory<RouterType: Router> {
    private let composer: NavigationComposer<RouterType>

    public init(composer: NavigationComposer<RouterType>) {
        self.composer = composer
    }

    @MainActor
    @ViewBuilder
    public func view(for route: RouterType.Route, router: RouterType) -> some View {
        composer.view(for: route, router: router)
    }
}

public extension View {
    @MainActor
    func withRouteNavigation<RouterType: Router>(
        router: RouterType,
        factory: NavigationFactory<RouterType>
    ) -> some View {
        self
            .navigationDestination(for: RouterType.Route.self) { route in
                factory.view(for: route, router: router)
            }
            .sheet(item: Binding(
                get: { router.presentedSheet },
                set: { router.presentedSheet = $0 }
            )) { route in
                NavigationStack {
                    factory.view(for: route, router: router)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Close") {
                                    router.dismissSheet()
                                }
                            }
                        }
                }
            }
            .fullScreenCover(item: Binding(
                get: { router.presentedFullScreenCover },
                set: { router.presentedFullScreenCover = $0 }
            )) { route in
                NavigationStack {
                    factory.view(for: route, router: router)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Close") {
                                    router.dismissFullScreenCover()
                                }
                            }
                        }
                }
            }
    }
}
