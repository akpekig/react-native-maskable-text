//
//  MaskableTextChildShadowView.swift
//  MaskableText
//
//  Gabriel Duraye
//

/// This view is responsible for holding the text and attributes of child text views
class MaskableTextChildShadowView: RCTShadowView, MaskableTextBaseView {
  @objc var text: String = ""
  
  @objc var textAttributes: MaskableTextAttributes = .init()
  
  @objc var gradientColors: [UIColor]?
  
  @objc var gradientPositions: [NSNumber]?
  
  @objc var gradientDirection: NSNumber?
  
  @objc var image: RCTImageSource?
  
  @objc var useGradient: Bool = false
  
  @objc var useImage: Bool = false
  
  @objc var useMarkdown: Bool = false
  
  @objc var borderRadius: YGValue = YGValue()
  
  override func isYogaLeafNode() -> Bool {
    return true
  }
  
  override func didSetProps(_ changedProps: [String]!) {
    if let superview = self.superview as? MaskableTextShadowView,
       !YGNodeIsDirty(superview.yogaNode) {
      superview.setAttributedText()
    }
  }
}
