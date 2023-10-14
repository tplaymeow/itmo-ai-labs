// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "itmo-ai-labs",
  platforms: [
    .macOS(.v11)
  ],
  products: [
    .executable(name: "itmo-ai-lab4", targets: ["itmo-ai-lab4"])
  ],
  dependencies: [
    .package(url: "https://github.com/tplaymeow/swift-matrix", branch: "main"),
    .package(url: "https://github.com/dehesa/CodableCSV.git", exact: "0.6.7"),
    .package(url: "https://github.com/SwiftyLab/MetaCodable.git", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "Utils",
      dependencies: [
        .product(name: "Matrix", package: "swift-matrix")
      ]
    ),
    .testTarget(
      name: "UtilsTests",
      dependencies: [
        "Utils",
        .product(name: "Matrix", package: "swift-matrix"),
      ]
    ),
    .executableTarget(
      name: "itmo-ai-lab4",
      dependencies: [
        "Utils",
        .product(name: "Matrix", package: "swift-matrix"),
        .product(name: "CodableCSV", package: "CodableCSV"),
        .product(name: "MetaCodable", package: "MetaCodable"),
      ]
    ),
  ]
)
