/**
 * Copyright Fuzed Innovations Ltd
 *
 * Run
 * swift package update; swift package generate-xcodeproj
 * to potentiate changes
 *
 **/

import PackageDescription

let package = Package(
    name: "QueryStringHelpers",
    targets: [
        Target(name: "QueryStringHelpers")
    ],
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1, minor: 7),
        .Package(url: "https://github.com/mxcl/PromiseKit.git", majorVersion: 4),
        .Package(url: "https://github.com/fuzed-innovations/swift-cloudant.git", majorVersion: 0, minor: 7),
        .Package(url: "https://github.com/IBM-Swift/SwiftyJSON.git", majorVersion: 17)
    ]
)

