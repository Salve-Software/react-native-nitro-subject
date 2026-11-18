package com.nitrosubject.image

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class ExifOrientationTest {

  @Test
  fun `tags 1 to 8 map to their orientation`() {
    assertEquals((1..8).toList(), (1..8).map { ExifOrientation.fromTag(it).tag })
  }

  @Test
  fun `unknown tags are upright`() {
    assertEquals(ExifOrientation.NORMAL, ExifOrientation.fromTag(0))
    assertEquals(ExifOrientation.NORMAL, ExifOrientation.fromTag(9))
  }

  @Test
  fun `only tags 5 to 8 swap the axes`() {
    (1..4).forEach { assertFalse("tag $it", ExifOrientation.fromTag(it).swapsAxes) }
    (5..8).forEach { assertTrue("tag $it", ExifOrientation.fromTag(it).swapsAxes) }
  }

  @Test
  fun `mirrored tags are 2, 4, 5 and 7`() {
    assertEquals(listOf(2, 4, 5, 7), ExifOrientation.entries.filter { it.mirrored }.map { it.tag })
  }
}
