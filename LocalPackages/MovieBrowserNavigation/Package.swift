// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "MovieBrowserNavigation",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "MovieBrowserNavigation",
            targets: ["MovieBrowserNavigation"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "MovieBrowserNavigation",
            dependencies: [
            ],
            path: "Sources"
        )
    ]
)
