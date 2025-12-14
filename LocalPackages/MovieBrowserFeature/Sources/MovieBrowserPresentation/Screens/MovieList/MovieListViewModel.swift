import Foundation
import MovieBrowserDomain
import MovieBrowserService

@MainActor
package final class MovieListViewModel: ObservableObject {
    @Published private(set) var movies: [MovieSummary] = []
    @Published private(set) var isInitialLoading = false
    @Published private(set) var isPaginating = false
    @Published private(set) var errorMessage: String?

    private let service: MovieServicing
    private let onNavigate: (MovieListDestination) -> Void
    private var currentPage = 0
    private var hasNextPage = true
    private let pageSize = 12

    package init(
        service: MovieServicing,
        onNavigate: @escaping (MovieListDestination) -> Void
    ) {
        self.service = service
        self.onNavigate = onNavigate
    }

    func loadInitialIfNeeded() async {
        guard !isInitialLoading, movies.isEmpty else {
            return
        }
        await loadPage(reset: true)
    }

    func refresh() async {
        await loadPage(reset: true)
    }

    func loadMoreIfNeeded(for movie: MovieSummary) async {
        let thresholdIndex = movies.index(movies.endIndex, offsetBy: -3, limitedBy: movies.startIndex) ?? movies.startIndex
        if movies.firstIndex(where: { $0.id == movie.id }) == thresholdIndex {
            await loadPage(reset: false)
        }
    }

    func retry() async {
        await loadPage(reset: movies.isEmpty)
    }

    func didSelect(movie: MovieSummary) {
        onNavigate(.detail(movie))
    }

    var favoriteMovies: [MovieSummary] {
        movies.filter { $0.isFavorite }
    }

    private func loadPage(reset: Bool) async {
        if reset {
            isInitialLoading = true
            currentPage = 0
            hasNextPage = true
        } else if isPaginating || !hasNextPage {
            return
        } else {
            isPaginating = true
        }

        do {
            let nextPage = reset ? 1 : currentPage + 1
            let page = try await service.fetchTopMovies(page: nextPage, perPage: pageSize)
            currentPage = page.index
            hasNextPage = page.hasNextPage
            if reset {
                movies = page.movies
            } else {
                movies.append(contentsOf: page.movies)
            }
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }

        isInitialLoading = false
        isPaginating = false
    }

    deinit {}
}
