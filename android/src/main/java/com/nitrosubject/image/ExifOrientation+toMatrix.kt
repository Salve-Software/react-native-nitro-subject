package com.nitrosubject.image

import android.graphics.Matrix

internal fun ExifOrientation.toMatrix(): Matrix = Matrix().apply {
  if (mirrored) postScale(-1f, 1f)
  if (clockwiseDegrees != 0) postRotate(clockwiseDegrees.toFloat())
}
