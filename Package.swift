// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Anima",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "AnimaCore",
            targets: ["AnimaCore"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AnimaCore",
            dependencies: [],
            path: "Anima",
            exclude: ["Assets.xcassets"],
            sources: [
                "Models/EventManager.swift",
                "Views/Components/GlassModifier.swift",
                "Views/Components/AnimatedBackgroundView.swift",
                "Views/Components/DynamicIslandView.swift",
                "Views/Components/InteractiveNotchView.swift",
                "Views/Calendar/MonthView.swift",
                "Views/Calendar/WeekStripView.swift",
                "Views/Calendar/ScheduleListView.swift",
                "ContentView.swift"
            ]
        ),
    ]
)
