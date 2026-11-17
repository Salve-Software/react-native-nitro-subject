import type { SubjectDetector } from '../../../specs/SubjectDetector.nitro';
import type { ISubjectFrame } from '../../../types';
import type { IDetectProps } from './types';
import { DEFAULT_MIN_AREA_RATIO, DEFAULT_PADDING } from './constants';
import { assertDetectProps, coversMinArea, fitRectToImage, padRect } from './library';

export class DetectSubject {
  constructor(private readonly _bridge: SubjectDetector) {}

  detect(props: IDetectProps): Promise<ISubjectFrame | null> {
    // Validated before any await so a caller bug throws at the call site
    // instead of surfacing later as a rejected promise.
    assertDetectProps(props);

    return this._detect(props);
  }

  private async _detect({
    uri,
    padding = DEFAULT_PADDING,
    minAreaRatio = DEFAULT_MIN_AREA_RATIO,
  }: IDetectProps): Promise<ISubjectFrame | null> {
    const native = await this._bridge.detect(uri);

    if (!native) return null;

    const image = { width: native.imageWidth, height: native.imageHeight };
    const rect = fitRectToImage({ rect: padRect({ rect: native, padding }), image });

    if (!rect || !coversMinArea({ rect, image, minAreaRatio })) return null;

    return {
      ...rect,
      imageWidth: image.width,
      imageHeight: image.height,
      ...(native.confidence !== undefined && { confidence: native.confidence }),
      source: native.source,
    };
  }
}
