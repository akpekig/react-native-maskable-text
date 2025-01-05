//
//  MaskableTextView.swift
//  MaskableText
//
//  Gabriel Duraye
//

/// This view is responsible for mapping props to the shadow view: `MaskableTextShadowView`
class MaskableTextView: RCTTextView, MaskableTextBaseView {
  @objc var numberOfLines: Int = 0 {
    didSet {
      DispatchQueue.main.async { [weak self] in
        if let self {
          textView.textContainer.maximumNumberOfLines = numberOfLines
        }
      }
    }
  }
  @objc var ellipsizeMode: String = "tail" {
    didSet {
      DispatchQueue.main.async { [weak self] in
        if let self {
          textView.textContainer.lineBreakMode = self.getLineBreakMode()
        }
      }
    }
  }
  @objc var onTextLayout: RCTDirectEventBlock?
  
  @objc var gradientColors: [UIColor]?
  
  @objc var gradientPositions: [NSNumber]?
  
  @objc var gradientDirection: NSNumber?
  
  @objc var image: RCTImageSource?
  
  var layoutManager: MaskableTextLayoutManager
  
  var textView: UITextView
  
  var imageLoader: RCTImageLoader? = nil
  
  var imageMask: UIImage? = nil {
    willSet {
      DispatchQueue.main.async { [weak self] in
        if let self,
           let newValue,
           newValue.size.width > 0.0,
           newValue.size.height > 0.0 {
          textView.textColor = UIColor(patternImage: newValue)
        }
      }
    }
  }

  override init(frame: CGRect) {
    // Add subclassed layout manager
    let textStorage = NSTextStorage()
    let textContainer = NSTextContainer(size: frame.size)
    textContainer.lineFragmentPadding = 0
    textContainer.widthTracksTextView = true
    textContainer.heightTracksTextView = true
    layoutManager = MaskableTextLayoutManager()
    layoutManager.textStorage = textStorage
    layoutManager.addTextContainer(textContainer)
    textContainer.replaceLayoutManager(layoutManager)
    textView = UITextView(frame: frame, textContainer: textContainer)
    
    // Disable scrolling
    textView.isScrollEnabled = false
    // Remove all the padding
    textView.textContainerInset = .zero

    // Remove other properties
    textView.isEditable = false
    textView.backgroundColor = .clear
    textView.clipsToBounds = true

    // Init
    super.init(frame: frame)
    layoutManager.scaleFactor = self.contentScaleFactor
    textContainer.size = self.reactContentFrame.size
    textContainer.lineBreakMode = self.getLineBreakMode()
    textView.frame = self.reactContentFrame
    self.clipsToBounds = true

    // Add the view
    addSubview(textView)
    
    // Add gestures for onPress
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(callOnPress(_:)))
    tapGestureRecognizer.isEnabled = true
    textView.addGestureRecognizer(tapGestureRecognizer)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // Resolves some animation issues
  override func reactSetFrame(_ frame: CGRect) {
    UIView.performWithoutAnimation {
      super.reactSetFrame(frame)
    }
  }
  
