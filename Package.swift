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
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.31.0"),
        .package(url: "https://github.com/Incetro/Monreau.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "SDAO",
            dependencies: [
                "Monreau",
                .product(name: "RealmSwift", package: "realm-swift")
            ]
        ),
        .testTarget(
            name: "DAOTests",
            dependencies: [
                "SDAO",
                "Monreau",
                .product(name: "RealmSwift", package: "realm-swift")
            ]
        ),
    ]
)
