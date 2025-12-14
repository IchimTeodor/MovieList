import SwiftUI
import Foundation
import MovieBrowserComposition
import MovieBrowserNavigation

@main
struct MovieBrowserApp: App {
    private let composer: MovieBrowserComposer
    @State private var router = AppMovieBrowserRouter()

    init() {
        guard let baseURL = URL(string: "https://graphql.anilist.co") else {
            fatalError("Invalid API endpoint.")
        }
        let token = ProcessInfo.processInfo.environment["ANILIST_ACCESS_TOKEN"]
        self.composer = MovieBrowserComposer.makeDefault(baseURL: baseURL, token: token)
    }

    var body: some Scene {
        WindowGroup {
            MovieBrowserRootView(router: router, composer: composer)
        }
    }
}
