import XCTest
@testable import SubjectDetectorCore

final class NormalizedBoxTests: XCTestCase {
  func testVisionRectIsFlippedToTopLeftOrigin() {
    // Vision: bottom-left origin. A box hugging the bottom of the image…
    let box = NormalizedBox(visionRect: CGRect(x: 0.2, y: 0, width: 0.5, height: 0.25))

    // …is at the bottom in top-left coordinates too.
    XCTAssertEqual(box, NormalizedBox(minX: 0.2, minY: 0.75, maxX: 0.7, maxY: 1))
  }

  func testToPixelsScalesByTheImageSize() {
    let box = NormalizedBox(minX: 0.25, minY: 0.5, maxX: 0.75, maxY: 1)

    XCTAssertEqual(box.toPixels(in: ImageSize(width: 4000, height: 3000)), PixelRect(x: 1000, y: 1500, width: 2000, height: 1500))
  }
}
