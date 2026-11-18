package com.nitrosubject.detection

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class MaskBoundsTest {

  private fun mask(width: Int, vararg values: Float) = { index: Int -> values[index] }.let { valueAt ->
    maskBounds(width, values.size / width, valueAt = valueAt)
  }

  @Test
  fun `empty mask has no match`() {
    assertNull(mask(2, 0f, 0.2f, 0.5f, 0f))
  }

  @Test
  fun `zero sized mask has no match`() {
    assertNull(maskBounds(0, 4) { 1f })
  }

  @Test
  fun `single pixel includes its edges`() {
    val match = mask(4, 0.9f, 0f, 0f, 0f, 0f, 0f, 0f, 0f, 0f, 0f, 0f, 0f, 0f, 0f, 0f, 0f)

    assertEquals(NormalizedBox(0.0, 0.0, 0.25, 0.25), match?.box)
  }

  @Test
  fun `box spans disjoint regions and confidence is the mean inside the mask`() {
    val match = mask(4, 0f, 0.6f, 0f, 0f, 0f, 0f, 0f, 1.0f)

    assertEquals(NormalizedBox(0.25, 0.0, 1.0, 1.0), match?.box)
    assertEquals(0.8, match!!.meanConfidence, 1e-6)
  }

  @Test
  fun `values equal to the threshold are background`() {
    assertNull(mask(1, 0.5f))
  }
}
