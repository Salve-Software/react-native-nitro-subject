import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { colors, spacing } from '../../theme/tokens';

interface ScreenHeaderProps {
  title: string;
  subtitle?: string;
}

export function ScreenHeader({
  title,
  subtitle,
}: ScreenHeaderProps): React.JSX.Element {
  return (
    <View style={styles.wrapper}>
      <Text style={styles.title}>{title}</Text>
      {subtitle ? <Text style={styles.subtitle}>{subtitle}</Text> : null}
    </View>
  );
}

const styles = StyleSheet.create({
  wrapper: { paddingVertical: spacing.sm, gap: spacing.xxs },
  title: {
    fontSize: 24,
    fontWeight: '800',
    color: colors.ink,
    letterSpacing: -0.3,
  },
  subtitle: { fontSize: 13, fontWeight: '500', color: colors.muted },
});
