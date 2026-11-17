import { DetectSubject } from '../DetectSubject.class';
import type { SubjectDetector } from '../../../../specs/SubjectDetector.nitro';
import type { NativeSubjectFrame } from '../../../../specs/types';

function makeBridge(result: NativeSubjectFrame | undefined) {
  return {
    detect: jest.fn().mockResolvedValue(result),
    prepare: jest.fn(),
  } as unknown as SubjectDetector;
}

const NATIVE: NativeSubjectFrame = {
  x: 100.4,
  y: 200,
  width: 400,
  height: 300,
  imageWidth: 1000,
  imageHeight: 800,
  confidence: 0.9,
  source: 'foreground-mask',
};

describe('DetectSubject', () => {
  test('passes the uri to the native detector untouched', async () => {
    const bridge = makeBridge(NATIVE);

    await new DetectSubject(bridge).detect({ uri: 'file:///a%20b.jpg' });

    expect(bridge.detect).toHaveBeenCalledWith('file:///a%20b.jpg');
  });

  test('resolves the native box snapped to whole pixels, with image size, confidence and source', async () => {
    const frame = await new DetectSubject(makeBridge(NATIVE)).detect({ uri: '/a.jpg' });

    expect(frame).toEqual({
      x: 100,
      y: 200,
      width: 401,
      height: 300,
      imageWidth: 1000,
      imageHeight: 800,
      confidence: 0.9,
      source: 'foreground-mask',
    });
  });

  test('applies padding before clipping to the image', async () => {
    const native = { ...NATIVE, x: 0, y: 0, width: 500, height: 400 };

    const frame = await new DetectSubject(makeBridge(native)).detect({
      uri: '/a.jpg',
      padding: 0.1,
    });

    expect(frame).toMatchObject({ x: 0, y: 0, width: 550, height: 440 });
  });

  test('resolves null when native finds nothing', async () => {
    await expect(
      new DetectSubject(makeBridge(undefined)).detect({ uri: '/a.jpg' })
    ).resolves.toBeNull();
  });

  test('resolves null when the box is below minAreaRatio', async () => {
    // 400 × 300 of 1000 × 800 = 15%
    const detect = new DetectSubject(makeBridge({ ...NATIVE, x: 100 }));

    await expect(detect.detect({ uri: '/a.jpg', minAreaRatio: 0.2 })).resolves.toBeNull();
    await expect(detect.detect({ uri: '/a.jpg', minAreaRatio: 0.15 })).resolves.not.toBeNull();
  });

  test('omits confidence when the native engine does not report one', async () => {
    const native = { ...NATIVE, confidence: undefined };

    const frame = await new DetectSubject(makeBridge(native)).detect({ uri: '/a.jpg' });

    expect(frame).not.toHaveProperty('confidence');
  });

  test('throws synchronously for invalid props without calling native', () => {
    const bridge = makeBridge(NATIVE);

    expect(() => new DetectSubject(bridge).detect({ uri: '/a.jpg', padding: -1 })).toThrow(
      'Subject.detect: padding must be >= 0'
    );
    expect(bridge.detect).not.toHaveBeenCalled();
  });

  test('propagates native rejections', async () => {
    const bridge = {
      detect: jest.fn().mockRejectedValue(new Error('unreadable')),
      prepare: jest.fn(),
    } as unknown as SubjectDetector;

    await expect(new DetectSubject(bridge).detect({ uri: '/a.jpg' })).rejects.toThrow('unreadable');
  });
});
