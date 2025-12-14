import XCTest
@testable import MovieBrowserPresentation
@testable import MovieBrowserDomain

@MainActor
final class MovieListViewModelTests: XCTestCase {
    func testLoadInitialIfNeededPopulatesMoviesAndFavorites() async {
        let service = MovieServiceStub()
        let movies = [
            MovieTestData.makeSummary(id: 1),
            MovieTestData.makeSummary(id: 2, isFavorite: true)
        ]
        service.enqueueTopMoviesResult(.success(MovieTestData.makePage(index: 1, hasNextPage: true, movies: movies)))
        let sut = MovieListViewModel(service: service, onNavigate: { _ in })

        await sut.loadInitialIfNeeded()

        XCTAssertEqual(service.requestedPages, [1])
        XCTAssertEqual(sut.movies, movies)
        XCTAssertEqual(sut.favoriteMovies, [movies[1]])
        XCTAssertFalse(sut.isInitialLoading)
        XCTAssertNil(sut.errorMessage)
    }

    func testLoadMoreIfNeededAppendsNextPage() async {
        let service = MovieServiceStub()
        let firstPage = MovieTestData.makePage(
            index: 1,
            hasNextPage: true,
            movies: (1...4).map { MovieTestData.makeSummary(id: $0) }
        )
        let secondPage = MovieTestData.makePage(
            index: 2,
            hasNextPage: false,
            movies: (5...6).map { MovieTestData.makeSummary(id: $0) }
        )
        service.enqueueTopMoviesResult(.success(firstPage))
        service.enqueueTopMoviesResult(.success(secondPage))
        let sut = MovieListViewModel(service: service, onNavigate: { _ in })

        await sut.loadInitialIfNeeded()
        guard let triggerMovie = sut.movies[safe: 1] else {
            return XCTFail("Expected second movie to trigger pagination")
        }
        await sut.loadMoreIfNeeded(for: triggerMovie)

        XCTAssertEqual(service.requestedPages, [1, 2])
        XCTAssertEqual(sut.movies.map(\.id), [1, 2, 3, 4, 5, 6])
        XCTAssertNil(sut.errorMessage)
    }

    func testLoadInitialFailureSetsErrorMessage() async {
        let service = MovieServiceStub()
        service.enqueueTopMoviesResult(.failure(TestError()))
        let sut = MovieListViewModel(service: service, onNavigate: { _ in })

        await sut.loadInitialIfNeeded()

        XCTAssertEqual(sut.movies.count, 0)
        XCTAssertEqual(sut.errorMessage, TestError().localizedDescription)
        XCTAssertFalse(sut.isInitialLoading)
    }

    func testDidSelectMovieNavigatesToDetail() async {
        let service = MovieServiceStub()
        let movies = [MovieTestData.makeSummary(id: 7)]
        service.enqueueTopMoviesResult(.success(MovieTestData.makePage(index: 1, hasNextPage: false, movies: movies)))
        var receivedDestination: MovieListDestination?
        let sut = MovieListViewModel(service: service) { destination in
            receivedDestination = destination
        }

        await sut.loadInitialIfNeeded()
        guard let firstMovie = sut.movies.first else {
            return XCTFail("Expected a loaded movie")
        }
        sut.didSelect(movie: firstMovie)

        XCTAssertEqual(receivedDestination, .detail(firstMovie))
    }
}

private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
