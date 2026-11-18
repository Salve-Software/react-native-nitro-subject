import type { SubjectSource } from './SubjectSource';

/** Raw box from native code, unrounded and without padding. */
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
