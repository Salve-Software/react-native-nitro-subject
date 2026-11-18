package com.nitrosubject.detection

/** Smallest box around the mask values above [threshold]; [valueAt] reads `y * width + x`. */
fun maskBounds(width: Int, height: Int, threshold: Float = 0.5f, valueAt: (Int) -> Float): MaskMatch? {
  if (width <= 0 || height <= 0) return null

  var minX = width
  var minY = height
  var maxX = -1
  var maxY = -1
  var sum = 0.0
  var count = 0L

  for (y in 0 until height) {
    for (x in 0 until width) {
      val value = valueAt(y * width + x)
      if (value <= threshold) continue
      minX = minOf(minX, x)
      maxX = maxOf(maxX, x)
      minY = minOf(minY, y)
      maxY = maxOf(maxY, y)
      sum += value
      count++
    }
  }
  if (count == 0L) return null

  return MaskMatch(
    box = NormalizedBox(
      minX = minX.toDouble() / width,
      minY = minY.toDouble() / height,
      maxX = (maxX + 1).toDouble() / width,
      maxY = (maxY + 1).toDouble() / height,
    ),
    meanConfidence = sum / count,
  )
}
