import XCTest
@testable import SubjectDetectorCore

final class MaskBoundsTests: XCTestCase {
  func testEmptyMaskHasNoBox() {
    XCTAssertNil(MaskBounds.box(width: 4, height: 4) { _, _ in false })
  }

  func testZeroSizedMaskHasNoBox() {
    XCTAssertNil(MaskBounds.box(width: 0, height: 4) { _, _ in true })
  }

  func testSinglePixelIncludesItsEdges() {
    let box = MaskBounds.box(width: 4, height: 4) { x, y in x == 0 && y == 0 }

    XCTAssertEqual(box, NormalizedBox(minX: 0, minY: 0, maxX: 0.25, maxY: 0.25))
  }

  func testBoxSpansDisjointRegions() {
    // Two blobs: (1,1) and (6,2) in an 8×4 mask.
    let box = MaskBounds.box(width: 8, height: 4) { x, y in (x == 1 && y == 1) || (x == 6 && y == 2) }

    XCTAssertEqual(box, NormalizedBox(minX: 0.125, minY: 0.25, maxX: 0.875, maxY: 0.75))
  }

  func testFullMaskCoversTheWholeImage() {
    XCTAssertEqual(MaskBounds.box(width: 3, height: 5) { _, _ in true }, NormalizedBox(minX: 0, minY: 0, maxX: 1, maxY: 1))
  }
}
