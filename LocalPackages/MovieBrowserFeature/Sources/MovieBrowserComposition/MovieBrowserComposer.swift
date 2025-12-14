import Apollo
import Foundation
import SwiftUI
import MovieBrowserDomain
import MovieBrowserService
import MovieBrowserPresentation

public struct MovieBrowserComposer {
    private let service: MovieServicing

    package init(graphQLClient: GraphQLClientPerforming) {
        self.service = MovieService(graphQLClient: graphQLClient)
    }

    package init(service: MovieServicing) {
        self.service = service
    }

    @MainActor
    public func makeMovieListView(
        onNavigate: @escaping (MovieListDestination) -> Void
    ) -> some View {
        let viewModel = MovieListViewModel(service: service, onNavigate: onNavigate)
        return MovieListView(viewModel: viewModel)
    }

    @MainActor
    public func makeMovieDetailView(
        for movie: MovieSummary,
        onNavigate: @escaping (MovieDetailDestination) -> Void
    ) -> some View {
        let viewModel = MovieDetailViewModel(movie: movie, service: service, onNavigate: onNavigate)
        return MovieDetailView(viewModel: viewModel)
    }
}

public extension MovieBrowserComposer {
    static func makeDefault(baseURL: URL, token: String? = nil) -> MovieBrowserComposer {
        let client = makeClient(baseURL: baseURL, token: token)
        return MovieBrowserComposer(graphQLClient: client)
    }

    private static func makeClient(baseURL: URL, token: String?) -> ApolloClient {
        let store = ApolloStore()
        let sessionClient = URLSessionClient()
        let interceptorProvider = DefaultInterceptorProvider(client: sessionClient, store: store)
        let transport = RequestChainNetworkTransport(
            interceptorProvider: interceptorProvider,
            endpointURL: baseURL,
            autoPersistQueries: false
        )
        return ApolloClient(networkTransport: transport, store: store)
    }
}
