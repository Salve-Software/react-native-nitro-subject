import type { SubjectSource } from '../specs/types';

/**
 * Bounding box of the main subject, in whole pixels of the upright image —
 * the image after its EXIF orientation is applied, the same space image
 * croppers work in.
 */
export interface ISubjectFrame {
  /** Left edge, in pixels. */
  x: number;
  /** Top edge, in pixels. */
  y: number;
  /** Box width, in pixels. */
  width: number;
  /** Box height, in pixels. */
  height: number;
  /** Width of the upright image, in pixels. */
  imageWidth: number;
  /** Height of the upright image, in pixels. */
  imageHeight: number;
  /** 0–1 score, when the native engine reports one. */
  confidence?: number;
  /** Native engine that located the subject. */
  source: SubjectSource;
}
