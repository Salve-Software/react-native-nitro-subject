package com.nitrosubject.model

import com.google.android.gms.common.moduleinstall.ModuleInstallStatusUpdate.InstallState

/** Collapses Play services' install states into what a waiting caller cares about. */
sealed interface InstallProgress {
  data object Pending : InstallProgress
  data class Finished(val succeeded: Boolean) : InstallProgress

  companion object {
    fun from(@InstallState state: Int): InstallProgress = when (state) {
      InstallState.STATE_COMPLETED -> Finished(succeeded = true)
      InstallState.STATE_CANCELED, InstallState.STATE_FAILED -> Finished(succeeded = false)
      else -> Pending
    }
  }
}
