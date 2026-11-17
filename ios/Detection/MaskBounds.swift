import Foundation

enum MaskBounds {
  /// Tightest box around every pixel for which `isSet(x, y)` is true, or nil
  /// when no pixel is set. Pixel edges are included: a single set pixel at
  /// (0, 0) in a 4×4 mask spans 0–0.25 on both axes.
  static func box(width: Int, height: Int, isSet: (_ x: Int, _ y: Int) -> Bool) -> NormalizedBox? {
    guard width > 0, height > 0 else { return nil }

    var minX = width, minY = height, maxX = -1, maxY = -1
    for y in 0..<height {
      for x in 0..<width where isSet(x, y) {
        minX = min(minX, x)
        maxX = max(maxX, x)
        minY = min(minY, y)
        maxY = max(maxY, y)
      }
    }
    guard maxX >= 0 else { return nil }

    return NormalizedBox(
      minX: Double(minX) / Double(width),
      minY: Double(minY) / Double(height),
      maxX: Double(maxX + 1) / Double(width),
      maxY: Double(maxY + 1) / Double(height)
    )
  }
}
