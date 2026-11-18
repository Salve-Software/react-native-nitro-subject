import { padRect } from '../padRect';

describe('padRect', () => {
  test('zero padding returns the same rect', () => {
    const rect = { x: 10, y: 20, width: 100, height: 50 };

    expect(padRect({ rect, padding: 0 })).toEqual(rect);
  });

  test('grows each side by padding × the rect size on that axis', () => {
    const rect = { x: 100, y: 200, width: 400, height: 300 };

    expect(padRect({ rect, padding: 0.1 })).toEqual({ x: 60, y: 170, width: 480, height: 360 });
  });

  test('may overflow the image', () => {
    const rect = { x: 0, y: 0, width: 100, height: 100 };

    expect(padRect({ rect, padding: 0.5 })).toEqual({ x: -50, y: -50, width: 200, height: 200 });
  });
});
