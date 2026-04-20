// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "CustomFloatingPanel",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CustomFloatingPanel",
            targets: ["CustomFloatingPanel"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CustomFloatingPanel",
            dependencies: []
        ),
        .testTarget(
            name: "CustomFloatingPanelTests",
            dependencies: ["CustomFloatingPanel"]
        )
    ]
)