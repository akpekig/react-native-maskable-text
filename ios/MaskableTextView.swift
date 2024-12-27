//
//  MaskableTextView.swift
//  MaskableText
//
//  Gabriel Duraye
//

/// This view is responsible for mapping props to the shadow view: `MaskableTextShadowView`
class MaskableTextView: RCTTextView {
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
  
  @objc var colors: NSArray? = nil
  
  @objc var positions: NSArray? = nil
  
  @objc var direction: NSNumber? = nil
  
  @objc var useMarkdown: Bool = false
  
  var textView: UITextView

  // Init
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
  
  // This function is also called from the shadow view
  func setGradientColor(
    gradientColors: NSArray,
    gradientPositions: NSArray?,
    gradientDirection: NSNumber?
  ) -> Void {
    var glColors: [CGColor] = Array()
    var glLocations: [NSNumber] = Array()
    var glDirection: CGFloat = 0
    var glFrame: CGRect = self.textView.frame
    
    gradientColors.enumerateObjects({ object, index, stop in
      if (object is NSString),
        let color = UIColor(hex: object as! String) {
        glColors.append(color.cgColor)
      }
    })
    
    if let gradientPositions {
      gradientPositions.enumerateObjects({ object, index, stop in
        if (object is NSNumber) {
          glLocations.append(object as! NSNumber)
        }
      })
    }
    
    if let gradientDirection {
      glDirection = CGFloat(truncating: gradientDirection)
    }
    
    let gradientLayer = CAGradientLayer(
      frame: glFrame,
      colors: glColors,
      locations: glLocations,
      direction: glDirection
    )
    
    let gradientColor = UIColor(bounds: glFrame, gradientLayer: gradientLayer)
    self.textView.textColor = gradientColor
  }

  // This is the function called from the shadow view.
  func setText(
    string: NSAttributedString,
    size: CGSize,
    numberOfLines: Int
  ) -> Void {
    self.textView.frame.size = size
    self.textView.textContainer.maximumNumberOfLines = numberOfLines
    self.textView.attributedText = string
    
    if let onTextLayout = self.onTextLayout {
      var lines: [String] = []
      textView.layoutManager.enumerateLineFragments(
        forGlyphRange: NSRange(location: 0, length: textView.attributedText.length))
      { (rect, usedRect, textContainer, glyphRange, stop) in
        let characterRange = self.textView.layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
        let line = (self.textView.text as NSString).substring(with: characterRange)
        lines.append(line)
      }

      onTextLayout([
        "lines": lines
      ])
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
