import Foundation

extension ImageSize {
  /// Size of the image as displayed once its EXIF orientation (1–8) is
  /// applied: orientations 5–8 rotate by 90°, swapping width and height.
  func oriented(by exifOrientation: Int) -> ImageSize {
    (5...8).contains(exifOrientation) ? ImageSize(width: height, height: width) : self
  }
}
