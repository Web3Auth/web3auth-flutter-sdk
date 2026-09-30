// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "web3auth_flutter",
    platforms: [
        .iOS("14.0")
    ],
    products: [
        // If the plugin name contains "_", replace with "-" for the library name.
        .library(name: "web3auth-flutter", targets: ["web3auth_flutter"])
    ],
    dependencies: [
        // Keep in sync with ios/web3auth_flutter.podspec Web3Auth dependency.
        .package(
            url: "https://github.com/web3auth/web3auth-swift-sdk.git",
            from: "12.0.1"
        ),
        // Direct dependency required because Web3AuthFlutterPlugin imports
        // FetchNodeDetails (Web3AuthNetwork). SPM does not expose transitive modules.
        .package(
            url: "https://github.com/torusresearch/fetch-node-details-swift.git",
            from: "8.0.1"
        ),
        // Flutter 3.44+ requires FlutterFramework. Uncomment when targeting Flutter ≥ 3.44:
        // .package(name: "FlutterFramework", path: "../FlutterFramework"),
    ],
    targets: [
        .target(
            name: "web3auth_flutter",
            dependencies: [
                .product(name: "Web3Auth", package: "web3auth-swift-sdk"),
                .product(name: "FetchNodeDetails", package: "fetch-node-details-swift"),
                // Flutter 3.44+:
                // .product(name: "FlutterFramework", package: "FlutterFramework"),
            ]
        )
    ]
)
