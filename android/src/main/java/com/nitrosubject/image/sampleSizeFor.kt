package com.nitrosubject.image

/**
 * Largest power-of-two `inSampleSize` that keeps the longest side of [size]
 * at or above [maxPixelSize]. The bitmap is scaled to the exact size later.
 */
fun sampleSizeFor(size: ImageSize, maxPixelSize: Int): Int {
  val longest = maxOf(size.width, size.height)
  var sampleSize = 1
  while (longest / (sampleSize * 2) >= maxPixelSize) sampleSize *= 2
  return sampleSize
}
