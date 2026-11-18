import Foundation

extension SubjectEngineChain {
  /// Best engine the OS offers first, saliency fallbacks after it.
  static func platformDefault() -> SubjectEngineChain {
    var engines: [SubjectEngine] = []
    if #available(iOS 17.0, macOS 14.0, *) {
      engines.append(ForegroundMaskEngine())
    }
    engines.append(SaliencyEngine(kind: .objectnessSaliency))
    engines.append(SaliencyEngine(kind: .attentionSaliency))
    return SubjectEngineChain(engines: engines)
  }
}
