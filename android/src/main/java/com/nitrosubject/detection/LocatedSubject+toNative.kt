package com.nitrosubject.detection

import com.margelo.nitro.nitrosubject.NativeSubjectFrame
import com.margelo.nitro.nitrosubject.SubjectSource

internal fun LocatedSubject.toNative(): NativeSubjectFrame = NativeSubjectFrame(
  x = rect.x,
  y = rect.y,
  width = rect.width,
  height = rect.height,
  imageWidth = imageSize.width.toDouble(),
  imageHeight = imageSize.height.toDouble(),
  confidence = confidence,
  source = SubjectSource.SUBJECT_SEGMENTATION,
)
