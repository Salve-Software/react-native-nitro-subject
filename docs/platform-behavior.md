# Platform behavior

The native code finds the subject and returns its box in pixels of the full-size image. Padding, clamping, rounding and `minAreaRatio` are applied in TypeScript, so they work the same on both platforms.

## iOS

Only Apple frameworks are used: Vision, ImageIO, CoreVideo and CoreGraphics.

1. The uri must be `file://` or an absolute path.
2. The image is loaded as a 1024 px thumbnail with the EXIF orientation applied.
3. The engines below run in order until one finds something.
4. The box is scaled back to the full image size.

| Order | Engine | iOS | `source` |
|---|---|---|---|
| 1 | Foreground instance mask (box around all instances) | 17+ | `foreground-mask` |
| 2 | Objectness saliency (most confident object) | 13+ | `objectness-saliency` |
| 3 | Attention saliency (most confident region) | 13+ | `attention-saliency` |

If all engines throw an error, `detect` rejects with the last one. If they run but find nothing, it returns `null`.

### Simulator

The simulator has no Neural Engine. The library runs Vision on the CPU there, but the foreground mask model still fails ("Could not create inference context") and objectness finds nothing, so you get `attention-saliency`. On a device with iOS 17+ you get `foreground-mask`.

The Swift tests in `ios/tests/SubjectDetectorTests` run on the Mac, where the models do work, and check the real engines against generated test images.

## Android

Uses [ML Kit Subject Segmentation](https://developers.google.com/ml-kit/vision/subject-segmentation) through Google Play services. The model is a separate Play services module:

- `detect` checks if the module is installed. If not, it asks Play services to download it later and returns `null` without waiting.
- `prepare(timeoutMs)` downloads it and waits.
- On devices without Play services, `detect` returns `null` and `prepare` returns `false`.

Accepted uris: `file://`, `content://`, `android.resource://` and absolute paths. The image is decoded at a reduced size, rotated according to EXIF and scaled to 1024 px. The box covers every pixel with foreground confidence above 0.5, and `confidence` is the average of those pixels.
