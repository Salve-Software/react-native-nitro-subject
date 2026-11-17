package com.nitrosubject.image

/**
 * The eight EXIF orientations, as the transform that turns the stored pixels
 * upright: an optional horizontal mirror applied first, then a clockwise
 * rotation. Values match `ExifInterface.ORIENTATION_*`.
 */
enum class ExifOrientation(val tag: Int, val mirrored: Boolean, val clockwiseDegrees: Int) {
  NORMAL(1, mirrored = false, clockwiseDegrees = 0),
  FLIP_HORIZONTAL(2, mirrored = true, clockwiseDegrees = 0),
  ROTATE_180(3, mirrored = false, clockwiseDegrees = 180),
  FLIP_VERTICAL(4, mirrored = true, clockwiseDegrees = 180),
  TRANSPOSE(5, mirrored = true, clockwiseDegrees = 270),
  ROTATE_90(6, mirrored = false, clockwiseDegrees = 90),
  TRANSVERSE(7, mirrored = true, clockwiseDegrees = 90),
  ROTATE_270(8, mirrored = false, clockwiseDegrees = 270);

  /** Whether the upright image swaps the stored width and height. */
  val swapsAxes: Boolean get() = clockwiseDegrees % 180 != 0

  companion object {
    /** Unknown or missing tags are treated as upright, like every image viewer does. */
    fun fromTag(tag: Int): ExifOrientation = entries.firstOrNull { it.tag == tag } ?: NORMAL
  }
}
