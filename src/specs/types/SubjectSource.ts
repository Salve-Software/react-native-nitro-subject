/**
 * Engine that found the subject.
 *
 * - `foreground-mask`: iOS 17+, `VNGenerateForegroundInstanceMaskRequest`.
 * - `objectness-saliency`: iOS, `VNGenerateObjectnessBasedSaliencyImageRequest`.
 * - `attention-saliency`: iOS, `VNGenerateAttentionBasedSaliencyImageRequest`.
 * - `subject-segmentation`: Android, ML Kit Subject Segmentation.
 */
export type SubjectSource =
  'foreground-mask' | 'objectness-saliency' | 'attention-saliency' | 'subject-segmentation';
