import Apollo
import ApolloAPI

public protocol GraphQLClientPerforming {
    func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy
    ) async throws -> GraphQLResult<Query.Data>
}

extension ApolloClient: GraphQLClientPerforming {
    public func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy
    ) async throws -> GraphQLResult<Query.Data> {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: (any Cancellable)?
            cancellable = self.fetch(query: query, cachePolicy: cachePolicy) { result in
                cancellable = nil
                continuation.resume(with: result)
            }
            _ = cancellable
        }
    }
}
