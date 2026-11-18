package com.nitrosubject.detection

import com.nitrosubject.image.ImageSize

/** A subject in pixels of the full-resolution upright image. */
data class LocatedSubject(val rect: PixelRect, val imageSize: ImageSize, val confidence: Double)
