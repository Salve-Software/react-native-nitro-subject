import Foundation

extension ImageSize {
  /// Size after applying the EXIF orientation; 5 to 8 swap width and height.
  func oriented(by exifOrientation: Int) -> ImageSize {
    (5...8).contains(exifOrientation) ? ImageSize(width: height, height: width) : self
  }
}
