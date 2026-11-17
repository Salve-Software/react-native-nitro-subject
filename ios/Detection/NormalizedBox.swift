import Foundation

/// A box in 0–1 coordinates relative to the image, top-left origin.
struct NormalizedBox: Equatable {
  let minX: Double
  let minY: Double
  let maxX: Double
  let maxY: Double
}
