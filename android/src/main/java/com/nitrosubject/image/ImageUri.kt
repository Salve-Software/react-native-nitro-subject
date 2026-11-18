package com.nitrosubject.image

import java.net.URI

/** Where a photo uri points to. Parsed without Android APIs so it is unit-testable. */
sealed interface ImageUri {
  data class File(val path: String) : ImageUri
  data class Content(val uri: String) : ImageUri

  companion object {
    /** Accepts absolute paths, `file://`, `content://` and `android.resource://` uris. */
    fun parse(uri: String): ImageUri = when {
      uri.startsWith("/") -> File(uri)
      uri.startsWith("file://") -> File(URI(uri).path ?: throw unsupported(uri))
      uri.startsWith("content://") || uri.startsWith("android.resource://") -> Content(uri)
      else -> throw unsupported(uri)
    }

    private fun unsupported(uri: String) = IllegalArgumentException(
      "SubjectDetector: unsupported uri \"$uri\". Use a file:// or content:// uri, or an absolute path"
    )
  }
}
