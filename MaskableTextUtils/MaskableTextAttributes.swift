//
//  MaskableTextAttributes.swift
//  MaskableText
//
//  Gabriel Duraye
//

/// Enables extra CSS properties on NSAttributedString objects
class MaskableTextAttributes: RCTTextAttributes {
  @objc var padding: YGValue = YGValue()
  @objc var borderRadius: YGValue = YGValue()
  
  override func effectiveTextAttributes() -> [NSAttributedString.Key : Any] {
    var textAttributes = super.effectiveTextAttributes()
    textAttributes.updateValue(InlineBoxStyles(padding: padding, borderRadius: borderRadius), forKey: NSAttributedString.Key.boxStyles)
    return textAttributes
  }
}
