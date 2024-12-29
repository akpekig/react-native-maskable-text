import React from 'react'
import {processColor, StyleSheet, type TextProps, type ViewStyle} from 'react-native'
import {MaskableTextView, MaskableTextChildView, type MaskableTextViewBaseProps} from './index'

export interface MaskableTextProps extends MaskableTextViewBaseProps {
  colors?: string[]
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

export function MaskableText({style, children, ...props}: MaskableTextProps) {
  const [isAncestor, rootStyle] = useTextAncestorContext()

  const colors = props.colors?.map(processColor).filter(color => color !== null && color !== undefined);

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
          colors={colors}
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
                  colors={colors}
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
                colors={colors}
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