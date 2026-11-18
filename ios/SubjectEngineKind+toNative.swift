import Foundation

extension SubjectEngineKind {
  func toNative() -> SubjectSource {
    switch self {
    case .foregroundMask: return .foregroundMask
    case .objectnessSaliency: return .objectnessSaliency
    case .attentionSaliency: return .attentionSaliency
    }
  }
}
