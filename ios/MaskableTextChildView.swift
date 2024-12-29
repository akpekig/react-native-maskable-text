//
//  MaskableTextChildView.swift
//  MaskableText
//
//  Gabriel Duraye
//

/// This view is a proxy to bridge `MaskableTextChildShadowView` to React Native
class MaskableTextChildView: UIView {
  @objc var text: String? = nil
  
  // NSArray<UIColor>
  @objc var colors: NSArray? = nil
  
  // NSArray<NSNumber>
  @objc var positions: NSArray? = nil
  
  @objc var direction: NSNumber? = nil
  
  @objc var useMarkdown: Bool = false
}
