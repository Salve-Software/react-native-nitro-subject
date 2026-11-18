import CoreGraphics

/// Small upright copy of a photo for analysis, plus the size of the full photo.
struct UprightImage {
  let analysisImage: CGImage
  let size: ImageSize
}
