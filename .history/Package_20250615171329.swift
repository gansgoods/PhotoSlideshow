// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TestApp",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .executable(name: "TestApp", targets: ["TestApp"])
    ],
    targets: [
        .executableTarget(
            name: "TestApp",
            dependencies: []
        )
    ]
) 