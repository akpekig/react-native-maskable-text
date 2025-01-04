//
//  MaskableTextLayoutManager.swift
//  MaskableText
//
//  Gabriel Duraye
//

class MaskableTextLayoutManager: NSLayoutManager {
  let cache: NSCache<InlineGradient, UIColor>
  
  override init() {
    self.cache = .init()
    
    self.cache.totalCostLimit = 128 * 1024 * 1024 // 128 MB
    
    super.init()
  }
  
  required init?(coder: NSCoder) {
    self.cache = .init()
    
    self.cache.totalCostLimit = 128 * 1024 * 1024 // 128 MB
    
    super.init(coder: coder)
  }
  
  override func drawGlyphs(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
    super.drawGlyphs(forGlyphRange: glyphsToShow, at: origin)
    
    guard let textStorage else { return }
    let textWithGradient = NSMutableAttributedString(attributedString: textStorage)
    
//    var ranges: [NSRange] = .init()
    
    // Render gradient attributed strings
    textStorage.enumerateAttribute(
      NSAttributedString.Key.foregroundGradient,
      in: glyphsToShow) { value, range, _ in
      guard let inlineGradient = value as? InlineGradient,
            let colors = inlineGradient.colors else { return } // Skip if no relevant values
    
      // Get frame for the glyph range
      let glFrame = self
        .boundingRect(forGlyphRange: glyphsToShow, in: textContainers.first!)
        .offsetBy(dx: origin.x, dy: origin.y)
        
        inlineGradient.frame = glFrame
        
      // Render cached gradient if available
      if let cachedGradient = cache.object(forKey: inlineGradient) {
        textWithGradient.addAttribute(NSAttributedString.Key.foregroundColor, value: cachedGradient, range: range)
        return
      }
      
      // Convert UIColor objects to CGColor objects
      let glColors: [CGColor] = colors.map { $0.cgColor }
      
      // Unwrap optional color locations
      let glLocations: [NSNumber] = inlineGradient.positions ?? []
      
      // Unwrap optional direction
      let glDirection = CGFloat(truncating: inlineGradient.direction ?? 0)
    
      // Create a gradient layer for the bounding rect
      let gl = CAGradientLayer(
        frame: glFrame,
        colors: glColors,
        locations: glLocations,
        direction: glDirection)
      
      let gradient = UIColor(gl, bounds: glFrame)
      textWithGradient.addAttribute(NSAttributedString.Key.foregroundColor, value: gradient, range: range)
      

      // Cache gradient
      let cost: Int = MemoryLayout.size(ofValue: gradient)
      cache.setObject(gradient, forKey: inlineGradient, cost: cost)
    }
    
    textStorage.beginEditing()
    textStorage.setAttributedString(textWithGradient)
    textStorage.endEditing()
  }
}

