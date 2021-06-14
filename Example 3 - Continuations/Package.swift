// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "Example3",
    dependencies: [
    ],
    targets: [
        .executableTarget(
            name: "Example3",
            dependencies: [],
            swiftSettings: [.unsafeFlags([
                "-Xfrontend", "-enable-experimental-concurrency",
                "-Xfrontend", "-disable-availability-checking",
            ])]
        ),
        .testTarget(
            name: "Example3Tests",
            dependencies: ["Example3"]),
    ]
)
