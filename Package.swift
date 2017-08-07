// swift-tools-version:3.1
import Foundation
import PackageDescription

let package = Package(
    name: "ActivitiesService",

    targets: [
        Target(name: "ActivitiesService"), 
        Target(name: "ActivitiesServer", dependencies: ["ActivitiesService"]),
    ],

    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 7),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1, minor: 7),
        .Package(url: "https://github.com/nicholasjackson/swift-mysql.git", majorVersion: 1, minor: 2)
    ]
)

if ProcessInfo.processInfo.environment["TEST"] != nil {
    package.targets.append(Target(name: "ActivitiesTests", dependencies: ["ActivitiesService"]))
    package.targets.append(Target(name: "FunctionalTests"))
    package.dependencies.append(.Package(
        url: "https://github.com/nicholasjackson/kitura-http-test.git", 
        majorVersion: 0, 
        minor: 2)
    )
}
