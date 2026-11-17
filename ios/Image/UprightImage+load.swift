import Foundation
import ImageIO

extension UprightImage {
  /// Decodes `url` as a thumbnail no longer than `maxPixelSize` on its longest
  /// side. `CreateThumbnailWithTransform` applies the EXIF orientation, so the
  /// engines always see the photo the way the user does.
  static func load(url: URL, uri: String, maxPixelSize: Int) throws -> UprightImage {
    let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
    guard
      let source = CGImageSourceCreateWithURL(url as CFURL, sourceOptions),
      let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
      let width = (properties[kCGImagePropertyPixelWidth] as? NSNumber)?.doubleValue,
      let height = (properties[kCGImagePropertyPixelHeight] as? NSNumber)?.doubleValue,
      width > 0, height > 0
    else {
      throw SubjectDetectorError.unreadableImage(uri)
    }

    let thumbnailOptions: [CFString: Any] = [
      kCGImageSourceCreateThumbnailFromImageAlways: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceShouldCacheImmediately: true,
      kCGImageSourceThumbnailMaxPixelSize: maxPixelSize,
    ]
    guard let thumbnail = CGImageSourceCreateThumbnailAtIndex(source, 0, thumbnailOptions as CFDictionary) else {
      throw SubjectDetectorError.unreadableImage(uri)
    }

    let orientation = (properties[kCGImagePropertyOrientation] as? NSNumber)?.intValue ?? 1
    return UprightImage(
      analysisImage: thumbnail,
      size: ImageSize(width: width, height: height).oriented(by: orientation)
    )
  }
}
