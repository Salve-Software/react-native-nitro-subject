import CoreGraphics

/// A downscaled, upright copy of a photo for analysis, plus the size of the
/// full-resolution upright photo the result is mapped back to.
struct UprightImage {
  let analysisImage: CGImage
  let size: ImageSize
}
