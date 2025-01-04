//
//  UIColor+init.swift
//  MaskableText
//
//  Gabriel Duraye
//

extension UIColor {
  static func cssString(from color: UIColor) -> String {
    var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    color.getRed(&r, green: &g, blue: &b, alpha: &a)
    return "rgba(\(Int(r * 255)), \(Int(g * 255)), \(Int(b * 255)), \(a))"
  }
  
  /// Creates a color object from a gradient layer and bounds
  /// - Parameter gradientLayer: The gradient layer to be rendered as a color
  /// - Parameter bounds: The frame in which `gradientLayer` will be rendered
  public convenience init(_ gradientLayer: CAGradientLayer, bounds: CGRect) {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
    let image: UIImage = renderer.image { (ctx: UIGraphicsImageRendererContext) in
      ctx.cgContext.setPatternPhase(bounds.size)
      gradientLayer.render(in: ctx.cgContext)
    }
    self.init(patternImage: image)
  }
}
