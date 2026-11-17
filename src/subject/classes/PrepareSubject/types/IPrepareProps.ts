export interface IPrepareProps {
  /**
   * How long to wait for the Android model download before giving up, in ms.
   * Defaults to 30 seconds. Ignored on iOS.
   */
  timeoutMs?: number;
}
