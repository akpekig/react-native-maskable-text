//
//  MaskableTextView.swift
//  MaskableText
//
//  Gabriel Duraye
//

/// This view is responsible for mapping props to the shadow view: `MaskableTextShadowView`
class MaskableTextView: MaskableTextBaseView {
  @objc var numberOfLines: Int = 0 {
    didSet {
      textView.textContainer.maximumNumberOfLines = numberOfLines
    }
  }
  @objc var ellipsizeMode: String = "tail" {
    didSet {
      textView.textContainer.lineBreakMode = self.getLineBreakMode()
    }
  }
  @objc var onTextLayout: RCTDirectEventBlock?
  
  var textView: UITextView
  
  var imageLoader: RCTImageLoader? = nil
  
  var imageMask: UIImage? = nil {
    willSet {
      DispatchQueue.main.async { [self] in
        if let newValue {
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
    guard let colors else { return }
  
    let glFrame: CGRect = textView.frame
    let glDirection: CGFloat = CGFloat(truncating: direction ?? 0)
    let glLocations: [NSNumber] = positions ?? []
    let glColors: [CGColor] = colors.map { $0.cgColor }
    
    let gradientLayer = CAGradientLayer(
      frame: glFrame,
      colors: glColors,
      locations: glLocations,
      direction: glDirection
    )
    
    let gradientColor = UIColor(bounds: glFrame, gradientLayer: gradientLayer)
    textView.textColor = gradientColor
  }
  
  /// Called from the shadow view to set the gradient color on specific child text nodes
  func setInlineGradientColor() {
    guard let children: [UIView] = self.reactSubviews() else { return }
    var currentOffset: CGRect = .init()
    children.forEach({
      guard let child = $0 as? MaskableTextChildView else { return }
      textView.attributedText.enumerateAttribute(
        NSAttributedString.Key.useGradient,
        in: NSMakeRange(0, textView.attributedText.string.count)) { attribute, range, stop in
          guard attribute is Bool else {
            currentOffset = textView
              .attributedText
              .attributedSubstring(from: range)
              .boundingRect(
                with: textView.textContainer.size,
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                context: nil)
              .offsetBy(
                dx: textView.textContainerInset.left,
                dy: textView.textContainerInset.top)
            
            return
          }
          
          var glColors: [CGColor]
          
          if let childColors = child.colors {
            glColors = childColors.map { $0.cgColor }
          } else if let colors {
            glColors = colors.map { $0.cgColor }
          } else {
            return
          }
          
          DispatchQueue.main.async { [self] in
            let childFrame: CGRect = textView
              .attributedText
              .attributedSubstring(from: range)
              .boundingRect(
                with: textView.textContainer.size,
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                context: nil)
              .offsetBy(
                dx: currentOffset.width + currentOffset.origin.x,
                dy: textView.textContainerInset.top)
            
            let glLocations: [NSNumber] = child.positions ?? positions ?? []
            let glDirection = CGFloat(truncating: child.direction ?? direction ?? 0)
            let gl = CAGradientLayer(
              frame: childFrame,
              colors: glColors,
              locations: glLocations,
              direction: glDirection)
            let glMask = UITextView(frame: textView.frame, textContainer: textView.textContainer)
            
            glMask.attributedText = textView.attributedText
            gl.mask = glMask.layer
            
            textView.layer.addSublayer(gl)
          }
      }
    })
  }

  /// Called from the shadow view to match the size in React Native
  func setText(
    string: NSAttributedString,
    size: CGSize,
    numberOfLines: Int
  ) -> Void {
    textView.frame.size = size
    textView.textContainer.maximumNumberOfLines = numberOfLines
    textView.attributedText = string
    
    if let onTextLayout = self.onTextLayout {
      var lines: [String] = []
      textView.layoutManager.enumerateLineFragments(
        forGlyphRange: NSRange(location: 0, length: textView.attributedText.length))
      { [self] (rect, usedRect, textContainer, glyphRange, stop) in
        let characterRange = textView.layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
        let line = (textView.text as NSString).substring(with: characterRange)
        lines.append(line)
      }

      onTextLayout([
        "lines": lines
      ])
    }
  }
  
  /// Called from the shadow view to set the image on all child text nodes
  func setImage() {
    guard let imageLoader,
          let image else { return }
    DispatchQueue.main.async {
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
