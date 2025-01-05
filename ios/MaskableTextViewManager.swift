//
//  MaskableTextViewManager.swift
//  MaskableText
//
//  Gabriel Duraye
//

@objc(MaskableTextViewManager)
class MaskableTextViewManager: RCTViewManager {
  override func view() -> (MaskableTextView) {
    let view = MaskableTextView()
    
    // Pass image to view for image loading
    if let imageLoader = bridge.module(for: RCTImageLoader.self) as? RCTImageLoader {
      view.imageLoader = imageLoader
    }
    return view
  }

  @objc override static func requiresMainQueueSetup() -> Bool {
    return false
  }
  
  override func shadowView() -> RCTShadowView {
    // Pass the bridge to the shadow view
    return MaskableTextShadowView(bridge: self.bridge)
  }
}

@objc(MaskableTextChildViewManager)
class MaskableTextChildViewManager: RCTBaseTextViewManager {
  override func view() -> (MaskableTextChildView) {
    return MaskableTextChildView()
  }

  @objc override static func requiresMainQueueSetup() -> Bool {
    return false
  }
  
  override func shadowView() -> RCTShadowView {
    return MaskableTextChildShadowView()
  }
}
