import Foundation

/// What one engine found, before it is mapped to image pixels.
struct EngineMatch: Equatable {
  let box: NormalizedBox
  let confidence: Double?
  let engine: SubjectEngineKind
}
