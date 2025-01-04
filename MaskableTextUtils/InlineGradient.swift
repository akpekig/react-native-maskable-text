//
//  InlineGradient.swift
//  MaskableText
//
//  Gabriel Duraye
//

class InlineGradient: NSObject {
  var colors: [UIColor]?
  var direction: NSNumber?
  var positions: [NSNumber]?
  var frame: CGRect?
  
  init(colors: [UIColor]? = nil, direction: NSNumber? = nil, positions: [NSNumber]? = nil, frame: CGRect? = nil) {
    self.colors = colors
    self.direction = direction
    self.positions = positions
    self.frame = frame
  }
  
  override var hash: Int {
    var hasher = Hasher()
    
    hasher.combine(colors)
    hasher.combine(direction)
    hasher.combine(positions)
    
    if #available(iOS 18.0, *) {
      hasher.combine(frame)
    } else {
      hasher.combine(frame?.minX)
      hasher.combine(frame?.minY)
      hasher.combine(frame?.midX)
      hasher.combine(frame?.midY)
      hasher.combine(frame?.maxX)
      hasher.combine(frame?.maxY)
      hasher.combine(frame?.width)
      hasher.combine(frame?.height)
      hasher.combine(frame?.origin.x)
      hasher.combine(frame?.origin.y)
    }
    
    return hasher.finalize()
  }
  
  static func == (lhs: InlineGradient, rhs: InlineGradient) -> Bool {
    lhs.colors == rhs.colors
    && lhs.direction == rhs.direction
    && lhs.positions == rhs.positions
    && lhs.frame == rhs.frame
  }
}
