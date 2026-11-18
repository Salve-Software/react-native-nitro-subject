import CoreGraphics
import os

private let logger = Logger(subsystem: "com.salvesoftware.nitrosubject", category: "SubjectEngineChain")

/// Runs the engines in order and returns the first match; throws only if all of them threw.
struct SubjectEngineChain {
  let engines: [SubjectEngine]

  func match(in image: CGImage) throws -> EngineMatch? {
    var lastError: Error?
    var anyEngineRan = false

    for engine in engines {
      do {
        if let match = try engine.match(in: image) { return match }
        anyEngineRan = true
        logger.debug("\(engine.kind.rawValue, privacy: .public) found nothing")
      } catch {
        lastError = error
        logger.debug("\(engine.kind.rawValue, privacy: .public) failed: \(error.localizedDescription, privacy: .public)")
      }
    }

    if !anyEngineRan, let lastError { throw lastError }
    return nil
  }
}
