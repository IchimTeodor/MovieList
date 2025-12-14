import XCTest
@testable import MovieBrowserPresentation
@testable import MovieBrowserDomain

@MainActor
final class MovieDetailViewModelTests: XCTestCase {
    func testLoadIfNeededPopulatesDetail() async {
        let service = MovieServiceStub()
        let summary = MovieTestData.makeSummary(id: 10)
        let detail = MovieTestData.makeDetail(movieID: summary.id)
        service.detailInfoResult = .success(detail)
        let sut = MovieDetailViewModel(movie: summary, service: service, onNavigate: { _ in })

        await sut.loadIfNeeded()

        XCTAssertEqual(service.fetchDetailInfoCallCount, 1)
        XCTAssertEqual(sut.contentState, .loaded(detail))
        XCTAssertEqual(sut.extrasState, .idle)
        XCTAssertNil(sut.errorMessage)
    }

    func testRefreshAfterFailureClearsError() async {
        let service = MovieServiceStub()
        let summary = MovieTestData.makeSummary()
        service.detailInfoResult = .failure(TestError())
        let sut = MovieDetailViewModel(movie: summary, service: service, onNavigate: { _ in })

        await sut.loadIfNeeded()
        XCTAssertEqual(service.fetchDetailInfoCallCount, 1)
        XCTAssertEqual(sut.contentState, .failed(TestError().localizedDescription))
        XCTAssertNotNil(sut.errorMessage)

        service.detailInfoResult = .success(MovieTestData.makeDetail(movieID: summary.id))
        service.detailExtrasResult = .success(MovieTestData.makeExtras())

        await sut.refresh()

        XCTAssertEqual(service.fetchDetailInfoCallCount, 2)
        if case .loaded = sut.contentState {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected loaded state")
        }
        XCTAssertNotNil(sut.detail)
        XCTAssertNil(sut.errorMessage)
    }

    func testLoadExtrasPopulatesCast() async {
        let service = MovieServiceStub()
        let summary = MovieTestData.makeSummary()
        let detail = MovieTestData.makeDetail(movieID: summary.id)
        let extras = MovieTestData.makeExtras(cast: [
            MovieTestData.makeCastMember(id: 7),
            MovieTestData.makeCastMember(id: 11)
        ])
        service.detailInfoResult = .success(detail)
        service.detailExtrasResult = .success(extras)
        let sut = MovieDetailViewModel(movie: summary, service: service, onNavigate: { _ in })

        await sut.loadIfNeeded()
        await sut.loadExtras()

        XCTAssertEqual(service.fetchDetailExtrasCallCount, 1)
        XCTAssertEqual(sut.extrasState, .loaded)
        XCTAssertEqual(sut.detail?.cast, extras.cast)
    }

    func testLoadExtrasFailureUpdatesState() async {
        let service = MovieServiceStub()
        let summary = MovieTestData.makeSummary()
        let detail = MovieTestData.makeDetail(movieID: summary.id)
        service.detailInfoResult = .success(detail)
        service.detailExtrasResult = .failure(TestError())
        let sut = MovieDetailViewModel(movie: summary, service: service, onNavigate: { _ in })

        await sut.loadIfNeeded()
        await sut.loadExtras()

        XCTAssertEqual(sut.extrasState, .failed(TestError().localizedDescription))
        XCTAssertEqual(service.fetchDetailExtrasCallCount, 1)
        XCTAssertEqual(sut.detail?.cast, detail.cast)
    }

    func testRetryExtrasRetriesAfterFailure() async {
        let service = MovieServiceStub()
        let summary = MovieTestData.makeSummary()
        service.detailInfoResult = .success(MovieTestData.makeDetail(movieID: summary.id))
        service.detailExtrasResult = .failure(TestError())
        let sut = MovieDetailViewModel(movie: summary, service: service, onNavigate: { _ in })

        await sut.loadIfNeeded()
        await sut.loadExtras()

        XCTAssertEqual(sut.extrasState, .failed(TestError().localizedDescription))
        XCTAssertEqual(service.fetchDetailExtrasCallCount, 1)

        service.detailExtrasResult = .success(MovieTestData.makeExtras())
        await sut.retryExtras()

        XCTAssertEqual(service.fetchDetailExtrasCallCount, 2)
        XCTAssertEqual(sut.extrasState, .loaded)
        XCTAssertEqual(sut.detail?.cast.count, MovieTestData.makeExtras().cast.count)
    }

    func testTrailerSourcePrefersYouTube() {
        let summary = MovieTestData.makeSummary()
        let sut = MovieDetailViewModel(movie: summary, service: MovieServiceStub(), onNavigate: { _ in })
        let detail = MovieTestData.makeDetail(
            movieID: summary.id,
            trailerSite: "YouTube",
            trailerVideoID: "abc123",
            trailerURL: URL(string: "https://example.com/direct.mp4")
        )

        let source = sut.trailerSource(for: detail)

        XCTAssertEqual(source, .youtube(id: "abc123"))
    }

    func testTrailerSourceFallsBackToDirectURL() {
        let summary = MovieTestData.makeSummary()
        let sut = MovieDetailViewModel(movie: summary, service: MovieServiceStub(), onNavigate: { _ in })
        let detail = MovieTestData.makeDetail(
            movieID: summary.id,
            trailerSite: "Vimeo",
            trailerVideoID: nil,
            trailerURL: URL(string: "https://example.com/direct.mp4")
        )

        let source = sut.trailerSource(for: detail)

        XCTAssertEqual(source, .direct(URL(string: "https://example.com/direct.mp4")!))
    }
}
