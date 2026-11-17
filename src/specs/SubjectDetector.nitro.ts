import type { HybridObject } from 'react-native-nitro-modules';
import type { NativeSubjectFrame } from './types';

export interface SubjectDetector extends HybridObject<{ ios: 'swift'; android: 'kotlin' }> {
  /**
   * Locates the main subject of the image at `uri`, off the JS thread.
   * @param uri `file://` URI or absolute path; Android also accepts `content://`.
   * @returns The subject box in pixels of the upright image, or `undefined`
   * when nothing was found or (Android) the model is not on the device yet.
   */
  detect(uri: string): Promise<NativeSubjectFrame | undefined>;

  /**
   * Makes sure the on-device model is ready. Android downloads the ML Kit
   * module through Google Play services and waits up to `timeoutMs`; iOS
   * resolves `true` right away, Vision ships with the OS.
   */
  prepare(timeoutMs: number): Promise<boolean>;
}
