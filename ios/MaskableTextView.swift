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
           let newValue {
          textView.textColor = UIColor(patternImage: newValue)
        }
      }
    }
  }

  override init(frame: CGRect) {
    // Use the appropriate TextKit version
    if #available(iOS 16.0, *) {
      textView = UITextView(usingTextLayoutManager: false)
    } else {
      textView = UITextView()
    }
    
    // Add subclassed layout manager
    layoutManager = MaskableTextLayoutManager()
    layoutManager.textStorage = textView.textStorage
    layoutManager.addTextContainer(textView.textContainer)
    textView.textContainer.replaceLayoutManager(layoutManager)

    // Disable scrolling
    textView.isScrollEnabled = false
    // Remove all the padding
    textView.textContainerInset = .zero
    textView.textContainer.lineFragmentPadding = 0

    // Remove other properties
    textView.isEditable = false
    textView.backgroundColor = .clear

    // Init
    super.init(frame: frame)
    self.clipsToBounds = true

    // Add the view
    addSubview(textView)
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
  
  /// Called from the shadow view to set the gradient color on all child text nodes
  func setGradientColor() -> Void {
    DispatchQueue.main.async { [weak self] in
      guard let self,
            let gradientColors else { return }
    
      let glFrame: CGRect = textView.frame
      let glDirection: CGFloat = CGFloat(truncating: gradientDirection ?? 0)
      let glLocations: [NSNumber] = gradientPositions ?? []
      let glColors: [CGColor] = gradientColors.map { $0.cgColor }
      
      let gl = CAGradientLayer(
        frame: glFrame,
        colors: glColors,
        locations: glLocations,
        direction: glDirection
      )
      
      let gradientColor = UIColor(gl, bounds: glFrame)
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
      
      // Redraws string to render inline masked text
      layoutManager.drawGlyphs(forGlyphRange: NSRange(location: 0, length: textView.attributedText.length), at: textView.frame.origin)
      
      if let onTextLayout = self.onTextLayout {
        var lines: [String] = []
        layoutManager.enumerateLineFragments(
          forGlyphRange: NSRange(location: 0, length: textView.attributedText.length))
        { (rect, usedRect, textContainer, glyphRange, stop) in
          let characterRange = self.layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
          let line = (self.textView.text as NSString).substring(with: characterRange)
          lines.append(line)
        }

        onTextLayout([
          "lines": lines
        ])
      }
    }
  }
  
  /// Called from the shadow view to set the image on all child text nodes
  func setImage() {
    guard let imageLoader,
          let image else { return }
    DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
      imageLoader.loadImage(with: image.request) { [self] error, reactImage in
        imageMask = reactImage
      }
    }
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
