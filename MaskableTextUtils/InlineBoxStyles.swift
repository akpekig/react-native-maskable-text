//
//  InlineBoxStyles.swift
//  MaskableText
//
//  Gabriel Duraye
//

class InlineBoxStyles: NSObject {
  var padding: YGValue
  var borderRadius: YGValue

  init(padding: YGValue, borderRadius: YGValue) {
    self.padding = padding
    self.borderRadius = borderRadius
  }
  
  override var hash: Int {
    var hasher = Hasher()
    
    hasher.combine(padding.unit)
    hasher.combine(padding.value)
    hasher.combine(borderRadius.unit)
    hasher.combine(borderRadius.value)
    
    return hasher.finalize()
  }
  
  static func == (lhs: InlineBoxStyles, rhs: InlineBoxStyles) -> Bool {
    lhs.padding.unit == rhs.padding.unit
    && lhs.padding.value == rhs.padding.value
    && lhs.borderRadius.unit == rhs.borderRadius.unit
    && lhs.borderRadius.value == rhs.borderRadius.value
  }
}
