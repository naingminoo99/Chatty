// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chat",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "Chatty",
            targets: ["Chatty"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/siteline/swiftui-introspect",
            from: "1.2.0"
        ),
        .package(
            url: "https://github.com/exyte/FloatingButton",
            from: "1.2.2"
        ),
        .package(
            url: "https://github.com/exyte/ActivityIndicatorView",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/onevcat/Kingfisher",
            from: "7.0.0"
        ),
        .package(
            url: "https://github.com/aws-amplify/amplify-swift",
            from: "2.35.0"
        )
    ],
    targets: [
        .target(
            name: "Chatty",
            dependencies: [
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
                .product(name: "FloatingButton", package: "FloatingButton"),
                .product(name: "ActivityIndicatorView", package: "ActivityIndicatorView"),
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "Amplify", package: "amplify-swift")
            ]
        ),
        .testTarget(
            name: "ChattyTests",
            dependencies: ["Chatty"]),
    ]
)
