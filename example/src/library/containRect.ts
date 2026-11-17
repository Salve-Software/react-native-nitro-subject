import type { ISubjectFrame } from '@salve-software/react-native-nitro-subject';

interface IContainRectProps {
  frame: ISubjectFrame;
  viewWidth: number;
  viewHeight: number;
}

/**
 * Converts the frame from image pixels to the coordinates of an
 * `<Image resizeMode="contain">`, which scales the image to fit and centers it.
 */
export function containRect({
  frame,
  viewWidth,
  viewHeight,
}: IContainRectProps) {
  const scale = Math.min(
    viewWidth / frame.imageWidth,
    viewHeight / frame.imageHeight,
  );
  const offsetX = (viewWidth - frame.imageWidth * scale) / 2;
  const offsetY = (viewHeight - frame.imageHeight * scale) / 2;

  return {
    left: offsetX + frame.x * scale,
    top: offsetY + frame.y * scale,
    width: frame.width * scale,
    height: frame.height * scale,
  };
}
