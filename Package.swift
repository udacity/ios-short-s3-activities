// swift-tools-version:3.1
import Foundation
import PackageDescription

let package = Package(
    name: "ActivitiesServer",

    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 7),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1, minor: 7),
        .Package(url: "https://github.com/nicholasjackson/swift-mysql.git", majorVersion: 1, minor: 8)
    ]
)
