# react-native-nitro-subject

@rules/architecture.md
@rules/comments.md
@rules/native-tests.md
@rules/commits.md
@rules/release.md

React Native library, built with Nitro Modules, that finds the main subject of a photo and returns its bounding box in pixels of the displayed image.

- iOS: Apple Vision only (`VNGenerateForegroundInstanceMaskRequest`, then objectness and attention saliency). Nothing is bundled, so the pod must keep building for the arm64 simulator.
- Android: ML Kit Subject Segmentation through Google Play services. The model is downloaded by the system, never bundled.

Code, comments, docs and commits are in English.

## Commands

```sh
yarn test                 # Jest
yarn test:native:ios      # swift test, includes the real Vision engines
yarn test:native:android  # JUnit
yarn typecheck
yarn format               # Prettier
yarn codegen              # after changing src/specs
yarn example ios          # or android
```
