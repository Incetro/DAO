// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SDAO",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
        .tvOS(.v12)
    ],
    products: [
        .library(
            name: "SDAO",
            targets: ["SDAO"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Incetro/Monreau.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "SDAO",
            dependencies: [
                "Monreau"
            ]
        ),
        .testTarget(
            name: "DAOTests",
            dependencies: [
                "SDAO",
                "Monreau"
            ]
        ),
    ]
)
