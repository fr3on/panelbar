// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PanelBar",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "PanelBarCore", targets: ["PanelBarCore"])
    ],
    targets: [
        .target(name: "PanelBarCore", path: "Sources/PanelBarCore"),
        .executableTarget(
            name: "PanelBar",
            dependencies: ["PanelBarCore"],
            path: "Sources/PanelBar"
        ),
        .testTarget(
            name: "PanelBarCoreTests",
            dependencies: ["PanelBarCore"],
            path: "Tests/PanelBarCoreTests",
            resources: [.copy("Fixtures")],
            swiftSettings: [
                .unsafeFlags(["-plugin-path", "/Library/Developer/CommandLineTools/usr/lib/swift/host/plugins/testing"])
            ]
        ),
    ]
)
