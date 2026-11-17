import type { SubjectSource } from '../specs/types';

/**
 * Box around the main subject, in pixels of the image as it is displayed
 * (EXIF orientation applied).
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
