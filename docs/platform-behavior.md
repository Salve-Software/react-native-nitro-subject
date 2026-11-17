# Platform behavior

Both platforms share one contract: the native side locates the subject and resolves its box in pixels of the full-resolution **upright** image, unrounded. Padding, clamping to the image, rounding to whole pixels and `minAreaRatio` happen in TypeScript (`src/subject/classes/DetectSubject`), so they behave the same everywhere.

## iOS

Apple frameworks only — Vision, ImageIO, CoreVideo, CoreGraphics. Nothing is vendored, so the pod builds for every architecture, arm64 simulators included.

1. `ImageUri` resolves `file://` URIs and absolute paths; anything else rejects.
2. `UprightImage.load` decodes a thumbnail whose longest side is 1024 px with `kCGImageSourceCreateThumbnailWithTransform`, which applies the EXIF orientation, and records the upright full-resolution size.
3. `SubjectEngineChain` runs the engines best-first; the first match wins:

| Order | Engine | Availability | `source` |
|---|---|---|---|
| 1 | `ForegroundMaskEngine` — box around the union of all foreground instances | iOS 17+ | `foreground-mask` |
| 2 | `SaliencyEngine(.objectnessSaliency)` — most confident salient object | iOS 13+ | `objectness-saliency` |
| 3 | `SaliencyEngine(.attentionSaliency)` — most confident attention region | iOS 13+ | `attention-saliency` |

4. The normalized box is scaled to the full-resolution upright size.

An engine that throws or finds nothing hands over to the next one. If **every** engine threw, `detect` rejects with the last error; if they ran and found nothing, it resolves `null`.

### Simulator

The iOS Simulator has no Neural Engine. Every request is pinned to the CPU there (`VNRequest.preferCPUOnSimulator`), which is enough for attention saliency, but the foreground-mask model fails with *"Could not create inference context"* and objectness finds no objects. Expect `source: 'attention-saliency'` on the simulator and `foreground-mask` on devices running iOS 17+.

The Swift core is covered by `ios/tests/SubjectDetectorTests` (`yarn test:native:ios`), which runs on the host Mac — where the Neural Engine *is* available — including the real Vision engines against synthetic photos, upright and EXIF-rotated.

## Android

[ML Kit Subject Segmentation](https://developers.google.com/ml-kit/vision/subject-segmentation) from `com.google.android.gms:play-services-mlkit-subject-segmentation`. The model is an optional Google Play services module:

- `detect` first asks `ModuleInstallClient.areModulesAvailable`. If the module is missing it calls `deferredInstall` and resolves `null` right away — it never waits for a download.
- `prepare(timeoutMs)` calls `installModules` and waits for it, up to `timeoutMs`.
- Devices without Google Play services resolve `null` and `prepare` resolves `false`.

`UprightImageLoader` accepts `file://`, `content://`, `android.resource://` and absolute paths; decodes with a power-of-two `inSampleSize`, then mirrors/rotates per the EXIF orientation and scales to 1024 px in a single `Matrix`. `SubjectSegmenterEngine` runs with the foreground confidence mask; the box covers every pixel above 0.5 and `confidence` is the mean confidence of those pixels.

The pure Kotlin pieces (uri parsing, EXIF orientation, sample size, mask bounds, install progress) are covered by JUnit (`yarn test:native:android`).
