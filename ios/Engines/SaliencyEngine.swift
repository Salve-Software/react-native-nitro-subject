import CoreGraphics
import Vision

/// Most confident salient region. Objectness looks for objects; attention
/// for where a person would look first, so it nearly always answers.
struct SaliencyEngine: SubjectEngine {
  let kind: SubjectEngineKind

  func match(in image: CGImage) throws -> EngineMatch? {
    let request: VNImageBasedRequest =
      kind == .attentionSaliency
      ? VNGenerateAttentionBasedSaliencyImageRequest()
      : VNGenerateObjectnessBasedSaliencyImageRequest()
    request.preferCPUOnSimulator()
    try VNImageRequestHandler(cgImage: image, orientation: .up).perform([request])

    guard
      let observation = request.results?.first as? VNSaliencyImageObservation,
      let best = observation.salientObjects?.max(by: { $0.confidence < $1.confidence }),
      best.boundingBox.width > 0, best.boundingBox.height > 0
    else { return nil }

    return EngineMatch(box: NormalizedBox(visionRect: best.boundingBox), confidence: Double(best.confidence), engine: kind)
  }
}
