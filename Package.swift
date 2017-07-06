// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "activities",

    targets: [
        Target(name: "ActivitiesService"),
        Target(name: "ActivitiesTests"),
        Target(name: "FunctionalTests")
    ],

    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 7),
        .Package(url: "../kitura-http-test", "0.2.0")
    ]
)
