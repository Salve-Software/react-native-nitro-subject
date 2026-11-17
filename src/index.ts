import { NitroModules } from 'react-native-nitro-modules'
import type { NitroSubject as NitroSubjectSpec } from './specs/nitro-subject.nitro'

export const NitroSubject =
  NitroModules.createHybridObject<NitroSubjectSpec>('NitroSubject')