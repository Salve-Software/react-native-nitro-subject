import XCTest
@testable import SubjectDetectorCore

final class SubjectEngineChainTests: XCTestCase {
  private let box = NormalizedBox(minX: 0.1, minY: 0.1, maxX: 0.9, maxY: 0.9)
  private let image = CGContext(
    data: nil, width: 2, height: 2, bitsPerComponent: 8, bytesPerRow: 0,
    space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
  )!.makeImage()!

  func testFirstMatchWinsAndLaterEnginesDoNotRun() throws {
    let first = StubEngine(.foregroundMask, .match(box))
    let second = StubEngine(.objectnessSaliency, .match(box))

    let match = try SubjectEngineChain(engines: [first, second]).match(in: image)

    XCTAssertEqual(match?.engine, .foregroundMask)
    XCTAssertTrue(second.seenImages.isEmpty)
  }

  func testFailingEngineFallsBackToTheNext() throws {
    let chain = SubjectEngineChain(engines: [
      StubEngine(.foregroundMask, .failure(StubError())),
      StubEngine(.objectnessSaliency, .match(box)),
    ])

    XCTAssertEqual(try chain.match(in: image)?.engine, .objectnessSaliency)
  }

  func testEmptyEngineFallsBackToTheNext() throws {
    let chain = SubjectEngineChain(engines: [
      StubEngine(.foregroundMask, .nothing),
      StubEngine(.attentionSaliency, .match(box)),
    ])

    XCTAssertEqual(try chain.match(in: image)?.engine, .attentionSaliency)
  }

  func testNothingFoundIsNilNotAnError() throws {
    let chain = SubjectEngineChain(engines: [
      StubEngine(.foregroundMask, .failure(StubError())),
      StubEngine(.objectnessSaliency, .nothing),
    ])

    XCTAssertNil(try chain.match(in: image))
  }

  func testThrowsTheLastErrorWhenEveryEngineFailed() {
    let chain = SubjectEngineChain(engines: [
      StubEngine(.foregroundMask, .failure(StubError())),
      StubEngine(.objectnessSaliency, .failure(SubjectDetectorError.unreadableImage("x"))),
    ])

    XCTAssertThrowsError(try chain.match(in: image)) { error in
      XCTAssertEqual(error as? SubjectDetectorError, .unreadableImage("x"))
    }
  }
}
