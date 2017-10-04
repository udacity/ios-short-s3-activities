// swift-tools-version:4.0
import Foundation
import PackageDescription

let package = Package(
    name: "ActivitiesService",

    products: [
        .executable(
            name: "ActivitiesServer",
            targets: ["ActivitiesServer"]
        )
    ],

    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "1.7.9"),
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.7.0"),
        .package(url: "https://github.com/nicholasjackson/swift-mysql.git", from: "1.9.0"),

        // Test imports
        .package(url: "https://github.com/nicholasjackson/kitura-http-test", from: "0.2.0")
    ],

    targets: [
        .target(name: "ActivitiesService", dependencies: ["Kitura", "HeliumLogger", "MySQL"]),
        .target(name: "ActivitiesServer", dependencies: ["ActivitiesService"]),
        .testTarget(name: "ActivitiesTests", dependencies: ["ActivitiesService", "KituraHTTPTest"]),
        .testTarget(name: "FunctionalTests", dependencies: ["ActivitiesServer"])
    ],

    swiftLanguageVersions: [3]
)
