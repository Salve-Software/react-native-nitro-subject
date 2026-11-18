import type { IDetectProps } from '../types';

/** Rejects props that can only be a caller bug, synchronously and with the offending value. */
export function assertDetectProps({ uri, padding, minAreaRatio }: IDetectProps): void {
  if (typeof uri !== 'string' || uri.length === 0) {
    throw new Error('Subject.detect: uri must be a non-empty string');
  }
  if (padding !== undefined && !(padding >= 0)) {
    throw new Error(`Subject.detect: padding must be >= 0, got ${padding}`);
  }
  if (minAreaRatio !== undefined && !(minAreaRatio >= 0 && minAreaRatio <= 1)) {
    throw new Error(`Subject.detect: minAreaRatio must be between 0 and 1, got ${minAreaRatio}`);
  }
}
