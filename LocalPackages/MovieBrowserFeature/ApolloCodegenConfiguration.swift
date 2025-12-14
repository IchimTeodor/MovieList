import ApolloCodegenConfiguration
import Foundation

let schemaOutputFolder = URL(fileURLWithPath: "./GraphQL")
let schemaFileName = "schema.graphqls"

let schemaDownloadConfiguration = ApolloSchemaDownloadConfiguration(
    using: .introspection(endpointURL: URL(string: "https://graphql.anilist.co")!),
    outputFolderURL: schemaOutputFolder,
    outputFilename: schemaFileName
)

let configuration = ApolloCodegenConfiguration(
    schemaNamespace: "MovieBrowserAPI",
    input: .init(
        schemaPath: "GraphQL/\(schemaFileName)",
        operationSearchPaths: ["GraphQL/Operations/**/*.graphql"]
    ),
    output: .init(
        schemaTypes: .init(
            path: "Sources/MovieBrowserService/API",
            moduleType: .swiftPackageManager
        ),
        operations: .inSchemaModule
    ),
    options: .init(
        queryStringLiteralFormat: .multiline
    ),
    schemaDownloadConfiguration: schemaDownloadConfiguration
)
