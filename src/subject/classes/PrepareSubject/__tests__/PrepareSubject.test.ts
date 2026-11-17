import { PrepareSubject } from '../PrepareSubject.class';
import type { SubjectDetector } from '../../../../specs/SubjectDetector.nitro';

function makeBridge() {
  return {
    detect: jest.fn(),
    prepare: jest.fn().mockResolvedValue(true),
  } as unknown as SubjectDetector;
}

describe('PrepareSubject', () => {
  test('waits 30 s by default', async () => {
    const bridge = makeBridge();

    await new PrepareSubject(bridge).prepare();

    expect(bridge.prepare).toHaveBeenCalledWith(30_000);
  });

  test('forwards a custom timeout and the native answer', async () => {
    const bridge = makeBridge();

    await expect(new PrepareSubject(bridge).prepare({ timeoutMs: 5000 })).resolves.toBe(true);
    expect(bridge.prepare).toHaveBeenCalledWith(5000);
  });

  test('throws synchronously for a non-positive timeout', () => {
    const bridge = makeBridge();

    expect(() => new PrepareSubject(bridge).prepare({ timeoutMs: 0 })).toThrow(
      'Subject.prepare: timeoutMs must be > 0, got 0'
    );
    expect(bridge.prepare).not.toHaveBeenCalled();
  });
});
