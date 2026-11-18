import type { SubjectDetector } from '../specs/SubjectDetector.nitro';
import type { IDetectProps, IPrepareProps } from './classes';
import { NitroModules } from 'react-native-nitro-modules';
import { DetectSubject, PrepareSubject } from './classes';

const _bridge = NitroModules.createHybridObject<SubjectDetector>('SubjectDetector');

/** Public entry point of the library. */
export class Subject {
  private static readonly detectSubject = new DetectSubject(_bridge);
  private static readonly prepareSubject = new PrepareSubject(_bridge);

  private constructor() {}

  /** Box of the main subject in pixels of the displayed image, or `null` when there is none. */
  static detect = (props: IDetectProps) => {
    return this.detectSubject.detect(props);
  };

  /** Downloads the Android model ahead of time; resolves `true` when it is ready. */
  static prepare = (props?: IPrepareProps) => {
    return this.prepareSubject.prepare(props);
  };
}
