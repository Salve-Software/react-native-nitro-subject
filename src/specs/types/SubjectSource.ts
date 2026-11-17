/**
 * Native engine that located the subject.
 *
 * - `foreground-mask` — iOS 17+, `VNGenerateForegroundInstanceMaskRequest`.
 * - `objectness-saliency` — iOS, `VNGenerateObjectnessBasedSaliencyImageRequest`.
 * - `attention-saliency` — iOS last resort, `VNGenerateAttentionBasedSaliencyImageRequest`.
 * - `subject-segmentation` — Android, ML Kit Subject Segmentation (Google Play services).
 */
export type SubjectSource =
  'foreground-mask' | 'objectness-saliency' | 'attention-saliency' | 'subject-segmentation';
