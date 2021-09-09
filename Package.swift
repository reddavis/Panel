// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "Panel",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(
            name: "Panel",
            targets: ["Panel"]
        ),
    ],
    targets: [
        .target(
            name: "Panel",
            path: "Panel",
            exclude: []
        ),
        .testTarget(
            name: "PanelTests",
            dependencies: ["Panel"],
            path: "PanelTests"
        ),
    ]
)
