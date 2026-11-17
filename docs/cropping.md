# Cropping with the detected frame

`Subject.detect` resolves whole pixels of the **upright** image — after its EXIF orientation is applied, which is what users see and what image croppers operate on.

## expo-image-manipulator

```ts
import { ImageManipulator, SaveFormat } from 'expo-image-manipulator';
import { Subject } from '@salve-software/react-native-nitro-subject';

export async function cropToSubject(uri: string): Promise<string> {
  const frame = await Subject.detect({ uri, padding: 0.05, minAreaRatio: 0.02 });
  if (!frame) return uri; // nothing found: keep the whole photo

  const context = ImageManipulator.manipulate(uri);
  context.crop({ originX: frame.x, originY: frame.y, width: frame.width, height: frame.height });
  const image = await context.renderAsync();
  const result = await image.saveAsync({ format: SaveFormat.JPEG, compress: 0.9 });

  return result.uri;
}
```

## react-native-nitro-image

`loadImage` reports the upright size but crops the stored bitmap, so bake the rotation in first by redrawing the image at its own size:

```ts
import { loadImage } from 'react-native-nitro-image';
import { Subject } from '@salve-software/react-native-nitro-subject';

const frame = await Subject.detect({ uri, padding: 0.05 });

if (frame) {
  const original = await loadImage({ filePath: uri.replace('file://', '') });
  const upright = await original.resizeAsync(original.width, original.height);
  const cropped = await upright.cropAsync(frame.x, frame.y, frame.x + frame.width, frame.y + frame.height);
}
```

## Square thumbnail around the subject

```ts
import type { ISubjectFrame } from '@salve-software/react-native-nitro-subject';

export function squareAround(frame: ISubjectFrame) {
  const side = Math.min(Math.max(frame.width, frame.height), frame.imageWidth, frame.imageHeight);
  const centerX = frame.x + frame.width / 2;
  const centerY = frame.y + frame.height / 2;
  const x = Math.min(Math.max(centerX - side / 2, 0), frame.imageWidth - side);
  const y = Math.min(Math.max(centerY - side / 2, 0), frame.imageHeight - side);

  return { x: Math.round(x), y: Math.round(y), width: side, height: side };
}
```
