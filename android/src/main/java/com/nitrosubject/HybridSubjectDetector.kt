package com.nitrosubject

import com.margelo.nitro.NitroModules
import com.margelo.nitro.core.Promise
import com.margelo.nitro.nitrosubject.HybridSubjectDetectorSpec
import com.margelo.nitro.nitrosubject.NativeSubjectFrame
import com.nitrosubject.detection.toNative

class HybridSubjectDetector : HybridSubjectDetectorSpec() {
  private val locator by lazy {
    val context = NitroModules.applicationContext
      ?: throw IllegalStateException("SubjectDetector: React application context is not ready yet")
    SubjectLocator(context)
  }

  override fun detect(uri: String): Promise<NativeSubjectFrame?> = Promise.parallel {
    locator.locate(uri)?.toNative()
  }

  override fun prepare(timeoutMs: Double): Promise<Boolean> = Promise.parallel {
    locator.installer.install(timeoutMs.toLong())
  }
}
