// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "Server",

    targets: [
        Target(name: "ActivitiesService"),
        Target(name: "ActivitiesServer", dependencies: ["ActivitiesService"]),
        Target(name: "ActivitiesTests", dependencies: ["ActivitiesService"]),
        Target(name: "FunctionalTests")
    ],

    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 7),
        .Package(url: "https://github.com/IBM-Swift/Swift-Kuery.git", majorVersion: 0, minor: 13),
        .Package(url: "https://github.com/IBM-Swift/SwiftKueryMySQL.git", majorVersion: 0, minor: 13),

        // Test imports
        .Package(url: "https://github.com/nicholasjackson/kitura-http-test.git", majorVersion:0, minor: 2),
        .Package(url: "../Swift-Kuery-Mock", majorVersion:0, minor: 1)
    ]
)
