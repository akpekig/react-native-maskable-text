import {
  type ImageRequireSource,
  type ImageURISource,
  Platform,
  type ProcessedColorValue,
  requireNativeComponent,
  type TextProps,
  UIManager,
} from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-maskable-text' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

export interface MaskableTextViewBaseProps extends TextProps {
  /**
   * Array of positions for each color in gradient
   * Indices must map to @param colors
   */
  positions?: number[];
  /**
   * Direction of gradient in degrees
   * Defaults to 0
   */
  direction?: number;
  /**
   * Image to mask text
   * Overrides gradient props
   */
  image?: ImageRequireSource | ImageURISource;
  /**
   * Text is formatted with Markdown
   * Requires iOS 15+
   */
  useMarkdown?: boolean;
}

export interface MaskableTextViewProps extends MaskableTextViewBaseProps {
  /**
   * Array of hex color codes to be used in gradient
   */
  colors?: ProcessedColorValue[];
}

export interface MaskableTextChildViewProps extends MaskableTextViewProps {
  /**
   * Passes string text as a prop to the child view
   * This is because React Native makes it hell to pass string text as a child
   */
  text: string;
  /** 
   * @internal
   * Passes whether to use gradient on inline text
   */
  useGradient?: boolean;
  /** 
   * @internal
   * Passes whether to use image on inline text
   */
  useImage?: boolean;
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