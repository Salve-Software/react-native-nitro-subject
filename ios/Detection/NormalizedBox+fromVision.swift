import CoreGraphics

extension NormalizedBox {
  /// Converts a Vision normalized rect (bottom-left origin) to a top-left one.
  init(visionRect rect: CGRect) {
    self.init(
      minX: Double(rect.minX),
      minY: Double(1 - rect.maxY),
      maxX: Double(rect.maxX),
      maxY: Double(1 - rect.minY)
    )
  }
}
