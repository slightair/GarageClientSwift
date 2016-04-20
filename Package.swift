import PackageDescription

let package = Package(
    name: "GarageClientSwift",
    dependencies: [
        .Package(url: "https://github.com/ishkawa/APIKit.git", majorVersion: 1, minor: 3),
        .Package(url: "https://github.com/ikesyo/Himotoki.git", majorVersion: 2),
    ]
)
