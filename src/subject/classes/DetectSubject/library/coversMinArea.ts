import type { ICoversMinAreaProps } from '../types';

/** Whether `rect` covers at least `minAreaRatio` of the image area. */
export function coversMinArea({ rect, image, minAreaRatio }: ICoversMinAreaProps): boolean {
  const ratio = (rect.width * rect.height) / (image.width * image.height);

  return ratio >= minAreaRatio;
}
