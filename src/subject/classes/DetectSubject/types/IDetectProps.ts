export interface IDetectProps {
  /** `file://` URI or absolute path of the photo. Android also accepts `content://`. */
  uri: string;
  /** Margin added on each side, as a fraction of the box size. Defaults to `0`. */
  padding?: number;
  /** Boxes smaller than this fraction of the image return `null`. Defaults to `0`. */
  minAreaRatio?: number;
}
