import CoreGraphics
import Vision

/// Box around the union of every foreground instance Vision segments. The
/// most accurate engine — follows the subject's actual outline.
@available(iOS 17.0, macOS 14.0, *)
struct ForegroundMaskEngine: SubjectEngine {
  let kind = SubjectEngineKind.foregroundMask

  func match(in image: CGImage) throws -> EngineMatch? {
    let request = VNGenerateForegroundInstanceMaskRequest()
    request.preferCPUOnSimulator()
    let handler = VNImageRequestHandler(cgImage: image, orientation: .up)
    try handler.perform([request])

    guard let observation = request.results?.first, !observation.allInstances.isEmpty else { return nil }

    let mask = try observation.generateScaledMaskForImage(forInstances: observation.allInstances, from: handler)
    guard let box = mask.maskBounds() else { return nil }

    return EngineMatch(box: box, confidence: Double(observation.confidence), engine: kind)
  }
}
