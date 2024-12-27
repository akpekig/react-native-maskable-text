//
//  CAGradientLayer+init.swift
//  MaskableText
//
//  Gabriel Duraye
//

/// Converts an angle in degrees to start and end points for a CAGradientLayer.
/// - Parameter angle: The angle in degrees, where 0 is pointing to the right (east), 90 is pointing down (south), 180 is pointing left (west), and 270 is pointing up (north).
/// - Returns: A tuple containing `startPoint` and `endPoint` as `CGPoint`.
func gradientPoints(for angle: CGFloat) -> (startPoint: CGPoint, endPoint: CGPoint) {
    // Convert degrees to radians
    let radians = angle * .pi / 180
    
    // Calculate the x and y components based on the angle
    let x = cos(radians)
    let y = sin(radians)
    
    // Normalize to fit in the range [0, 1]
    let startX = (1 - x) / 2
    let startY = (1 - y) / 2
    let endX = (1 + x) / 2
    let endY = (1 + y) / 2
    
    return (CGPoint(x: startX, y: startY), CGPoint(x: endX, y: endY))
}

extension CAGradientLayer {
  public convenience init(
    bounds: CGRect,
    colors: [UIColor],
    locations: [NSNumber],
    direction: CGFloat
  ) {
    let cgColors: [CGColor] = colors.map { $0.cgColor }
    let gradient: CAGradientLayer = CAGradientLayer()
    let (startPoint, endPoint): (CGPoint, CGPoint) = gradientPoints(for: direction)
    gradient.frame = bounds
    gradient.colors = cgColors
    
    if (!locations.isEmpty) {
      gradient.locations = locations
    }

    gradient.startPoint = startPoint
    gradient.endPoint = endPoint
    
    self.init(layer: gradient)
  }
}
