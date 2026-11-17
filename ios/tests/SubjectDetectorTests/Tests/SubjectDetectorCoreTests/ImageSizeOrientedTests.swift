import XCTest
@testable import SubjectDetectorCore

final class ImageSizeOrientedTests: XCTestCase {
  private let landscape = ImageSize(width: 4000, height: 3000)

  func testOrientationsWithoutQuarterTurnKeepTheSize() {
    for orientation in 1...4 {
      XCTAssertEqual(landscape.oriented(by: orientation), landscape, "orientation \(orientation)")
    }
  }

  func testQuarterTurnOrientationsSwapWidthAndHeight() {
    for orientation in 5...8 {
      XCTAssertEqual(landscape.oriented(by: orientation), ImageSize(width: 3000, height: 4000), "orientation \(orientation)")
    }
  }

  func testUnknownOrientationIsTreatedAsUpright() {
    XCTAssertEqual(landscape.oriented(by: 0), landscape)
    XCTAssertEqual(landscape.oriented(by: 9), landscape)
  }
}
