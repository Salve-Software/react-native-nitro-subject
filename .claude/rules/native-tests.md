# Native tests

- After changing anything in `ios/`, run `yarn test:native:ios`. It runs on the Mac and includes the real Vision engines.
- After changing anything in `android/`, run `yarn test:native:android`.
- New native files used by the core must be symlinked into `ios/tests/SubjectDetectorTests/Sources/SubjectDetectorCore/`, or the Swift tests won't see them.
- Test files mirror the source folders (`detection/maskBounds.kt` → `detection/MaskBoundsTest.kt`).
- Change tests together with the code. New behavior needs a new test.
- Never make a test pass by loosening an assertion, skipping a case or mocking the code under test. Fix the code. If the expectation was wrong, prove it with real output first.
- Test images are generated in code (`FixtureImage`). Don't commit third-party photos.

## Checking on devices

Unit tests don't cover the bridge. Before opening a PR that touches native code, run the example on an arm64 iOS simulator and on an Android emulator with Google Play. On the simulator, results come from `attention-saliency`; that is expected.
