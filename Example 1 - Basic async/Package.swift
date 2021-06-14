// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "Example1",
    dependencies: [
    ],
    targets: [
        .executableTarget(
            name: "Example1",
            dependencies: [],
            swiftSettings: [.unsafeFlags([
                "-Xfrontend", "-enable-experimental-concurrency",
                "-Xfrontend", "-disable-availability-checking",
            ])]
        ),
        .testTarget(
            name: "Example1Tests",
            dependencies: ["Example1"]),
    ]
)
