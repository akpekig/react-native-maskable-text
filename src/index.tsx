import {
  requireNativeComponent,
  UIManager,
  Platform,
  type TextProps,
} from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-maskable-text' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

export interface MaskableTextViewProps extends TextProps {
  /**
   * Array of hex color codes to be used in gradient
   */
  colors?: string[];
  /**
   * Array of positions for each color in gradient
   * Indices must map to @param colors
   */
  positions?: number[];
  /**
   * Direction of gradient in degrees. Defaults to 0
   */
  direction?: number;
  /**
   * Text is formatted with Markdown
   * Requires iOS 15+
   */
  useMarkdown?: boolean;
}

export interface MaskableTextChildViewProps extends MaskableTextViewProps {
  /**
   * Passes string text as a prop to the child view
   * This is because React Native makes it hell to pass string text as a child
   */
  text: string;
}

/** This component bridges to the shadow view for the wrapping Text view */
export const MaskableTextView =
  UIManager.getViewManagerConfig('MaskableTextView') != null
    ? requireNativeComponent<MaskableTextViewProps>('MaskableTextView')
    : () => {
        throw new Error(LINKING_ERROR)
      }

/** This component bridges to the shadow view for each individually rendered child view */
export const MaskableTextChildView =
  UIManager.getViewManagerConfig('MaskableTextChildView') != null
    ? requireNativeComponent<MaskableTextChildViewProps>('MaskableTextChildView')
    : () => {
        throw new Error(LINKING_ERROR)
      }

export * from './MaskableText'