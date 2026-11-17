# Nitro Subject — example app

Pick a photo, see the detected subject outlined, switch the padding. On Android, **Download model** calls `Subject.prepare()`.

From the repository root:

```sh
yarn                  # install
yarn example pod      # iOS: install pods
yarn example start    # Metro
yarn example ios      # or: yarn example android
```

```text
App.tsx                      SafeArea + the single screen
src/screens/DetectScreen     picks a photo and drives the detection
src/hooks/useSubjectDetection
src/components/SubjectPreview  photo + subject outline
src/components/ui            Button, SegmentedControl, ScreenHeader
src/library                  containRect (image → view coordinates), describeFrame
src/theme/tokens.ts          colors, spacing, radius
```
