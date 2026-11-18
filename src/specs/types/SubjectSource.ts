/** Engine that found the subject; see docs/platform-behavior.md. */
export type SubjectSource =
  'foreground-mask' | 'objectness-saliency' | 'attention-saliency' | 'subject-segmentation';
