import Foundation

/// Finds the subject of the photo at a uri; free of Nitro types so `swift test` can run it.
struct SubjectLocator {
  /// Longest side of the image the engines analyze.
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
