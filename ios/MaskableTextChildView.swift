//
//  MaskableTextChildView.swift
//  MaskableText
//
//  Gabriel Duraye
//

/// This view is a proxy to bridge `MaskableTextChildShadowView` to React Native
class MaskableTextChildView: UIView {
  @objc var text: String?
  @objc var onPress: RCTDirectEventBlock?
}
