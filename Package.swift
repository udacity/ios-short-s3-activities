// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "ActivitiesService",

    products: [
        .executable(name: "ActivitiesServer", targets: ["ActivitiesServer"]),
    ],

    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "1.7.0"),
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.0.0"),
        //.package(url: "https://github.com/nicholasjackson/swift-mysql.git", from: "1.1.0"),
        .package(url: "https://github.com/jarrodparkes/swift-mysql.git", .branch("master")),

        // test imports
        .package(url: "https://github.com/nicholasjackson/kitura-http-test.git", from: "0.2.0")
    ],

    targets: [
        .target(name: "ActivitiesService", dependencies: ["Kitura", "HeliumLogger", "MySQL"]),
        .target(name: "ActivitiesServer", dependencies: ["ActivitiesService"]),
        .testTarget(name: "ActivitiesTests", dependencies: ["ActivitiesService"]),
        .testTarget(name: "FunctionalTests")
    ],

    swiftLanguageVersions: [3]
)
