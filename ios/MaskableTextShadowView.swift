//
//  MaskableTextShadowView.swift
//  MaskableText
//
//  Gabriel Duraye
//

/// This view is responsible for rendering child views of the wrapping MaskableText view
/// Its exposed properties are mapped from `MaskableTextView`
class MaskableTextShadowView: RCTShadowView, MaskableTextBaseView {
  @objc var numberOfLines: Int = 0
  
  @objc var allowsFontScaling: Bool = true
  
  @objc var gradientColors: [UIColor]?
  
  @objc var gradientPositions: [NSNumber]?
  
  @objc var gradientDirection: NSNumber?
  
  // For `MaskableTextBaseView` conformance
  @objc var image: RCTImageSource?
  
  // For storing our created string
  var attributedText: NSAttributedString = .init()
  // For storing the frame size when we first calculate it
  var frameSize: CGSize = .init()
  // For storing the frame rect
  var frameRect: CGRect = .init()
  // For storing the line height when we create the styles
  var lineHeight: CGFloat = 0
  // For loading inline text clipping images
  var imageLoader: RCTImageLoader? = nil
  
  var bridge: RCTBridge

  init(bridge: RCTBridge) {
    self.bridge = bridge
    if let imageLoader = bridge.module(for: RCTImageLoader.self) as? RCTImageLoader {
      self.imageLoader = imageLoader
    }
    super.init()

    // We need to set a custom measure func here to calculate the height correctly
    YGNodeSetMeasureFunc(self.yogaNode) { node, width, widthMode, height, heightMode in
      // Get the shadow view and determine the needed size to set
      let shadowView = Unmanaged<MaskableTextShadowView>.fromOpaque(YGNodeGetContext(node)).takeUnretainedValue()
      return shadowView.getNeededSize(maxWidth: width)
    }
  }

  // Tell React Native to not use flexbox for this view
  override func isYogaLeafNode() -> Bool {
    return true
  }

  override func insertReactSubview(_ subview: RCTShadowView!, at atIndex: Int) {
    // We only want to insert shadow view children
    if subview.isKind(of: MaskableTextChildShadowView.self) {
      super.insertReactSubview(subview, at: atIndex)
    }
  }

  // Update the text when subviews change
  override func didUpdateReactSubviews() {
    setAttributedText()
  }

  override func layoutSubviews(with layoutContext: RCTLayoutContext) {
    // Don't do anything if the layout is dirty
    if(YGNodeIsDirty(yogaNode)) {
      return
    }

    // Update the text
    bridge.uiManager.addUIBlock { [self] uiManager, viewRegistry in
      // Try to get the view
      guard let view: MaskableTextView = viewRegistry?[self.reactTag] as? MaskableTextView else {
        return
      }
          
      view.setText(
        string: attributedText,
        size: frameSize,
        numberOfLines: numberOfLines)
      
      view.setGradientColor()
      
      view.setImage()
    }
  }

  override func dirtyLayout() {
    super.dirtyLayout()
    // This will tell React to remeasure the view
    YGNodeMarkDirty(self.yogaNode)
  }

  func setAttributedText() -> Void {
    // Create an attributed string to store each of the segments
    let finalAttributedString = NSMutableAttributedString()
    
    self.reactSubviews().forEach { [weak self] subview in
      guard let self,
            let child = subview as? MaskableTextChildShadowView else {
        return
      }
    
      let reactAttributes: [NSAttributedString.Key : Any] = child.textAttributes.effectiveTextAttributes()
      var string = NSMutableAttributedString(string: child.text, attributes: reactAttributes)
      
      if child.useGradient {
        string.addAttributes([NSAttributedString.Key.foregroundGradient : InlineGradient(
          colors: child.gradientColors ?? gradientColors,
          direction: child.gradientDirection ?? gradientDirection,
          positions: child.gradientPositions ?? gradientPositions)], range: NSRange(location: 0, length: child.text.count))
      }
      
      if child.useImage,
        let childImageSource = child.image,
        let imageLoader = self.imageLoader {
        string.addAttributes([NSAttributedString.Key.foregroundImage : InlineImage(source: childImageSource, imageLoader: imageLoader)], range: NSRange(location: 0, length: child.text.count))
      }
      
      if #available(iOS 15, *), (child.useMarkdown) {
        do {
          string = try NSMutableAttributedString(markdown: child.text)
          string.addAttributes(reactAttributes, range: NSRange(location: 0, length: child.text.count))
        } catch {
          // NOOP
        }
      }
      
      if let paragraphStyle = child.textAttributes.effectiveParagraphStyle() {
        self.lineHeight = paragraphStyle.maximumLineHeight
      } else {
        self.lineHeight = child.textAttributes.lineHeight
      }

      finalAttributedString.append(string)
    }

    attributedText = finalAttributedString
    dirtyLayout()
  }

  func getNeededSize(maxWidth: Float) -> YGSize {
    // Create the max size and figure out the size of the entire text
    let maxSize = CGSize(width: CGFloat(maxWidth), height: CGFloat(MAXFLOAT))
    let textSize = attributedText.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil)
    
    // Figure out how many total lines there are
    var totalLines: Int = 1
    
    if (lineHeight > 0) {
      totalLines = Int(ceil(textSize.height / lineHeight))
    }

    // Default to the text size
    var neededSize: CGSize = textSize.size

    // If the total lines > max number, return size with the max
    if numberOfLines != 0, totalLines > numberOfLines {
      neededSize = CGSize(width: CGFloat(maxWidth), height: CGFloat(CGFloat(numberOfLines) * lineHeight))
    }

    frameSize = neededSize
    frameRect = CGRect(origin: CGPoint(), size: neededSize)
    return YGSize(width: Float(neededSize.width), height: Float(neededSize.height))
  }
}
