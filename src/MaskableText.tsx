import React from 'react'
import {StyleSheet, type TextProps, type ViewStyle} from 'react-native'
import {MaskableTextView, MaskableTextChildView} from './index'

export interface MaskableTextProps extends TextProps {
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
  /**
   * Text is formatted with Markdown. Requires iOS 15.
   */
  useMarkdown?: boolean;
}

const TextAncestorContext = React.createContext<[boolean, ViewStyle]>([
  false,
  StyleSheet.create({}),
])
const useTextAncestorContext = () => React.useContext(TextAncestorContext)

const textDefaults: TextProps = {
  allowFontScaling: true,
}

export function MaskableText({style, children, ...rest}: MaskableTextProps) {
  const [isAncestor, rootStyle] = useTextAncestorContext()

  // Flatten the styles, and apply the root styles when needed
  const flattenedStyle = React.useMemo(
    () => StyleSheet.flatten([rootStyle, style]),
    [rootStyle, style],
  )

  if (!isAncestor) {
    return (
      <TextAncestorContext.Provider value={[true, flattenedStyle]}>
        <MaskableTextView
          {...textDefaults}
          {...rest}
          ellipsizeMode={rest.ellipsizeMode ?? rest.lineBreakMode ?? 'tail'}
          style={[{flex: 1}, flattenedStyle]}
          onPress={undefined}
          onLongPress={undefined}
          >
          {React.Children.toArray(children).map((c, index) => {
            if (React.isValidElement(c)) {
              return c
            } else if (typeof c === 'string') {
              return (
                <MaskableTextChildView
                  key={index}
                  style={flattenedStyle}
                  text={c}
                  {...rest}
                />
              )
            }

            return null
          })}
        </MaskableTextView>
      </TextAncestorContext.Provider>
    )
  } else {
    return (
      <>
        {React.Children.toArray(children).map((c, index) => {
          if (React.isValidElement(c)) {
            return c
          } else if (typeof c === 'string') {
            return (
              <MaskableTextChildView
                key={index}
                style={flattenedStyle}
                text={c}
                {...rest}
              />
            )
          }
          return null
        })}
      </>
    )
  }
}