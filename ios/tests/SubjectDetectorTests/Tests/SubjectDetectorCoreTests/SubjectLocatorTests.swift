import XCTest
@testable import SubjectDetectorCore

final class SubjectLocatorTests: XCTestCase {
  private let size = CGSize(width: 1600, height: 1200)
  private let subject = CGRect(x: 500, y: 300, width: 500, height: 700)

  func testMapsTheEngineBoxToFullResolutionPixels() throws {
    let url = try FixtureImage.write(size: size, subject: subject)
    let engine = StubEngine(.foregroundMask, .match(NormalizedBox(minX: 0.25, minY: 0.5, maxX: 0.75, maxY: 1)))

    let located = try SubjectLocator(chain: SubjectEngineChain(engines: [engine])).locate(uri: url.absoluteString)

    XCTAssertEqual(located?.imageSize, ImageSize(width: 1600, height: 1200))
    XCTAssertEqual(located?.rect, PixelRect(x: 400, y: 600, width: 800, height: 600))
    XCTAssertEqual(located?.engine, .foregroundMask)
  }

  func testEnginesSeeADownscaledCopy() throws {
    let url = try FixtureImage.write(size: size, subject: subject)
    let engine = StubEngine(.foregroundMask, .nothing)

    _ = try SubjectLocator(chain: SubjectEngineChain(engines: [engine])).locate(uri: url.path)

    let seen = try XCTUnwrap(engine.seenImages.first)
    XCTAssertEqual(max(seen.width, seen.height), SubjectLocator.analysisMaxPixelSize)
  }

  func testExifRotatedPhotoIsAnalysedAndMeasuredUpright() throws {
    // Stored portrait (1200×1600) with orientation 6, displayed as 1600×1200.
    let url = try FixtureImage.write(size: size, subject: subject, exifOrientation: 6)
    let engine = StubEngine(.foregroundMask, .match(NormalizedBox(minX: 0, minY: 0, maxX: 1, maxY: 1)))

    let located = try SubjectLocator(chain: SubjectEngineChain(engines: [engine])).locate(uri: url.path)

    XCTAssertEqual(located?.imageSize, ImageSize(width: 1600, height: 1200))
    let seen = try XCTUnwrap(engine.seenImages.first)
    XCTAssertGreaterThan(seen.width, seen.height, "engines must get the upright (landscape) image")
  }

  func testNilWhenNoEngineFindsASubject() throws {
    let url = try FixtureImage.write(size: size, subject: subject)

    let located = try SubjectLocator(chain: SubjectEngineChain(engines: [StubEngine(.foregroundMask, .nothing)])).locate(uri: url.path)

    XCTAssertNil(located)
  }

  func testUnreadableFileThrows() throws {
    let url = FileManager.default.temporaryDirectory.appendingPathComponent("not-an-image.jpg")
    try Data("hello".utf8).write(to: url)

    XCTAssertThrowsError(try SubjectLocator().locate(uri: url.path)) { error in
      XCTAssertEqual(error as? SubjectDetectorError, .unreadableImage(url.path))
    }
  }

  func testMissingFileThrows() {
    XCTAssertThrowsError(try SubjectLocator().locate(uri: "/does/not/exist.jpg")) { error in
      XCTAssertEqual(error as? SubjectDetectorError, .unreadableImage("/does/not/exist.jpg"))
    }
  }
}
