# Example app

Pick a photo and the app draws a box around the subject. You can change the padding. On Android there is also a button to download the model.

From the repository root:

```sh
yarn
yarn example pod      # iOS only
yarn example start
yarn example ios      # or android
```

The code is in `src/`: `screens/DetectScreen.tsx` has the screen, `components/` the UI, `hooks/useSubjectDetection.ts` calls the library and `library/containRect.ts` converts the box to screen coordinates.
