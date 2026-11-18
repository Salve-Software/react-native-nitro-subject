package com.nitrosubject.segmentation

import android.graphics.Bitmap
import com.google.android.gms.tasks.Tasks
import com.google.mlkit.common.MlKitException
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.segmentation.subject.SubjectSegmentation
import com.google.mlkit.vision.segmentation.subject.SubjectSegmenter
import com.google.mlkit.vision.segmentation.subject.SubjectSegmenterOptions
import com.nitrosubject.detection.MaskMatch
import com.nitrosubject.detection.maskBounds
import java.util.concurrent.ExecutionException

/** ML Kit Subject Segmentation (Google Play services): box around the foreground confidence mask. */
class SubjectSegmenterEngine {
  val client: SubjectSegmenter by lazy {
    SubjectSegmentation.getClient(
      SubjectSegmenterOptions.Builder()
        .enableForegroundConfidenceMask()
        .build()
    )
  }

  /** Must run off the main thread: it blocks on the ML Kit task. */
  fun match(bitmap: Bitmap): MaskMatch? {
    val result = try {
      Tasks.await(client.process(InputImage.fromBitmap(bitmap, 0)))
    } catch (e: ExecutionException) {
      val cause = e.cause ?: e
      if (cause is MlKitException && cause.errorCode == MlKitException.UNAVAILABLE) {
        throw ModelUnavailableException(cause)
      }
      throw cause
    }

    val mask = result.foregroundConfidenceMask ?: return null
    return maskBounds(bitmap.width, bitmap.height) { mask.get(it) }
  }
}
