import CoreGraphics
@testable import SubjectDetectorCore

/// Engine with a scripted answer that records the images it was shown.
final class StubEngine: SubjectEngine {
  enum Answer {
    case match(NormalizedBox)
    case nothing
    case failure(Error)
  }

  let kind: SubjectEngineKind
  private let answer: Answer
  private(set) var seenImages: [CGImage] = []

  init(_ kind: SubjectEngineKind, _ answer: Answer) {
    self.kind = kind
    self.answer = answer
  }

  func match(in image: CGImage) throws -> EngineMatch? {
    seenImages.append(image)
    switch answer {
    case .match(let box): return EngineMatch(box: box, confidence: 0.5, engine: kind)
    case .nothing: return nil
    case .failure(let error): throw error
    }
  }
}

struct StubError: Error, Equatable {}
