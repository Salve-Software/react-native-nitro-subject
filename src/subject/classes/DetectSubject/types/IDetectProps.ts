export interface IDetectProps {
  /** `file://` URI or absolute path of the photo. Android also accepts `content://`. */
  uri: string;
  /**
   * Extra margin around the subject, as a fraction of the box size on each
   * side — `0.1` adds 10% of the width left and right and 10% of the height
   * top and bottom. Clamped to the image. Defaults to `0`.
   */
  padding?: number;
  /**
   * Boxes covering less than this fraction of the image (0–1) resolve `null`
   * instead — e.g. `0.02` ignores specks. Defaults to `0`.
   */
  minAreaRatio?: number;
}
