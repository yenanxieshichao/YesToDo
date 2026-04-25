// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "YesToDo",
    platforms: [
        .macOS(.v14)
    ],
    targets: [
        .executableTarget(
            name: "YesToDo",
            path: "ClarityTodo"
        )
    ]
)
