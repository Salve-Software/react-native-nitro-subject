import XCTest
@testable import SubjectDetectorCore

final class ImageUriTests: XCTestCase {
  func testAbsolutePathBecomesFileURL() throws {
    XCTAssertEqual(try ImageUri.fileURL(from: "/tmp/photo.jpg").path, "/tmp/photo.jpg")
  }

  func testFileURLIsKeptAndPercentDecoded() throws {
    XCTAssertEqual(try ImageUri.fileURL(from: "file:///tmp/my%20photo.jpg").path, "/tmp/my photo.jpg")
  }

  func testRemoteAndRelativeUrisAreRejected() {
    for uri in ["https://example.com/a.jpg", "ph://ABC", "photo.jpg", ""] {
      XCTAssertThrowsError(try ImageUri.fileURL(from: uri), uri) { error in
        XCTAssertEqual(error as? SubjectDetectorError, .unsupportedUri(uri))
      }
    }
  }
}
