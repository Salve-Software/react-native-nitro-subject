import Foundation

enum ImageUri {
  /// Resolves the uris React Native image pickers hand out — `file://` URLs
  /// and plain absolute paths — to a file URL.
  static func fileURL(from uri: String) throws -> URL {
    if uri.hasPrefix("/") { return URL(fileURLWithPath: uri) }
    if let url = URL(string: uri), url.isFileURL { return url }
    throw SubjectDetectorError.unsupportedUri(uri)
  }
}
