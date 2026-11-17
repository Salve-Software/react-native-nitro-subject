package com.nitrosubject.image

import android.graphics.Bitmap

/**
 * A downscaled, upright copy of a photo for analysis, plus the size of the
 * full-resolution upright photo the result is mapped back to.
 */
class UprightImage(val analysisBitmap: Bitmap, val size: ImageSize)
