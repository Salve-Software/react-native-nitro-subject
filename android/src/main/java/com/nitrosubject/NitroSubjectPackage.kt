package com.nitrosubject

import com.facebook.react.BaseReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.model.ReactModuleInfoProvider
import com.margelo.nitro.nitrosubject.NitroSubjectOnLoad

/** Exists only to load the native library; the module itself is a Nitro HybridObject. */
class NitroSubjectPackage : BaseReactPackage() {
  override fun getModule(name: String, reactContext: ReactApplicationContext): NativeModule? = null

  override fun getReactModuleInfoProvider(): ReactModuleInfoProvider = ReactModuleInfoProvider { emptyMap() }

  companion object {
    init {
      NitroSubjectOnLoad.initializeNative()
    }
  }
}
