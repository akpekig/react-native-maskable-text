//
//  MaskableTextChildShadowView.swift
//  MaskableText
//
//  Gabriel Duraye
//

/// This view is responsible for holding the text and attributes of all child text views
class MaskableTextChildShadowView: RCTShadowView {
  @objc var text: String = ""
  
  @objc var textAttributes: RCTTextAttributes = .init()
  
  override func isYogaLeafNode() -> Bool {
    return true
  }

  override func didSetProps(_ changedProps: [String]!) {
    guard let superview = self.superview as? MaskableTextShadowView else {
      return
    }

    if !YGNodeIsDirty(superview.yogaNode) {
      superview.setAttributedText()
    }
  }
}
