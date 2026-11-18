import React, { useState } from 'react';
import { ActivityIndicator, Image, StyleSheet, Text, View } from 'react-native';
import type { ISubjectFrame } from '@salve-software/react-native-nitro-subject';
import { containRect } from '../library/containRect';
import { alpha, colors, radius } from '../theme/tokens';

interface SubjectPreviewProps {
  uri?: string;
  frame: ISubjectFrame | null;
  detecting: boolean;
}

/** The picked photo, letterboxed, with the detected subject outlined on top. */
export function SubjectPreview({
  uri,
  frame,
  detecting,
}: SubjectPreviewProps): React.JSX.Element {
  const [size, setSize] = useState({ width: 0, height: 0 });
  const box =
    frame && size.width > 0
      ? containRect({ frame, viewWidth: size.width, viewHeight: size.height })
      : null;

  return (
    <View
      style={styles.container}
      onLayout={event => setSize(event.nativeEvent.layout)}
    >
      {uri ? (
        <Image
          source={{ uri }}
          style={StyleSheet.absoluteFill}
          resizeMode="contain"
        />
      ) : (
        <Text style={styles.placeholder}>Pick a photo to find its subject</Text>
      )}
      {box ? <View testID="subject-box" style={[styles.box, box]} /> : null}
      {detecting ? (
        <ActivityIndicator
          style={styles.spinner}
          size="large"
          color={colors.accent}
        />
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    borderRadius: radius.lg,
    backgroundColor: colors.surface,
    borderWidth: 1,
    borderColor: colors.line,
    overflow: 'hidden',
    alignItems: 'center',
    justifyContent: 'center',
  },
  placeholder: { color: colors.muted, fontSize: 14 },
  box: {
    position: 'absolute',
    borderWidth: 2,
    borderColor: colors.accent,
    borderRadius: radius.sm,
    backgroundColor: alpha.accent15,
  },
  spinner: { position: 'absolute' },
});
