import Foundation

/// A subject in pixels of the full-resolution upright image.
struct LocatedSubject: Equatable {
  let rect: PixelRect
  let imageSize: ImageSize
  let confidence: Double?
  let engine: SubjectEngineKind
}
