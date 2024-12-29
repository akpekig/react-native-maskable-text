//
//  MaskableTextBaseView.swift
//  MaskableText
//
//  Gabriel Duraye
//

/// Inherited by `MaskableTextChildView` and `MaskableTextView`
open class MaskableTextBaseView: RCTTextView {
  @objc var colors: [UIColor]? = nil
  
  @objc var positions: [NSNumber]? = nil
  
  @objc var direction: NSNumber? = nil
  
  @objc var image: RCTImageSource? = nil
  
  @objc var useMarkdown: Bool = false
}
