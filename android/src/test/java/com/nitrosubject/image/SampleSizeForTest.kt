package com.nitrosubject.image

import org.junit.Assert.assertEquals
import org.junit.Test

class SampleSizeForTest {

  @Test
  fun `images already small are decoded at full size`() {
    assertEquals(1, sampleSizeFor(ImageSize(800, 600), maxPixelSize = 1024))
    assertEquals(1, sampleSizeFor(ImageSize(2047, 1000), maxPixelSize = 1024))
  }

  @Test
  fun `picks the largest power of two that stays at or above the target`() {
    // 4000 / 2 = 2000, / 4 = 1000 < 1024 → 2
    assertEquals(2, sampleSizeFor(ImageSize(4000, 3000), maxPixelSize = 1024))
    // 8192 / 8 = 1024 → 8
    assertEquals(8, sampleSizeFor(ImageSize(6000, 8192), maxPixelSize = 1024))
  }
}
