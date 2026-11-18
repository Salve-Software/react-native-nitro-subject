import Foundation

/// Which engine located a subject; mirrors the iOS cases of `SubjectSource`.
enum SubjectEngineKind: String {
  case foregroundMask = "foreground-mask"
  case objectnessSaliency = "objectness-saliency"
  case attentionSaliency = "attention-saliency"
}
