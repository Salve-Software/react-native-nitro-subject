// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "SubjectDetectorTests",
  platforms: [.macOS(.v14)],
  targets: [
    // Sources/SubjectDetectorCore/*.swift are symlinks to the files in ios/,
    // because SwiftPM doesn't allow sources outside the package. Files that
    // depend on the generated Nitro types are left out.
    .target(name: "SubjectDetectorCore"),
    .testTarget(
      name: "SubjectDetectorCoreTests",
      dependencies: ["SubjectDetectorCore"],
      path: "Tests/SubjectDetectorCoreTests"
    ),
  ]
)
