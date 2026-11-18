package com.nitrosubject

import android.content.Context
import com.nitrosubject.detection.LocatedSubject
import com.nitrosubject.image.UprightImageLoader
import com.nitrosubject.model.SubjectModelInstaller
import com.nitrosubject.segmentation.ModelUnavailableException
import com.nitrosubject.segmentation.SubjectSegmenterEngine

/** Uri in, subject in image pixels out. Blocking: call it off the main thread. */
class SubjectLocator(context: Context) {
  private val loader = UprightImageLoader(context)
  private val engine = SubjectSegmenterEngine()
  val installer = SubjectModelInstaller(context, engine.client)

  /** Null when there is no subject, or when the model still has to be downloaded. */
  fun locate(uri: String): LocatedSubject? {
    if (!installer.isAvailable()) {
      installer.requestDeferredInstall()
      return null
    }

    val image = loader.load(uri, ANALYSIS_MAX_PIXEL_SIZE)
    try {
      val match = engine.match(image.analysisBitmap) ?: return null
      return LocatedSubject(match.box.toPixels(image.size), image.size, match.meanConfidence)
    } catch (_: ModelUnavailableException) {
      installer.requestDeferredInstall()
      return null
    } finally {
      image.analysisBitmap.recycle()
    }
  }

  private companion object {
    /** Longest side of the bitmap ML Kit analyses; the box is scaled back to full resolution. */
    const val ANALYSIS_MAX_PIXEL_SIZE = 1024
  }
}
