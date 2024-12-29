//
//  UIColor+init.swift
//  MaskableText
//
//  Gabriel Duraye
//

extension UIColor {  
  /// Creates a color object from a gradient layer and bounds
  /// - Parameter bounds: The frame in which `gradientLayer` will be rendered
  /// - Parameter gradientLayer: The gradient layer to be rendered as a color
  public convenience init(bounds: CGRect, gradientLayer: CAGradientLayer) {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
    let image = renderer.image { (ctx: UIGraphicsImageRendererContext) in
      gradientLayer.render(in: ctx.cgContext)
    }
    self.init(patternImage: image)
  }
}
