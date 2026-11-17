package com.nitrosubject.detection

import com.nitrosubject.image.ImageSize

/** A box in 0–1 coordinates relative to the image, top-left origin. */
data class NormalizedBox(val minX: Double, val minY: Double, val maxX: Double, val maxY: Double) {
  fun toPixels(size: ImageSize): PixelRect = PixelRect(
    x = minX * size.width,
    y = minY * size.height,
    width = (maxX - minX) * size.width,
    height = (maxY - minY) * size.height,
  )
}
