// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "itmo-ai-labs",
  platforms: [
    .macOS(.v13)
  ],
  products: [
    .executable(name: "itmo-ai-lab4", targets: ["itmo-ai-lab4"]),
    .executable(name: "itmo-ai-lab5", targets: ["itmo-ai-lab5"]),
  ],
  dependencies: [
    .package(url: "https://github.com/tplaymeow/swift-matrix", branch: "main"),
    .package(url: "https://github.com/dehesa/CodableCSV.git", exact: "0.6.7"),
    .package(url: "https://github.com/SwiftyLab/MetaCodable.git", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-numerics", from: "1.0.0"),
    .package(url: "https://github.com/tplaymeow/swift-text-table", branch: "main"),
  ],
  targets: [
    .target(
      name: "StandardScaler",
      dependencies: [
        .product(name: "Matrix", package: "swift-matrix")
      ]
    ),
    .target(
      name: "LinearRegression",
      dependencies: [
        .product(name: "Matrix", package: "swift-matrix")
      ]
    ),
    .target(
      name: "KNearestNeighbors",
      dependencies: [
        .product(name: "Numerics", package: "swift-numerics"),
        .product(name: "Algorithms", package: "swift-algorithms"),
        .product(name: "Matrix", package: "swift-matrix"),
      ]
    ),
    .target(
      name: "Plot"
    ),
    .target(
      name: "Utils",
      dependencies: [
        .product(name: "Matrix", package: "swift-matrix")
      ]
    ),
    .executableTarget(
      name: "itmo-ai-lab4",
      dependencies: [
        "Utils",
        "StandardScaler",
        "LinearRegression",
        "Plot",
        .product(name: "Matrix", package: "swift-matrix"),
        .product(name: "CodableCSV", package: "CodableCSV"),
        .product(name: "MetaCodable", package: "MetaCodable"),
      ]
    ),
    .executableTarget(
      name: "itmo-ai-lab5",
      dependencies: [
        "Utils",
        "KNearestNeighbors",
        "StandardScaler",
        .product(name: "TextTable", package: "swift-text-table"),
        .product(name: "Algorithms", package: "swift-algorithms"),
        .product(name: "Matrix", package: "swift-matrix"),
        .product(name: "CodableCSV", package: "CodableCSV"),
        .product(name: "MetaCodable", package: "MetaCodable"),
      ]
    ),
  ]
)
