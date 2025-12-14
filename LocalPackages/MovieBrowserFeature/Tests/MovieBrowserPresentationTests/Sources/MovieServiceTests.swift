import Apollo
import MovieBrowserAPI
import XCTest
@testable import MovieBrowserService
@testable import MovieBrowserDomain

final class MovieServiceTests: XCTestCase {
    func testFetchTopMoviesReturnsMappedPage() async throws {
        let mock = MockGraphQLClient()
        mock.topMoviesResponse = GraphQLResult(
            data: sampleTopMoviesData(),
            extensions: nil,
            errors: nil,
            source: .server,
            dependentKeys: nil
        )

        let service = MovieService(graphQLClient: mock)
        let page = try await service.fetchTopMovies(page: 1, perPage: 10)
        XCTAssertEqual(page.movies.count, 1)
        XCTAssertEqual(page.movies.first?.id, 42)
    }

    func testFetchDetailInfoThrowsWhenMissingPayload() async {
        let mock = MockGraphQLClient()
        mock.detailInfoResponse = GraphQLResult<MovieDetailInfoQuery.Data>(
            data: nil,
            extensions: nil,
            errors: nil,
            source: .server,
            dependentKeys: nil
        )

        let service = MovieService(graphQLClient: mock)
        do {
            _ = try await service.fetchDetailInfo(id: 10)
            XCTFail("Expected missing payload error")
        } catch {
            XCTAssertTrue(error is MovieServiceError)
        }
    }

    func testFetchDetailExtrasReturnsEmptyWhenPayloadMissing() async throws {
        let mock = MockGraphQLClient()
        mock.detailExtrasResponse = GraphQLResult<MovieDetailExtrasQuery.Data>(
            data: nil,
            extensions: nil,
            errors: nil,
            source: .server,
            dependentKeys: nil
        )

        let service = MovieService(graphQLClient: mock)
        let extras = try await service.fetchDetailExtras(id: 99)
        XCTAssertTrue(extras.cast.isEmpty)
    }
}

// MARK: - Helpers

private final class MockGraphQLClient: GraphQLClientPerforming {
    var topMoviesResponse: GraphQLResult<TopMoviesQuery.Data>?
    var detailInfoResponse: GraphQLResult<MovieDetailInfoQuery.Data>?
    var detailExtrasResponse: GraphQLResult<MovieDetailExtrasQuery.Data>?

    func fetch<Query>(
        query: Query,
        cachePolicy _: CachePolicy
    ) async throws -> GraphQLResult<Query.Data> where Query: GraphQLQuery {
        switch Query.operationName {
        case TopMoviesQuery.operationName:
            guard
                let storedResponse = topMoviesResponse,
                let response = (storedResponse as Any) as? GraphQLResult<Query.Data>
            else {
                throw MovieServiceError.missingPayload
            }
            return response
        case MovieDetailInfoQuery.operationName:
            guard
                let storedResponse = detailInfoResponse,
                let response = (storedResponse as Any) as? GraphQLResult<Query.Data>
            else {
                throw MovieServiceError.missingPayload
            }
            return response
        case MovieDetailExtrasQuery.operationName:
            guard
                let storedResponse = detailExtrasResponse,
                let response = (storedResponse as Any) as? GraphQLResult<Query.Data>
            else {
                throw MovieServiceError.missingPayload
            }
            return response
        default:
            fatalError("Unhandled query type \(Query.operationName)")
        }
    }

}

private func sampleTopMoviesData() -> TopMoviesQuery.Data {
    let data: [String: Any] = [
        "__typename": "Query",
        "Page": [
            "__typename": "Page",
            "pageInfo": [
                "__typename": "PageInfo",
                "currentPage": 1,
                "hasNextPage": false
            ],
            "media": [
                [
                    "__typename": "Media",
                    "id": 42,
                    "title": [
                        "__typename": "MediaTitle",
                        "english": "Test",
                        "romaji": "Test"
                    ],
                    "averageScore": 80,
                    "genres": ["Action", "Drama"],
                    "coverImage": [
                        "__typename": "MediaCoverImage",
                        "extraLarge": "https://image",
                        "large": "https://image"
                    ],
                    "isFavourite": false,
                    "format": "MOVIE",
                    "startDate": [
                        "__typename": "FuzzyDate",
                        "year": 2022
                    ],
                    "endDate": [
                        "__typename": "FuzzyDate",
                        "year": 2022
                    ]
                ]
            ]
        ]
    ]
    return try! TopMoviesQuery.Data(data: data)
}
