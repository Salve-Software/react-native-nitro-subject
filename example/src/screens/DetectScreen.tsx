import React, { useState } from 'react';
import { Platform, StyleSheet, Text, View } from 'react-native';
import { launchImageLibrary } from 'react-native-image-picker';
import { Subject } from '@salve-software/react-native-nitro-subject';
import { SubjectPreview } from '../components/SubjectPreview';
import { Button, ScreenHeader, SegmentedControl } from '../components/ui';
import {
  useSubjectDetection,
  type DetectionState,
} from '../hooks/useSubjectDetection';
import { describeFrame } from '../library/describeFrame';
import { colors, spacing } from '../theme/tokens';

const PADDINGS = [
  { value: 0, label: 'No padding' },
  { value: 0.05, label: '5%' },
  { value: 0.15, label: '15%' },
] as const;

type ModelStatus = 'unknown' | 'downloading' | 'ready' | 'unavailable';

export function DetectScreen(): React.JSX.Element {
  const [uri, setUri] = useState<string>();
  const [padding, setPadding] = useState<number>(PADDINGS[1].value);
  const [modelStatus, setModelStatus] = useState<ModelStatus>('unknown');
  const { state, detect } = useSubjectDetection();

  async function pickPhoto() {
    const response = await launchImageLibrary({
      mediaType: 'photo',
      selectionLimit: 1,
    });
    const picked = response.assets?.[0]?.uri;
    if (!picked) return;
    setUri(picked);
    detect(picked, padding);
  }

  function changePadding(value: number) {
    setPadding(value);
    if (uri) detect(uri, value);
  }

  async function prepareModel() {
    setModelStatus('downloading');
    setModelStatus(
      (await Subject.prepare({ timeoutMs: 60_000 })) ? 'ready' : 'unavailable',
    );
  }

  return (
    <View style={styles.container}>
      <ScreenHeader
        title="Nitro Subject"
        subtitle="Find the main subject of a photo"
      />

      <SubjectPreview
        uri={uri}
        frame={state.status === 'done' ? state.frame : null}
        detecting={state.status === 'detecting'}
      />

      <Text
        testID="result"
        style={[styles.result, state.status === 'error' && styles.error]}
      >
        {resultText(state)}
      </Text>

      <SegmentedControl
        options={PADDINGS}
        value={padding}
        onChange={changePadding}
      />

      <Button label="Pick photo" onPress={pickPhoto} testID="pick-photo" />

      {Platform.OS === 'android' ? (
        <Button
          label={modelButtonLabel(modelStatus)}
          variant="ghost"
          onPress={prepareModel}
          loading={modelStatus === 'downloading'}
        />
      ) : null}
    </View>
  );
}

function resultText(state: DetectionState): string {
  switch (state.status) {
    case 'idle':
      return '';
    case 'detecting':
      return 'Detecting…';
    case 'error':
      return state.message;
    case 'done':
      return state.frame
        ? `${describeFrame(state.frame)} · ${state.elapsedMs} ms`
        : `No subject found · ${state.elapsedMs} ms`;
  }
}

function modelButtonLabel(status: ModelStatus): string {
  switch (status) {
    case 'ready':
      return 'Model ready';
    case 'unavailable':
      return 'Model unavailable, retry';
    default:
      return 'Download model';
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingHorizontal: spacing.lg,
    paddingBottom: spacing.lg,
    gap: spacing.md,
  },
  result: {
    color: colors.ink,
    fontSize: 13,
    lineHeight: 18,
    minHeight: 36,
    fontVariant: ['tabular-nums'],
  },
  error: { color: colors.danger },
});
