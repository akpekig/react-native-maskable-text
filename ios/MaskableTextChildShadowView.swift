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
  
  @objc var useGradient: Bool = false
  
  @objc var useImage: Bool = false
  
  @objc var useMarkdown: Bool = false
  
  var processedAttributedString: NSAttributedString = .init() {
    willSet {
      bridge.uiManager.addUIBlock { [self] uiManager, viewRegistry in
        guard let view = viewRegistry?[self.reactTag] as? MaskableTextChildView else {
          return
        }
        
        view.processedAttributedString = newValue
      }
    }
  }
  
  var bridge: RCTBridge

  init(bridge: RCTBridge) {
    self.bridge = bridge
    super.init()
  }
  
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
