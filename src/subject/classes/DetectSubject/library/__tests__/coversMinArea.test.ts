import { coversMinArea } from '../coversMinArea';

const image = { width: 1000, height: 800 };
const rectCoveringFifteenPercent = { x: 0, y: 0, width: 400, height: 300 };

describe('coversMinArea', () => {
  test('true when the rect covers more than the ratio', () => {
    expect(coversMinArea({ rect: rectCoveringFifteenPercent, image, minAreaRatio: 0.1 })).toBe(
      true
    );
  });

  test('true when the rect covers exactly the ratio', () => {
    expect(coversMinArea({ rect: rectCoveringFifteenPercent, image, minAreaRatio: 0.15 })).toBe(
      true
    );
  });

  test('false when the rect covers less than the ratio', () => {
    expect(coversMinArea({ rect: rectCoveringFifteenPercent, image, minAreaRatio: 0.2 })).toBe(
      false
    );
  });
});