  /// Redraws string to render inline masked text
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    layoutManager.ensureLayout(for: textView.textContainer)
    let glyphRange = layoutManager.glyphRange(for: textView.textContainer)
    let textRect = layoutManager.usedRect(for: textView.textContainer)
    layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: textRect.origin)
    
    // Pass TextLayoutEvent object to onTextLayout callback
    if let onTextLayout {
      let string = textView.textStorage.string as NSString
      var payload: [String : Any] = [:]
      var lines: [[String : Any]] = []
      layoutManager.enumerateLineFragments(
        forGlyphRange: NSRange(location: 0, length: string.length))
      { (rect, usedRect, textContainer, glyphRange, stop) in
        let characterRange: NSRange = self.layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
        let renderedString: NSString = string.substring(with: characterRange) as NSString
        
        var line: [String : Any] = [
          "text" : renderedString,
          "x" : usedRect.origin.x,
          "y" : usedRect.origin.y,
          "width" : usedRect.size.width,
          "height" : usedRect.size.height,
          "descender" : 0.0,
          "capHeight" : 0.0,
          "ascender" : 0.0,
          "xHeight" : 0.0
        ]
        
        if let font: UIFont = self.textView.textStorage.attributedSubstring(from: characterRange).attribute(NSAttributedString.Key.font, at: 0, effectiveRange: nil) as? UIFont {
          let fontDict: [String : Any] = [
            "descender": -font.descender,
            "capHeight": font.capHeight,
            "ascender" : font.ascender,
            "xHeight": font.xHeight
          ]
          
          line.merge(fontDict) { $1 }
        }

        lines.append(line)
      }
      
      payload.updateValue(lines, forKey: "lines")
      
      if let reactTag = self.reactTag {
        payload.updateValue(reactTag, forKey: "target")
      }

      onTextLayout(payload)
    }
  }
  
  /// Called from the shadow view to set the gradient color on all child text nodes
  func setGradientColor() -> Void {
    DispatchQueue.main.async { [weak self] in
      guard let self,
            let gradientColors else { return }

      let glColors: [CGColor] = gradientColors.map { $0.cgColor }
      
      let gl = CAGradientLayer(
        bounds: textView.bounds,
        colors: glColors,
        locations: gradientPositions ?? [],
        direction: CGFloat(truncating: gradientDirection ?? 0)
      )
      
      let gradientColor = UIColor(from: gl, in: textView.bounds)
      textView.textColor = gradientColor
    }
  }

  /// Called from the shadow view to match the size in React Native
  func setText(
    string: NSAttributedString,
    size: CGSize,
    numberOfLines: Int
  ) -> Void {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      
      textView.frame.size = size
      textView.textContainer.maximumNumberOfLines = numberOfLines
      textView.attributedText = string

      setNeedsDisplay()
    }
  }
  
  /// Called from the shadow view to set the image on all child text nodes
  func setImage() {
    guard let imageLoader,
          let image else { return }
    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
      imageLoader.loadImage(with: image.request) { [self] error, reactImage in
        imageMask = reactImage
      }
    }
  }
  
  @IBAction func callOnPress(_ sender: UITapGestureRecognizer) -> Void {
    // If we find a child, then call onPress
    if let child = getPressed(sender) {
      if textView.selectedTextRange == nil, let onPress = child.onPress {
        onPress(["": ""])
      } else {
        // Clear the selected text range if we are not pressing on a link
        textView.selectedTextRange = nil
      }
    }
  }

  // Try to get the pressed segment
  func getPressed(_ sender: UITapGestureRecognizer) -> MaskableTextChildView? {
    let layoutManager = textView.layoutManager
    var location = sender.location(in: textView)

    // Remove the padding
    location.x -= textView.textContainerInset.left
    location.y -= textView.textContainerInset.top

    // Get the index of the char
    let charIndex = layoutManager.characterIndex(
      for: location,
      in: textView.textContainer,
      fractionOfDistanceBetweenInsertionPoints: nil
    )

    for child in self.reactSubviews() {
      if let child = child as? MaskableTextChildView {
        let fullText = self.textView.attributedText.string
        let range = fullText.range(of: child.text)

        if let lowerBound = range?.lowerBound, let upperBound = range?.upperBound {
          if charIndex >= lowerBound.utf16Offset(in: fullText) && charIndex <= upperBound.utf16Offset(in: fullText) {
            return child
          }
        }
      }
    }

    return nil
  }

  func getLineBreakMode() -> NSLineBreakMode {
    switch self.ellipsizeMode {
    case "head":
      return .byTruncatingHead
    case "middle":
      return .byTruncatingMiddle
    case "tail":
      return .byTruncatingTail
    case "clip":
      return .byClipping
    default:
      return .byTruncatingTail
    }
  }
}
