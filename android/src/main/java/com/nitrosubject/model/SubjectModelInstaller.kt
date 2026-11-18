package com.nitrosubject.model

import android.content.Context
import android.util.Log
import com.google.android.gms.common.api.OptionalModuleApi
import com.google.android.gms.common.moduleinstall.InstallStatusListener
import com.google.android.gms.common.moduleinstall.ModuleInstall
import com.google.android.gms.common.moduleinstall.ModuleInstallRequest
import com.google.android.gms.tasks.Tasks
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicBoolean

/** Checks and downloads the ML Kit module; failures read as "not available" instead of throwing. */
class SubjectModelInstaller(context: Context, private val api: OptionalModuleApi) {
  private val client = ModuleInstall.getClient(context)
  private val available = AtomicBoolean(false)

  fun isAvailable(): Boolean {
    if (available.get()) return true
    val isAvailable = try {
      Tasks.await(client.areModulesAvailable(api), CHECK_TIMEOUT_MS, TimeUnit.MILLISECONDS).areModulesAvailable()
    } catch (e: Exception) {
      Log.w(TAG, "could not check subject segmentation availability", e)
      false
    }
    available.set(isAvailable)
    return isAvailable
  }

  /** Asks Play services to download the module when convenient; returns immediately. */
  fun requestDeferredInstall() {
    try {
      client.deferredInstall(api)
    } catch (e: Exception) {
      Log.w(TAG, "could not request subject segmentation download", e)
    }
  }

  /** Downloads the module now, blocking up to [timeoutMs]. Must run off the main thread. */
  fun install(timeoutMs: Long): Boolean {
    if (isAvailable()) return true

    val finished = CountDownLatch(1)
    val succeeded = AtomicBoolean(false)
    val listener = InstallStatusListener { update ->
      val progress = InstallProgress.from(update.installState)
      if (progress is InstallProgress.Finished) {
        succeeded.set(progress.succeeded)
        finished.countDown()
      }
    }
    val request = ModuleInstallRequest.newBuilder().addApi(api).setListener(listener).build()

    return try {
      val response = Tasks.await(client.installModules(request), timeoutMs, TimeUnit.MILLISECONDS)
      if (response.areModulesAlreadyInstalled()) succeeded.set(true) else finished.await(timeoutMs, TimeUnit.MILLISECONDS)
      available.set(succeeded.get())
      succeeded.get()
    } catch (e: Exception) {
      Log.w(TAG, "could not install subject segmentation module", e)
      false
    } finally {
      client.unregisterListener(listener)
    }
  }

  private companion object {
    const val TAG = "NitroSubject"
    const val CHECK_TIMEOUT_MS = 10_000L
  }
}
