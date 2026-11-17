// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "SubjectDetectorTests",
  platforms: [.macOS(.v14)],
  targets: [
    // Sources/SubjectDetectorCore/*.swift are symlinks to the production files
    // in ios/ — SwiftPM doesn't allow a target path outside the package root.
    // Only the Nitro-free core is linked; HybridSubjectDetector and the
    // `toNative` mappers need the generated Nitro types.
    .target(name: "SubjectDetectorCore"),
    .testTarget(
      name: "SubjectDetectorCoreTests",
      dependencies: ["SubjectDetectorCore"],
      path: "Tests/SubjectDetectorCoreTests"
    ),
  ]
)
