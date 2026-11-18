import { useCallback, useState } from 'react';
import {
  Subject,
  type ISubjectFrame,
} from '@salve-software/react-native-nitro-subject';

export type DetectionState =
  | { status: 'idle' }
  | { status: 'detecting' }
  | { status: 'done'; frame: ISubjectFrame | null; elapsedMs: number }
  | { status: 'error'; message: string };

/** Runs `Subject.detect` and keeps the latest result and how long it took. */
export function useSubjectDetection() {
  const [state, setState] = useState<DetectionState>({ status: 'idle' });

  const detect = useCallback(async (uri: string, padding: number) => {
    setState({ status: 'detecting' });
    const startedAt = Date.now();
    try {
      const frame = await Subject.detect({ uri, padding });
      setState({ status: 'done', frame, elapsedMs: Date.now() - startedAt });
    } catch (err) {
      setState({
        status: 'error',
        message: err instanceof Error ? err.message : String(err),
      });
    }
  }, []);

  return { state, detect };
}
