package com.nitrosubject.image

import org.junit.Assert.assertEquals
import org.junit.Test

class ImageSizeTest {
  private val landscape = ImageSize(4000, 3000)

  @Test
  fun `upright and 180 degree orientations keep the size`() {
    assertEquals(landscape, landscape.oriented(ExifOrientation.NORMAL))
    assertEquals(landscape, landscape.oriented(ExifOrientation.ROTATE_180))
  }

  @Test
  fun `quarter turns swap width and height`() {
    assertEquals(ImageSize(3000, 4000), landscape.oriented(ExifOrientation.ROTATE_90))
    assertEquals(ImageSize(3000, 4000), landscape.oriented(ExifOrientation.TRANSVERSE))
  }
}
