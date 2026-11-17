package com.nitrosubject.image

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import androidx.exifinterface.media.ExifInterface

class UprightImageLoader(private val context: Context) {

  fun load(uri: String, maxPixelSize: Int): UprightImage {
    val source = ImageUri.parse(uri)
    val stored = readSize(source) ?: throw unreadable(uri)
    val orientation = readOrientation(source)

    val decoded = source.open(context).use { stream ->
      BitmapFactory.decodeStream(stream, null, BitmapFactory.Options().apply {
        inSampleSize = sampleSizeFor(stored, maxPixelSize)
        inPreferredConfig = Bitmap.Config.ARGB_8888
      })
    } ?: throw unreadable(uri)

    val scale = minOf(1f, maxPixelSize.toFloat() / maxOf(decoded.width, decoded.height))
    val matrix = orientation.toMatrix().apply { postScale(scale, scale) }
    val upright = Bitmap.createBitmap(decoded, 0, 0, decoded.width, decoded.height, matrix, true)
    if (upright !== decoded) decoded.recycle()

    return UprightImage(upright, stored.oriented(orientation))
  }

  private fun readSize(source: ImageUri): ImageSize? {
    val options = BitmapFactory.Options().apply { inJustDecodeBounds = true }
    source.open(context).use { BitmapFactory.decodeStream(it, null, options) }
    return if (options.outWidth > 0 && options.outHeight > 0) ImageSize(options.outWidth, options.outHeight) else null
  }

  // A photo without readable EXIF is still a photo: treat it as upright.
  private fun readOrientation(source: ImageUri): ExifOrientation = try {
    source.open(context).use {
      ExifOrientation.fromTag(ExifInterface(it).getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL))
    }
  } catch (_: Exception) {
    ExifOrientation.NORMAL
  }

  private fun unreadable(uri: String) = IllegalArgumentException("SubjectDetector: could not decode an image at \"$uri\"")
}
