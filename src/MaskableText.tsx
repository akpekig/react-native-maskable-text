import React from 'react'
import {processColor, StyleSheet, type TextProps, type ViewStyle} from 'react-native'
import {MaskableTextView, MaskableTextChildView, type MaskableTextViewBaseProps} from './index'

export interface MaskableTextProps extends MaskableTextViewBaseProps {
  /**
   * Array of hex color codes to be used in gradient
   */
  gradientColors?: string[];
  /**
   * Text is formatted with Markdown
   * Requires iOS 15+
   */
  useMarkdown?: boolean;
}

/** This context keeps track of whether the MaskableText component wraps other components or not. */
const TextAncestorContext = React.createContext<[boolean, ViewStyle]>([
  false,
  StyleSheet.create({}),
])
const useTextAncestorContext = () => React.useContext(TextAncestorContext)

const textDefaults: TextProps = {
  allowFontScaling: true,
}

export function MaskableText({style, children, useMarkdown, ...props}: MaskableTextProps) {
  const [isAncestor, rootStyle] = useTextAncestorContext()

  const gradientColors = props.gradientColors?.map(processColor).filter(color => color !== null && color !== undefined);

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
          {...props}
          gradientColors={gradientColors}
          ellipsizeMode={props.ellipsizeMode ?? props.lineBreakMode ?? 'tail'}
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
                  {...props}
                  key={index}
                  gradientColors={gradientColors}
                  useMarkdown={useMarkdown}
                  style={flattenedStyle}
                  text={c}
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
                {...props}
                key={index}
                gradientColors={gradientColors}
                useGradient={!!gradientColors && !props.image && !useMarkdown}
                useImage={!!props.image && !useMarkdown}
                useMarkdown={useMarkdown}
                style={flattenedStyle}
                text={c}
              />
            )
          }
          return null
        })}
      </>
    )
  }
}