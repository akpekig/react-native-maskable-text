//
//  UIColor+init.swift
//  MaskableText
//
//  Gabriel Duraye
//

extension UIColor {
  /// Creates a color object from a  layer and bounds
  /// - Parameter layer: The layer to be rendered as a color
  /// - Parameter bounds: The bounds in which `layer` will be rendered
  public convenience init(from layer: CALayer, in bounds: CGRect) {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
    let image: UIImage = renderer.image { (ctx: UIGraphicsImageRendererContext) in
      layer.render(in: ctx.cgContext)
    }
    self.init(patternImage: image)
  }
}
