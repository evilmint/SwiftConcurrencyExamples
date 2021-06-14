// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "Example4",
    dependencies: [
    ],
    targets: [
        .executableTarget(
            name: "Example4",
            dependencies: [],
            swiftSettings: [.unsafeFlags([
                "-Xfrontend", "-enable-experimental-concurrency",
                "-Xfrontend", "-disable-availability-checking",
            ])]
        ),
    ]
)
