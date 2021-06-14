// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "Example2",
    dependencies: [
    ],
    targets: [
        .executableTarget(
            name: "Example2",
            dependencies: [],
            swiftSettings: [.unsafeFlags([
                "-Xfrontend", "-enable-experimental-concurrency",
                "-Xfrontend", "-disable-availability-checking",
            ])]
        ),
        .testTarget(
            name: "Example2Tests",
            dependencies: ["Example2"]),
    ]
)
