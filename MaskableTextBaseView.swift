//
//  MaskableTextBaseView.swift
//  MaskableText
//
//  Gabriel Duraye
//

/// Inherited by `MaskableTextView`, `MaskableTextShadowView` and `MaskableTextChildShadowView`
@objc protocol MaskableTextBaseView {
  @objc var gradientColors: [UIColor]? { get set }
  
  @objc var gradientPositions: [NSNumber]? { get set }
  
  @objc var gradientDirection: NSNumber? { get set }
  
  @objc var image: RCTImageSource? { get set }
}
