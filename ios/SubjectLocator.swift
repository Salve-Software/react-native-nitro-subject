import Foundation

/// Platform-independent core: uri in, subject in image pixels out. Holds no
/// Nitro types so it can be unit-tested on macOS with `swift test`.
struct SubjectLocator {
  /// Longest side of the image the engines analyse. The box is scaled back to
  /// full resolution, so this trades a few pixels of precision for speed.
  static let analysisMaxPixelSize = 1024

  let chain: SubjectEngineChain

  init(chain: SubjectEngineChain = .platformDefault()) {
    self.chain = chain
  }

  func locate(uri: String) throws -> LocatedSubject? {
    let url = try ImageUri.fileURL(from: uri)
    let image = try UprightImage.load(url: url, uri: uri, maxPixelSize: Self.analysisMaxPixelSize)

    guard let match = try chain.match(in: image.analysisImage) else { return nil }

    return LocatedSubject(
      rect: match.box.toPixels(in: image.size),
      imageSize: image.size,
      confidence: match.confidence,
      engine: match.engine
    )
  }
}
