import type { IImageSize } from './IImageSize';
import type { IRect } from './IRect';

export interface ICoversMinAreaProps {
  rect: IRect;
  image: IImageSize;
  minAreaRatio: number;
}
