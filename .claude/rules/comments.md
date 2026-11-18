# Comments

Doc comments only, one line, on top of a declaration. No `//` inside code.

## Where a doc comment can go

On top of a class, method, function, type or constant. Say what it is, or why it exists when that is not obvious from the name.

```ts
/** Clips `rect` to the image and rounds it outwards, or `null` when nothing is left. */
export function fitRectToImage({ rect, image }: IFitRectToImageProps): IRect | null {
```

```swift
/// Runs the request on the CPU in the simulator, which has no Neural Engine.
func preferCPUOnSimulator() {
```

Fields of exported public types (`IDetectProps`, `ISubjectFrame`) may also have a one-line comment, because it shows up in the user's editor. Internal types don't.

## Not allowed

- `//` comments inside functions, tests or objects.
- Doc comments with more than one line. If it doesn't fit in one line, the code needs a better name or the explanation belongs in the commit message or in `docs/`.
- Comments that repeat the code.

In tests, put the reason in the test name or in a variable name instead of a comment:

```ts
// ❌
// 400 × 300 of 1000 × 800 = 15%
const rect = { x: 0, y: 0, width: 400, height: 300 };

// ✅
const rectCoveringFifteenPercent = { x: 0, y: 0, width: 400, height: 300 };
```

## Exceptions

Tool directives (`// swift-tools-version`, `// eslint-disable-next-line <rule>`), config files (workflows, podspec) and generated code in `nitrogen/`.
