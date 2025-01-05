//
//  MaskableTextLayoutManager.swift
//  MaskableText
//
//  Gabriel Duraye
//

class MaskableTextLayoutManager: NSLayoutManager {
  let cache: NSCache<AnyObject, UIColor>
  public var scaleFactor: CGFloat = 1.0

  required init?(coder: NSCoder) {
    self.cache = .init()
    
    self.cache.totalCostLimit = 128 * 1024 * 1024 // 128 MB
    
    super.init(coder: coder)
  }
  
  init(scaleFactor: CGFloat? = nil) {
    self.cache = .init()
    
    self.cache.totalCostLimit = 128 * 1024 * 1024 // 128 MB
    
    if let scaleFactor {
      self.scaleFactor = scaleFactor
    }
    
    super.init()
  }
  
  /// Renders custom text foreground colors
  /// - Parameter glyphsToShow: A range of characters within in which custom text foreground colors will be rendered
  /// - Parameter origin: Origin point of frame in which characters are rendered
  override func drawGlyphs(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
    super.drawGlyphs(forGlyphRange: glyphsToShow, at: origin)
    
    guard let textStorage,
    let textContainer = textContainers.first else { return }
    
    textStorage.beginEditing()
    
    // Render image attributed strings
    textStorage.enumerateAttribute(
      NSAttributedString.Key.foregroundImage,
      in: glyphsToShow) { value, range, _ in
        guard let inlineImage = value as? InlineImage else {
          return
        }
        
        if let cachedImageColor = cache.object(forKey: inlineImage) {
          textStorage.addAttribute(NSAttributedString.Key.foregroundColor, value: cachedImageColor, range: range)
        }
        
        inlineImage.useImage { image in
          guard let image else { return }
          let imageColor = UIColor(patternImage: image)
          textStorage.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(patternImage: image), range: range)
          // Cache image color
          self.cache.setObject(imageColor, forKey: inlineImage, cost: MemoryLayout.size(ofValue: imageColor))
        }
    }
    
    // Render gradient attributed strings
    textStorage.enumerateAttribute(
      NSAttributedString.Key.foregroundGradient,
      in: glyphsToShow) { value, range, _ in
      guard let inlineGradient = value as? InlineGradient,
            let colors = inlineGradient.colors else { return } // Skip if no relevant
        
      let rangeRect = self.boundingRect(forGlyphRange: range, in: textContainer)
      inlineGradient.frame = rangeRect
      // Render cached gradient if available
      if let cachedGradient = cache.object(forKey: inlineGradient) {
        textStorage.addAttribute(NSAttributedString.Key.foregroundColor, value: cachedGradient, range: range)
        return
      }
      
      // Convert UIColor objects to CGColor objects
      let glColors: [CGColor] = colors.map { $0.cgColor }
    
      // Create a gradient layer for the bounding rect
      let gl = CAGradientLayer(
        bounds: rangeRect,
        colors: glColors,
        locations: inlineGradient.positions ?? [],
        direction: CGFloat(truncating: inlineGradient.direction ?? 0))

      gl.contentsScale = self.scaleFactor
      let parentRect = self.boundingRect(forGlyphRange: glyphsToShow, in: textContainer).offsetBy(dx: origin.x, dy: origin.y)
      let gradient = UIColor(from: gl, in: parentRect)
      textStorage.addAttribute(NSAttributedString.Key.foregroundColor, value: gradient, range: range)

      // Cache gradient
      cache.setObject(gradient, forKey: inlineGradient, cost: MemoryLayout.size(ofValue: gradient))
    }
    
    textStorage.endEditing()
  }
}

