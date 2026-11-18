package com.nitrosubject.model

import com.google.android.gms.common.moduleinstall.ModuleInstallStatusUpdate.InstallState
import org.junit.Assert.assertEquals
import org.junit.Test

class InstallProgressTest {

  @Test
  fun `completed is a success`() {
    assertEquals(InstallProgress.Finished(succeeded = true), InstallProgress.from(InstallState.STATE_COMPLETED))
  }

  @Test
  fun `canceled and failed finish without success`() {
    assertEquals(InstallProgress.Finished(succeeded = false), InstallProgress.from(InstallState.STATE_CANCELED))
    assertEquals(InstallProgress.Finished(succeeded = false), InstallProgress.from(InstallState.STATE_FAILED))
  }

  @Test
  fun `in-flight states keep waiting`() {
    for (state in listOf(InstallState.STATE_PENDING, InstallState.STATE_DOWNLOADING, InstallState.STATE_INSTALLING)) {
      assertEquals(InstallProgress.Pending, InstallProgress.from(state))
    }
  }
}
