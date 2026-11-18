// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "SubjectDetectorTests",
  platforms: [.macOS(.v14)],
  targets: [
    .target(name: "SubjectDetectorCore"),
    .testTarget(
      name: "SubjectDetectorCoreTests",
      dependencies: ["SubjectDetectorCore"],
      path: "Tests/SubjectDetectorCoreTests"
    ),
  ]
)
