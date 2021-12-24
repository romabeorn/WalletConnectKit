// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "WalletConnectKit",
    platforms: [
        .macOS(.v10_14), .iOS(.v11),
    ],
    products: [
        .library(
            name: "WalletConnectKit",
            targets: ["WalletConnectKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/WalletConnect/WalletConnectSwift.git", .upToNextMinor(from: "1.6.0"))
    ],
    targets: [
        .target(
            name: "WalletConnectKit",
            dependencies: ["WalletConnectSwift"],
            path: "WalletConnectKit"),
        .testTarget(name: "WalletConnectKitTests", dependencies: ["WalletConnectKit"], path: "Tests"),
    ],
    swiftLanguageVersions: [.v5]
)
