/**
 * Design tokens shared with the other Salve Software example apps —
 * dark-only, single green accent.
 */
export const colors = {
  canvas: '#0d0d0d',
  surface: '#151617',
  surface2: '#1c1e1f',
  line: '#292b2c',
  ink: '#f4f5f6',
  muted: '#9198a1',
  accent: '#22d16c',
  accentInk: '#051b0c',
  danger: '#fb7175',
} as const;

export const alpha = {
  accent15: 'rgba(34, 209, 108, 0.15)',
} as const;

/** 4px grid. */
export const spacing = {
  xxs: 2,
  xs: 4,
  sm: 8,
  md: 12,
  lg: 16,
  xl: 24,
} as const;

export const radius = {
  sm: 6,
  md: 8,
  lg: 10,
  pill: 999,
} as const;
