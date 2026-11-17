import CoreGraphics
import os

private let logger = Logger(subsystem: "com.salvesoftware.nitrosubject", category: "SubjectEngineChain")

/// Runs engines best-first and returns the first match. An engine that throws
/// or finds nothing hands over to the next one; the chain only throws when
/// every engine threw, so "nothing found" and "could not run" stay distinct.
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
