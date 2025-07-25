// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SNWebAdView",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "SNWebAdView",
            targets: ["SNWebAdView"]
        ),
    ],
    dependencies: [
        .package(
            name: "Didomi",
            url: "https://github.com/didomi/didomi-ios-sdk-spm", 
            from: "1.99.0"
        )
    ],
    targets: [
        .target(
            name: "SNWebAdView",
            dependencies: [
                .product(name: "Didomi", package: "Didomi")
            ]
        ),
        .testTarget(
            name: "SNWebAdViewTests",
            dependencies: ["SNWebAdView"]
        ),
    ]
)
