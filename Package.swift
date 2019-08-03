// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "XCEAPIClient",
    products: [
        .library(
            name: "XCEAPIClient",
            targets: [
                "XCEAPIClient"
            ]
        )
    ],
    targets: [
        .target(
            name: "XCEAPIClient",
            path: "Sources/Core"
        ),
        .testTarget(
            name: "XCEAPIClientAllTests",
            dependencies: [
                "XCEAPIClient"
            ],
            path: "Tests/AllTests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)