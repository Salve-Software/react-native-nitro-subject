import type { HybridObject } from 'react-native-nitro-modules';
import type { NativeSubjectFrame } from './types';

export interface SubjectDetector extends HybridObject<{ ios: 'swift'; android: 'kotlin' }> {
  /** Box of the main subject in pixels of the upright image, or `undefined` when there is none. */
  detect(uri: string): Promise<NativeSubjectFrame | undefined>;

  /** Downloads the Android model and waits up to `timeoutMs`; always `true` on iOS. */
  prepare(timeoutMs: number): Promise<boolean>;
}
