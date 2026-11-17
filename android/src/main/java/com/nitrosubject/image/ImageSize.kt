package com.nitrosubject.image

data class ImageSize(val width: Int, val height: Int) {
  /** Size once [orientation] is applied. */
  fun oriented(orientation: ExifOrientation): ImageSize =
    if (orientation.swapsAxes) ImageSize(height, width) else this
}
