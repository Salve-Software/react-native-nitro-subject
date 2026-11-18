import { assertDetectProps } from '../assertDetectProps';

describe('assertDetectProps', () => {
  test('accepts a uri alone', () => {
    expect(() => assertDetectProps({ uri: 'file:///photo.jpg' })).not.toThrow();
  });

  test('accepts padding 0 and minAreaRatio bounds', () => {
    expect(() =>
      assertDetectProps({ uri: '/photo.jpg', padding: 0, minAreaRatio: 0 })
    ).not.toThrow();
    expect(() => assertDetectProps({ uri: '/photo.jpg', minAreaRatio: 1 })).not.toThrow();
  });

  test('rejects an empty uri', () => {
    expect(() => assertDetectProps({ uri: '' })).toThrow(
      'Subject.detect: uri must be a non-empty string'
    );
  });

  test('rejects negative or NaN padding, naming the value', () => {
    expect(() => assertDetectProps({ uri: '/a.jpg', padding: -0.1 })).toThrow(
      'Subject.detect: padding must be >= 0, got -0.1'
    );
    expect(() => assertDetectProps({ uri: '/a.jpg', padding: Number.NaN })).toThrow('got NaN');
  });

  test('rejects minAreaRatio outside 0–1', () => {
    expect(() => assertDetectProps({ uri: '/a.jpg', minAreaRatio: 1.5 })).toThrow(
      'Subject.detect: minAreaRatio must be between 0 and 1, got 1.5'
    );
    expect(() => assertDetectProps({ uri: '/a.jpg', minAreaRatio: -1 })).toThrow('got -1');
  });
});
