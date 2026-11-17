import { fitRectToImage } from '../fitRectToImage';

const image = { width: 1000, height: 800 };

describe('fitRectToImage', () => {
  test('keeps a whole-pixel rect inside the image untouched', () => {
    const rect = { x: 100, y: 200, width: 400, height: 300 };

    expect(fitRectToImage({ rect, image })).toEqual(rect);
  });

  test('snaps outwards so rounding never cuts the subject', () => {
    const rect = { x: 10.6, y: 20.2, width: 99.1, height: 50.5 };

    // left 10.6 → 10, right 109.7 → 110, top 20.2 → 20, bottom 70.7 → 71
    expect(fitRectToImage({ rect, image })).toEqual({ x: 10, y: 20, width: 100, height: 51 });
  });

  test('clips edges that overflow the image', () => {
    const rect = { x: -20, y: 700, width: 200, height: 300 };

    expect(fitRectToImage({ rect, image })).toEqual({ x: 0, y: 700, width: 180, height: 100 });
  });

  test('returns null when the rect lies fully outside the image', () => {
    expect(fitRectToImage({ rect: { x: 2000, y: 0, width: 10, height: 10 }, image })).toBeNull();
  });

  test('returns null for an empty rect', () => {
    expect(fitRectToImage({ rect: { x: 10, y: 10, width: 0, height: 10 }, image })).toBeNull();
  });

  test('returns null when the image size is not positive or not a number', () => {
    const rect = { x: 0, y: 0, width: 10, height: 10 };

    expect(fitRectToImage({ rect, image: { width: 0, height: 800 } })).toBeNull();
    expect(fitRectToImage({ rect, image: { width: 1000, height: Number.NaN } })).toBeNull();
  });
});
