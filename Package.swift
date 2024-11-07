// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chat",
    platforms: [
        .iOS(.v17),
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
            from: "1.3.0"
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
            url: "https://github.com/naingminoo99/MediaCache",
            from: "1.2.1"
        )
    ],
    targets: [
        .target(
            name: "Chatty",
            dependencies: [
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
                .product(name: "FloatingButton", package: "FloatingButton"),
                .product(name: "ActivityIndicatorView", package: "ActivityIndicatorView"),
                .product(name: "MediaCache", package: "MediaCache"),
            ]
        ),
        .testTarget(
            name: "ChattyTests",
            dependencies: ["Chatty"]),
    ]
)
