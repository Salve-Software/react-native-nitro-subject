import CoreVideo

extension CVPixelBuffer {
  /// Box around the mask pixels above `threshold`, for the single-channel
  /// float and 8-bit formats Vision produces. Nil for other formats or an
  /// empty mask.
  func maskBounds(threshold: Float = 0.5) -> NormalizedBox? {
    CVPixelBufferLockBaseAddress(self, .readOnly)
    defer { CVPixelBufferUnlockBaseAddress(self, .readOnly) }
    guard let base = CVPixelBufferGetBaseAddress(self) else { return nil }

    let bytesPerRow = CVPixelBufferGetBytesPerRow(self)
    let width = CVPixelBufferGetWidth(self)
    let height = CVPixelBufferGetHeight(self)

    switch CVPixelBufferGetPixelFormatType(self) {
    case kCVPixelFormatType_OneComponent32Float:
      return MaskBounds.box(width: width, height: height) { x, y in
        base.load(fromByteOffset: y * bytesPerRow + x * 4, as: Float32.self) > threshold
      }
    case kCVPixelFormatType_OneComponent8:
      let byteThreshold = UInt8(threshold * 255)
      return MaskBounds.box(width: width, height: height) { x, y in
        base.load(fromByteOffset: y * bytesPerRow + x, as: UInt8.self) > byteThreshold
      }
    default:
      return nil
    }
  }
}
