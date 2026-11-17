package com.nitrosubject.image

/**
 * Largest power-of-two `inSampleSize` that still decodes [size] with its
 * longest side at or above [maxPixelSize] — the cheap decode-time half of the
 * downscale; the bitmap is scaled exactly afterwards.
 */
fun sampleSizeFor(size: ImageSize, maxPixelSize: Int): Int {
  val longest = maxOf(size.width, size.height)
  var sampleSize = 1
  while (longest / (sampleSize * 2) >= maxPixelSize) sampleSize *= 2
  return sampleSize
}
