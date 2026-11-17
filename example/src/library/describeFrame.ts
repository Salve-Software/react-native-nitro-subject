import type { ISubjectFrame } from '@salve-software/react-native-nitro-subject';

/** One-line summary for the result panel: engine, confidence and box. */
export function describeFrame(frame: ISubjectFrame): string {
  const confidence =
    frame.confidence !== undefined
      ? ` · ${Math.round(frame.confidence * 100)}%`
      : '';
  const box = `${frame.width}×${frame.height} at (${frame.x}, ${frame.y})`;

  return `${frame.source}${confidence}\n${box} of ${frame.imageWidth}×${frame.imageHeight}`;
}
