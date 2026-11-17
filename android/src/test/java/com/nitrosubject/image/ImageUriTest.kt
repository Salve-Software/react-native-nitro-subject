package com.nitrosubject.image

import org.junit.Assert.assertEquals
import org.junit.Assert.assertThrows
import org.junit.Test

class ImageUriTest {

  @Test
  fun `absolute path is a file`() {
    assertEquals(ImageUri.File("/data/photo.jpg"), ImageUri.parse("/data/photo.jpg"))
  }

  @Test
  fun `file uri is a percent-decoded file`() {
    assertEquals(ImageUri.File("/data/my photo.jpg"), ImageUri.parse("file:///data/my%20photo.jpg"))
  }

  @Test
  fun `content and resource uris are kept as content`() {
    assertEquals(ImageUri.Content("content://media/external/images/1"), ImageUri.parse("content://media/external/images/1"))
    assertEquals(ImageUri.Content("android.resource://app/raw/photo"), ImageUri.parse("android.resource://app/raw/photo"))
  }

  @Test
  fun `remote and relative uris are rejected`() {
    for (uri in listOf("https://example.com/a.jpg", "photo.jpg", "")) {
      val error = assertThrows(IllegalArgumentException::class.java) { ImageUri.parse(uri) }
      assertEquals(
        "SubjectDetector: unsupported uri \"$uri\". Use a file:// or content:// uri, or an absolute path",
        error.message,
      )
    }
  }
}
