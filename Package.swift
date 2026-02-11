// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "WorkoutPlannerCore",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "WorkoutPlannerCore", targets: ["WorkoutPlannerCore"])
    ],
    targets: [
        .target(name: "WorkoutPlannerCore"),
        .testTarget(name: "WorkoutPlannerCoreTests", dependencies: ["WorkoutPlannerCore"])
    ]
)
