import Observation

public protocol Router: AnyObject, Observable {
    associatedtype Route: NavigationRoute
    var path: [Route] { get set }
    var presentedSheet: Route? { get set }
    var presentedFullScreenCover: Route? { get set }
}

public extension Router {
    func navigate(to route: Route) {
        path.append(route)
    }

    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func navigateToRoot() {
        path.removeAll()
    }

    func popTo(route: Route) {
        guard let index = path.firstIndex(of: route) else { return }
        path.removeSubrange((index + 1)...)
    }

    func replace(with route: Route) {
        if !path.isEmpty {
            path[path.count - 1] = route
        } else {
            path.append(route)
        }
    }

    func presentSheet(_ route: Route) {
        presentedSheet = route
    }

    func dismissSheet() {
        presentedSheet = nil
    }

    func presentFullScreenCover(_ route: Route) {
        presentedFullScreenCover = route
    }

    func dismissFullScreenCover() {
        presentedFullScreenCover = nil
    }

    var currentRoute: Route? {
        path.last
    }

    func contains(route: Route) -> Bool {
        path.contains(route)
    }

    var stackDepth: Int {
        path.count
    }
}
