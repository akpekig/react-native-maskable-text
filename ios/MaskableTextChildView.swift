//
//  MaskableTextChildView.swift
//  MaskableText
//
//  Gabriel Duraye
//

/// This view is a proxy to bridge `MaskableTextChildShadowView` to React Native
class MaskableTextChildView: MaskableTextBaseView {
  @objc var text: String? = nil
  
  @objc var useGradient: Bool = false
  
  @objc var useImage: Bool = false
  
  var processedAttributedString: NSAttributedString = .init()
}
