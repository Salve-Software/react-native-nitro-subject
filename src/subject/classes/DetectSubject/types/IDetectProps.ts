export interface IDetectProps {
  /** `file://` URI or absolute path of the photo. Android also accepts `content://`. */
  uri: string;
  /**
   * Margin added on each side, as a fraction of the box size. `0.1` adds 10%
   * of the width on the left and right, and 10% of the height on the top and
   * bottom. Never goes past the image. Defaults to `0`.
   */
  padding?: number;
  /**
   * Boxes smaller than this fraction of the image (0 to 1) return `null`.
   * Defaults to `0`.
   */
  minAreaRatio?: number;
}
