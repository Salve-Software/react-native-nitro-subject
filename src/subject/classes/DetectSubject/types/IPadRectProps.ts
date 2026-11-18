import type { IRect } from './IRect';

export interface IPadRectProps {
  rect: IRect;
  /** Fraction of the rect size added on each side. */
  padding: number;
}
