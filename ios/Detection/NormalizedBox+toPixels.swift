import Foundation

extension NormalizedBox {
  func toPixels(in size: ImageSize) -> PixelRect {
    PixelRect(
      x: minX * size.width,
      y: minY * size.height,
      width: (maxX - minX) * size.width,
      height: (maxY - minY) * size.height
    )
  }
}
