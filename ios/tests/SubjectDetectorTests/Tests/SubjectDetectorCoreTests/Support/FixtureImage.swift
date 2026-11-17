import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

/// Writes synthetic photos to a temp dir: a dark, rounded "product" on a
/// light, slightly textured backdrop — no third-party photos in the repo.
enum FixtureImage {
  /// - Parameters:
  ///   - size: Size of the upright image.
  ///   - subject: Where the subject sits in the upright image, top-left origin.
  ///   - exifOrientation: EXIF tag to store. The pixels are rotated so the
  ///     image still *displays* as `size` with the subject at `subject`.
  static func write(size: CGSize, subject: CGRect, exifOrientation: Int = 1) throws -> URL {
    let upright = try draw(size: size, subject: subject)
    let stored = exifOrientation == 6 ? try rotateForOrientation6(upright) : upright

    let url = FileManager.default.temporaryDirectory
      .appendingPathComponent(UUID().uuidString)
      .appendingPathExtension("jpg")
    guard let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.jpeg.identifier as CFString, 1, nil) else {
      throw FixtureError.encode
    }
    CGImageDestinationAddImage(destination, stored, [kCGImagePropertyOrientation: exifOrientation] as CFDictionary)
    guard CGImageDestinationFinalize(destination) else { throw FixtureError.encode }
    return url
  }

  private static func draw(size: CGSize, subject: CGRect) throws -> CGImage {
    let context = try makeContext(width: Int(size.width), height: Int(size.height))
    // CoreGraphics has a bottom-left origin; flip so `subject` is top-left.
    context.translateBy(x: 0, y: size.height)
    context.scaleBy(x: 1, y: -1)

    context.setFillColor(CGColor(red: 0.93, green: 0.92, blue: 0.9, alpha: 1))
    context.fill(CGRect(origin: .zero, size: size))

    context.setShadow(offset: CGSize(width: 0, height: 12), blur: 30, color: CGColor(gray: 0, alpha: 0.35))
    context.setFillColor(CGColor(red: 0.1, green: 0.2, blue: 0.55, alpha: 1))
    context.addPath(CGPath(roundedRect: subject, cornerWidth: subject.width * 0.15, cornerHeight: subject.width * 0.15, transform: nil))
    context.fillPath()

    guard let image = context.makeImage() else { throw FixtureError.draw }
    return image
  }

  /// Pixels as a camera held for EXIF orientation 6 stores them: viewers
  /// rotate them 90° clockwise to display, so they are stored 90° counter-
  /// clockwise of upright. CoreGraphics' y axis points up, so that is a +90°
  /// rotation in its coordinate space.
  private static func rotateForOrientation6(_ image: CGImage) throws -> CGImage {
    let context = try makeContext(width: image.height, height: image.width)
    context.translateBy(x: CGFloat(image.height), y: 0)
    context.rotate(by: .pi / 2)
    context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
    guard let rotated = context.makeImage() else { throw FixtureError.draw }
    return rotated
  }

  private static func makeContext(width: Int, height: Int) throws -> CGContext {
    guard
      let context = CGContext(
        data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0,
        space: CGColorSpace(name: CGColorSpace.sRGB)!,
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
      )
    else { throw FixtureError.draw }
    return context
  }

  enum FixtureError: Error {
    case draw
    case encode
  }
}
