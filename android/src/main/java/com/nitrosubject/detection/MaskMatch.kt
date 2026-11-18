package com.nitrosubject.detection

/** Box around the foreground of a confidence mask, with the mean confidence inside it. */
data class MaskMatch(val box: NormalizedBox, val meanConfidence: Double)
