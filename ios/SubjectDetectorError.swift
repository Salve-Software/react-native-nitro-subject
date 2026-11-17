import Foundation

enum SubjectDetectorError: LocalizedError, Equatable {
  case unsupportedUri(String)
  case unreadableImage(String)

  var errorDescription: String? {
    switch self {
    case .unsupportedUri(let uri):
      return "SubjectDetector: unsupported uri \"\(uri)\". Use a file:// uri or an absolute path"
    case .unreadableImage(let uri):
      return "SubjectDetector: could not decode an image at \"\(uri)\""
    }
  }
}
