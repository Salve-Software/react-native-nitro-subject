import Foundation

enum ImageUri {
  /// Converts a `file://` uri or an absolute path to a file URL.
  static func fileURL(from uri: String) throws -> URL {
    if uri.hasPrefix("/") { return URL(fileURLWithPath: uri) }
    if let url = URL(string: uri), url.isFileURL { return url }
    throw SubjectDetectorError.unsupportedUri(uri)
  }
}
