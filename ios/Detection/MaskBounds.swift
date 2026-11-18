import Foundation

enum MaskBounds {
  /// Smallest box around the pixels where `isSet(x, y)` is true, or nil when there are none.
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
