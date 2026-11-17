import CoreGraphics

protocol SubjectEngine {
  var kind: SubjectEngineKind { get }

  /// Locates the subject in an upright image; nil when there is none.
  func match(in image: CGImage) throws -> EngineMatch?
}
