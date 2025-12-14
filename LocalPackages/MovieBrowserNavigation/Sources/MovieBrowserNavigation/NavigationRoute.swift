import Foundation

public protocol NavigationRoute: Hashable, Identifiable {
    var identifier: String { get }
    var title: String { get }
}
