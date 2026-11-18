package com.nitrosubject.segmentation

/** The ML Kit subject segmentation module is not on the device yet. */
class ModelUnavailableException(cause: Throwable) : Exception("subject segmentation model is not downloaded yet", cause)
