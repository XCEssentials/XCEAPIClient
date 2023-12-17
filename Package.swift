// swift-tools-version:5.9

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
            name: "XCEAPIClient"
        ),
        .testTarget(
            name: "XCEAPIClientAllTests",
            dependencies: [
                "XCEAPIClient"
            ]
        ),
    ]
)
