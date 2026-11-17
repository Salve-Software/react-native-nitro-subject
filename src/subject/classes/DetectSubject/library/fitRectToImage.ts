import type { IFitRectToImageProps, IRect } from '../types';

function clamp(value: number, max: number): number {
  return Math.min(Math.max(value, 0), max);
}

/**
 * Clips `rect` to the image and snaps it outwards to whole pixels, so the
 * subject is never cut by rounding. Returns `null` when nothing is left.
 */
export function fitRectToImage({ rect, image }: IFitRectToImageProps): IRect | null {
  if (!(image.width > 0 && image.height > 0)) return null;

  const left = Math.floor(clamp(rect.x, image.width));
  const top = Math.floor(clamp(rect.y, image.height));
  const right = Math.ceil(clamp(rect.x + rect.width, image.width));
  const bottom = Math.ceil(clamp(rect.y + rect.height, image.height));

  if (right <= left || bottom <= top) return null;

  return { x: left, y: top, width: right - left, height: bottom - top };
}
