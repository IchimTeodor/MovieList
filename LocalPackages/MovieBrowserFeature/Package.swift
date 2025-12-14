// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "MovieBrowserFeature",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "MovieBrowserDomain", targets: ["MovieBrowserDomain"]),
        .library(name: "MovieBrowserService", targets: ["MovieBrowserService"]),
        .library(name: "MovieBrowserPresentation", targets: ["MovieBrowserPresentation"]),
        .library(name: "MovieBrowserComposition", targets: ["MovieBrowserComposition"])
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(url: "https://github.com/apollographql/apollo-ios.git", from: "1.25.3"),
        .package(url: "https://github.com/SvenTiigi/YouTubePlayerKit.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "MovieBrowserDomain",
            dependencies: [],
            path: "Sources/MovieBrowserDomain"
        ),
        .target(
            name: "MovieBrowserService",
            dependencies: [
                "MovieBrowserDomain",
                "MovieBrowserAPI",
                .product(name: "Apollo", package: "apollo-ios"),
                .product(name: "ApolloAPI", package: "apollo-ios")
            ],
            path: "Sources/MovieBrowserService",
            exclude: ["API"]
        ),
        .target(
            name: "MovieBrowserAPI",
            dependencies: [
                .product(name: "ApolloAPI", package: "apollo-ios")
            ],
            path: "Sources/MovieBrowserService/API/Sources"
        ),
        .target(
            name: "MovieBrowserPresentation",
            dependencies: [
                "MovieBrowserDomain",
                "MovieBrowserService",
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: "YouTubePlayerKit", package: "YouTubePlayerKit")
            ],
            path: "Sources/MovieBrowserPresentation"
        ),
        .target(
            name: "MovieBrowserComposition",
            dependencies: [
                "MovieBrowserDomain",
                "MovieBrowserService",
                "MovieBrowserPresentation",
                .product(name: "Apollo", package: "apollo-ios")
            ],
            path: "Sources/MovieBrowserComposition"
        ),
        .testTarget(
            name: "MovieBrowserPresentationTests",
            dependencies: [
                "MovieBrowserPresentation",
                "MovieBrowserDomain",
                "MovieBrowserService",
                "MovieBrowserAPI",
                .product(name: "YouTubePlayerKit", package: "YouTubePlayerKit")
            ],
            path: "Tests/MovieBrowserPresentationTests/Sources"
        )
    ]
)
