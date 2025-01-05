//
//  CGFloat+init.swift
//  MaskableText
//
//  Gabriel Duraye
//
extension CGFloat {
  /// Creates an instance from a Yoga value based on the Yoga unit
  /// - Parameter value: The Yoga value to convert
  public init(from yogaValue: YGValue) {
    if yogaValue.value <= 0.0 {
      self.init()
    } else if yogaValue.unit == YGUnit.percent {
      let cgFloat = RCTCoreGraphicsFloatFromYogaFloat(yogaValue.value / 100.00)
      self.init(cgFloat)
    } else {
      let cgFloat = RCTCoreGraphicsFloatFromYogaFloat(yogaValue.value)
      self.init(cgFloat)
    }
  }
}
