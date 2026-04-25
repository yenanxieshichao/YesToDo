// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ClarityTodo",
    platforms: [
        .macOS(.v14)
    ],
    targets: [
        .executableTarget(
            name: "ClarityTodo",
            path: "ClarityTodo"
        )
    ]
)
