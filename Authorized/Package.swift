// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Authorized",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Authorized",
            targets: ["Authorized"]
        ),
    ],
    dependencies: [
        .package(path: "Services"),
        .package(path: "DependencyContainer")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Authorized",
            dependencies: ["Services", "DependencyContainer"]
        ),
        .testTarget(name: "AuthorizedTests",
                    dependencies: ["Authorized"])
    ]
)
