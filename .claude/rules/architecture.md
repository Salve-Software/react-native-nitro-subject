# Architecture

The native code only finds the subject and returns its box in pixels of the full image. Everything else (padding, clamping, rounding, `minAreaRatio`, validation) is done in TypeScript, so both platforms behave the same and it is tested once.

## TypeScript

```
src/
  index.ts                 public exports only
  specs/                   Nitro spec and the types it uses
    SubjectDetector.nitro.ts
    types/
  types/                   public types (ISubjectFrame)
  subject/
    Subject.class.ts       static facade, creates the hybrid object
    classes/
      DetectSubject/       one class per responsibility
        DetectSubject.class.ts
        types/             one interface per file, I-prefixed, plus index.ts
        library/           one pure function per file, plus index.ts
        constants/         one UPPER_CASE constant per file, plus index.ts
        __tests__/
      PrepareSubject/
```

- Classes get the bridge in the constructor (`new DetectSubject(bridge)`), so tests pass a fake bridge.
- Methods take a props object (`detect({ uri, padding })`), not positional arguments.
- Invalid props throw synchronously. Do not make the public method `async`, or the throw turns into a rejection.
- Each folder has an `index.ts` barrel. Code outside the folder imports from the barrel; tests import the file they test.
- After changing `src/specs`, run `yarn codegen` and commit `nitrogen/`.

## iOS (`ios/`)

```
HybridSubjectDetector.swift   Nitro entry point, no logic
SubjectLocator.swift          uri in, LocatedSubject out
Image/                        uri parsing, EXIF size, upright thumbnail
Detection/                    boxes, mask bounds, engine protocol and chain
Engines/                      Vision requests
*+toNative.swift              mapping to the generated Nitro types
tests/SubjectDetectorTests/   SwiftPM package, sources are symlinks
```

- One type per file. Extensions go in `Type+method.swift`.
- Only `HybridSubjectDetector` and the `+toNative` files may use Nitro types. Everything else must compile in the SwiftPM test package.
- Only Apple frameworks. Never add a pod or a vendored binary.

## Android (`android/src/main/java/com/nitrosubject/`)

```
HybridSubjectDetector.kt   Nitro entry point, no logic
SubjectLocator.kt          uri in, LocatedSubject out
image/                     uri parsing, EXIF orientation, bitmap loading
detection/                 boxes and mask bounds
segmentation/              ML Kit client
model/                     Play services module install
```

- One class per file. Extensions go in `Type+method.kt`.
- Keep Android-free logic (parsing, math, state mapping) in plain Kotlin so JUnit can test it without Robolectric.
- Blocking calls (`Tasks.await`) only inside `Promise.parallel`.

## Example app (`example/src/`)

`screens/` for screens, `components/ui/` for generic UI, `components/` for app components, `hooks/`, `library/` for pure helpers and `theme/tokens.ts` for colors and spacing. No inline colors or magic spacing in components.
