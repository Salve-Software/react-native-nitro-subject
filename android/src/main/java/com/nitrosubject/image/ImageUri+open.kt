package com.nitrosubject.image

import android.content.Context
import android.net.Uri
import java.io.FileInputStream
import java.io.InputStream

internal fun ImageUri.open(context: Context): InputStream = when (this) {
  is ImageUri.File -> FileInputStream(path)
  is ImageUri.Content -> context.contentResolver.openInputStream(Uri.parse(uri))
    ?: throw IllegalArgumentException("SubjectDetector: could not open \"$uri\"")
}
