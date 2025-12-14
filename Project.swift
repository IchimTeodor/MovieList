import ProjectDescription

let projectName = "MovieBrowser"
let organizationIdentifier = "com.agilefreaks.moviebrowser"
let deploymentTargets: DeploymentTargets = .iOS("17.0")

let project = Project(
    name: projectName,
    organizationName: "Agile Freaks",
    options: .options(
        automaticSchemesOptions: .disabled
    ),
    packages: [
        .package(path: "./LocalPackages/MovieBrowserFeature"),
        .package(path: "./LocalPackages/DesignSystem"),
        .package(path: "./LocalPackages/MovieBrowserNavigation"),
        .package(url: "https://github.com/SvenTiigi/YouTubePlayerKit.git", from: "2.0.0")
    ],
    settings: .settings(
        base: [
            "CODE_SIGN_STYLE": "Automatic",
            "DEVELOPMENT_TEAM": "",
            "SWIFT_VERSION": "5.10"
        ],
        defaultSettings: .recommended
    ),
    targets: [
        .target(
            name: projectName,
            destinations: Destinations([.iPhone]),
            product: .app,
            bundleId: organizationIdentifier,
            deploymentTargets: deploymentTargets,
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": [:],
                "UIUserInterfaceStyle": "Dark"
            ]),
            sources: ["Targets/AppHost/Sources/**"],
            resources: ["Targets/AppHost/Resources/**"],
            dependencies: [
                .package(product: "MovieBrowserComposition"),
                .package(product: "MovieBrowserDomain"),
                .package(product: "DesignSystem"),
                .package(product: "MovieBrowserNavigation"),
                .package(product: "YouTubePlayerKit")
            ]
        ),
        .target(
            name: "\(projectName)Tests",
            destinations: Destinations([.iPhone]),
            product: .unitTests,
            bundleId: "\(organizationIdentifier).tests",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: [
                "LocalPackages/MovieBrowserFeature/Tests/MovieBrowserPresentationTests/Sources/**"
            ],
            dependencies: [
                .target(name: projectName),
                .package(product: "MovieBrowserPresentation"),
                .package(product: "MovieBrowserDomain"),
                .package(product: "MovieBrowserService"),
                .package(product: "YouTubePlayerKit")
            ]
        )
    ],
    schemes: [
        Scheme.scheme(
            name: projectName,
            shared: true,
            buildAction: .buildAction(targets: [.target(projectName)]),
            runAction: .runAction(configuration: .debug, executable: .target(projectName))
        ),
        Scheme.scheme(
            name: "\(projectName)+UnitTests",
            shared: true,
            buildAction: .buildAction(targets: [.target(projectName)]),
            testAction: .testPlans(
                [.relativeToRoot("MovieBrowserPresentationTests.xctestplan")],
                configuration: .debug
            ),
            runAction: .runAction(configuration: .debug, executable: .target(projectName))
        )
    ]
)
