//
//  MaskableTextChildShadowView.swift
//  MaskableText
//
//  Gabriel Duraye
//

// We want all of our props to be available in the child's shadow view so we
// can create the attributed text before mount and calculate the needed size
// for the view.
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
