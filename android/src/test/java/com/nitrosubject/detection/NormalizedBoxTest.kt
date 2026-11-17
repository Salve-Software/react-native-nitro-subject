package com.nitrosubject.detection

import com.nitrosubject.image.ImageSize
import org.junit.Assert.assertEquals
import org.junit.Test

class NormalizedBoxTest {

  @Test
  fun `toPixels scales by the image size`() {
    val box = NormalizedBox(minX = 0.25, minY = 0.5, maxX = 0.75, maxY = 1.0)

    assertEquals(PixelRect(1000.0, 1500.0, 2000.0, 1500.0), box.toPixels(ImageSize(4000, 3000)))
  }
}
