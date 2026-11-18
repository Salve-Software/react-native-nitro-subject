import Foundation
import NitroModules

final class HybridSubjectDetector: HybridSubjectDetectorSpec {
  private let locator = SubjectLocator()

  func detect(uri: String) throws -> Promise<NativeSubjectFrame?> {
    let locator = self.locator
    return Promise.parallel(.global(qos: .userInitiated)) {
      try locator.locate(uri: uri)?.toNative()
    }
  }

  /// Vision ships with the OS: there is nothing to download.
  func prepare(timeoutMs: Double) throws -> Promise<Bool> {
    Promise.resolved(withResult: true)
  }
}
