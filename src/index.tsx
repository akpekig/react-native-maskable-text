import {
  requireNativeComponent,
  UIManager,
  Platform,
  type ViewStyle,
  type TextProps,
} from 'react-native';
import React from 'react';

const LINKING_ERROR =
  `The package 'react-native-maskable-text' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

export interface MaskableTextViewProps extends TextProps {
  children: React.ReactNode
  style: ViewStyle[]
  /**
   * Array of hex color codes to be used in gradient.
   */
    colors?: string[];
  /**
   * Array of positions for each color in gradient.
   * Must map to colors.
   */
  positions?: number[];
  /**
   * Direction of gradient in degrees. Defaults to 0.
   */
  direction?: number;
}

export interface MaskableTextChildViewProps extends TextProps {
  text: string;
  /**
   * Array of hex color codes to be used in gradient.
   */
  colors?: string[];
  /**
   * Array of positions for each color in gradient.
   * Must map to colors.
   */
  positions?: number[];
  /**
   * Direction of gradient in degrees. Defaults to 0.
   */
  direction?: number;
}

export const MaskableTextView =
  UIManager.getViewManagerConfig('MaskableTextView') != null
    ? requireNativeComponent<MaskableTextViewProps>('MaskableTextView')
    : () => {
        throw new Error(LINKING_ERROR)
      }

export const MaskableTextChildView =
  UIManager.getViewManagerConfig('MaskableTextChildView') != null
    ? requireNativeComponent<MaskableTextChildViewProps>('MaskableTextChildView')
    : () => {
        throw new Error(LINKING_ERROR)
      }

export * from './MaskableText'