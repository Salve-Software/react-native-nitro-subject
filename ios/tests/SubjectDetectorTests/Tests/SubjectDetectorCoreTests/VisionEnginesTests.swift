import XCTest
@testable import SubjectDetectorCore

/// Runs the real Vision engines on the Mac against a generated photo.
final class VisionEnginesTests: XCTestCase {
  private let size = CGSize(width: 1600, height: 1200)
  private let subject = CGRect(x: 500, y: 300, width: 500, height: 700)

  func testForegroundMaskFindsTheSubject() throws {
    let url = try FixtureImage.write(size: size, subject: subject)
    let chain = SubjectEngineChain(engines: [ForegroundMaskEngine()])

    let located = try XCTUnwrap(try SubjectLocator(chain: chain).locate(uri: url.path))

    XCTAssertEqual(located.engine, .foregroundMask)
    assertCovers(located.rect, subject, tolerance: 60)
  }

  func testObjectnessSaliencyFindsTheSubject() throws {
    let url = try FixtureImage.write(size: size, subject: subject)
    let chain = SubjectEngineChain(engines: [SaliencyEngine(kind: .objectnessSaliency)])

    let located = try XCTUnwrap(try SubjectLocator(chain: chain).locate(uri: url.path))

    XCTAssertEqual(located.engine, .objectnessSaliency)
    assertOverlaps(located.rect, subject)
  }

  func testForegroundMaskOnExifRotatedPhotoMatchesTheUprightOne() throws {
    let upright = try FixtureImage.write(size: size, subject: subject)
    let rotated = try FixtureImage.write(size: size, subject: subject, exifOrientation: 6)
    let locator = SubjectLocator(chain: SubjectEngineChain(engines: [ForegroundMaskEngine()]))

    let a = try XCTUnwrap(try locator.locate(uri: upright.path))
    let b = try XCTUnwrap(try locator.locate(uri: rotated.path))

    XCTAssertEqual(a.imageSize, b.imageSize)
    XCTAssertEqual(a.rect.x, b.rect.x, accuracy: 8)
    XCTAssertEqual(a.rect.y, b.rect.y, accuracy: 8)
    XCTAssertEqual(a.rect.width, b.rect.width, accuracy: 8)
    XCTAssertEqual(a.rect.height, b.rect.height, accuracy: 8)
  }

  /// Every edge of `rect` is within `tolerance` pixels of `expected`.
  private func assertCovers(_ rect: PixelRect, _ expected: CGRect, tolerance: Double, file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertEqual(rect.x, expected.minX, accuracy: tolerance, "left", file: file, line: line)
    XCTAssertEqual(rect.y, expected.minY, accuracy: tolerance, "top", file: file, line: line)
    XCTAssertEqual(rect.x + rect.width, expected.maxX, accuracy: tolerance, "right", file: file, line: line)
    XCTAssertEqual(rect.y + rect.height, expected.maxY, accuracy: tolerance, "bottom", file: file, line: line)
  }

  /// The center of `expected` is inside `rect`.
  private func assertOverlaps(_ rect: PixelRect, _ expected: CGRect, file: StaticString = #filePath, line: UInt = #line) {
    let box = CGRect(x: rect.x, y: rect.y, width: rect.width, height: rect.height)
    XCTAssertTrue(box.contains(CGPoint(x: expected.midX, y: expected.midY)), "\(box) misses \(expected)", file: file, line: line)
  }
}
