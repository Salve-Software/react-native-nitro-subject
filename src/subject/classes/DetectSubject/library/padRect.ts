import type { IPadRectProps, IRect } from '../types';

/** Grows `rect` by `padding` × its own size on each side; may overflow the image. */
export function padRect({ rect, padding }: IPadRectProps): IRect {
  const padX = rect.width * padding;
  const padY = rect.height * padding;

  return {
    x: rect.x - padX,
    y: rect.y - padY,
    width: rect.width + padX * 2,
    height: rect.height + padY * 2,
  };
}
