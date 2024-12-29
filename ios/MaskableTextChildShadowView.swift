//
//  MaskableTextChildShadowView.swift
//  MaskableText
//
//  Gabriel Duraye
//

/// This view is responsible for holding the text and attributes of child text views
class MaskableTextChildShadowView: RCTShadowView {
  @objc var text: String = ""
  
  @objc var textAttributes: RCTTextAttributes = .init()
  
  @objc var gradientColors: NSArray? = nil
  
  @objc var gradientPositions: NSArray? = nil
  
  @objc var gradientDirection: NSNumber? = nil
  
  @objc var useMarkdown: Bool = false
  
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
