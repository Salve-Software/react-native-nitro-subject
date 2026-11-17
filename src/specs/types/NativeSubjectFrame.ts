import type { SubjectSource } from './SubjectSource';

/**
 * Subject bounding box as the native side reports it: pixels of the upright
 * (EXIF-corrected) image, unrounded and unpadded. `DetectSubject` turns it
 * into the public `ISubjectFrame`.
 */
export interface NativeSubjectFrame {
  x: number;
  y: number;
  width: number;
  height: number;
  imageWidth: number;
  imageHeight: number;
  confidence?: number;
  source: SubjectSource;
}
