// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "IrisCore",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .library(name: "IrisCore", targets: ["IrisCore"])
    ],
    targets: [
        .target(
            name: "IrisCore",
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        )
    ]
)
