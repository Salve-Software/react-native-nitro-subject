import type { SubjectDetector } from '../specs/SubjectDetector.nitro';
import type { IDetectProps, IPrepareProps } from './classes';
import { NitroModules } from 'react-native-nitro-modules';
import { DetectSubject, PrepareSubject } from './classes';

const _bridge = NitroModules.createHybridObject<SubjectDetector>('SubjectDetector');

/**
 * Public entry point of the library. Uses Apple Vision on iOS and
 * ML Kit Subject Segmentation on Android.
 */
export class Subject {
  private static readonly detectSubject = new DetectSubject(_bridge);
  private static readonly prepareSubject = new PrepareSubject(_bridge);

  private constructor() {}

  /**
   * Finds the main subject of a photo and resolves its bounding box in pixels
   * of the upright (EXIF-corrected) image, or `null` when there is none.
   * Throws synchronously for invalid props; rejects if the image can't be read.
   */
  static detect = (props: IDetectProps) => {
    return this.detectSubject.detect(props);
  };

  /**
   * Optional warm-up. On Android, downloads the ML Kit model through Google
   * Play services if needed and resolves `true` once it is ready. On iOS,
   * resolves `true` right away.
   */
  static prepare = (props?: IPrepareProps) => {
    return this.prepareSubject.prepare(props);
  };
}
