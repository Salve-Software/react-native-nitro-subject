import type { SubjectDetector } from '../../../specs/SubjectDetector.nitro';
import type { IPrepareProps } from './types';
import { DEFAULT_PREPARE_TIMEOUT_MS } from './constants';

export class PrepareSubject {
  constructor(private readonly _bridge: SubjectDetector) {}

  prepare({ timeoutMs = DEFAULT_PREPARE_TIMEOUT_MS }: IPrepareProps = {}): Promise<boolean> {
    if (!(timeoutMs > 0)) {
      throw new Error(`Subject.prepare: timeoutMs must be > 0, got ${timeoutMs}`);
    }

    return this._bridge.prepare(timeoutMs);
  }
}
