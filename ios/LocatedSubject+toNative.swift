import Foundation

extension LocatedSubject {
  func toNative() -> NativeSubjectFrame {
    NativeSubjectFrame(
      x: rect.x,
      y: rect.y,
      width: rect.width,
      height: rect.height,
      imageWidth: imageSize.width,
      imageHeight: imageSize.height,
      confidence: confidence,
      source: engine.toNative()
    )
  }
}
