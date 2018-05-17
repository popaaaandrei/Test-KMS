// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Test-KMS",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: "https://github.com/popaaaandrei/auth-library-swift.git", from: "0.3.7"),
        .package(url: "https://github.com/vapor/vapor.git", from: "2.0.1"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "0.9.0"),
        .package(url: "https://github.com/popaaaandrei/BigInt", from: "3.0.4"),
        .package(url: "https://github.com/timburks/SwiftyBase64", from: "1.2.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Test-KMS",
            dependencies: ["Vapor", "CryptoSwift", "BigInt", "SwiftyBase64"]),
    ]
)
