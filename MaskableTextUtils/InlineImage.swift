//
//  InlineImage.swift
//  MaskableText
//
//  Gabriel Duraye
//

class InlineImage: NSObject {
  var source: RCTImageSource
  
  var imageLoader: RCTImageLoader
  
  /// When `image` is loaded, it will be stored here
  private lazy var _image: UIImage? = nil
  
  lazy var image: UIImage? = {
    let newValue = loadImage()
    _image = newValue
    return newValue
  }()
  
  init(source: RCTImageSource, imageLoader: RCTImageLoader) {
    self.source = source
    self.imageLoader = imageLoader
  }
  
  override var hash: Int {
    var hasher = Hasher()
    
    hasher.combine(source)
    
    return hasher.finalize()
  }
  
  static func == (lhs: InlineImage, rhs: InlineImage) -> Bool {
    lhs.source == rhs.source
  }
  
  private func loadImage() -> UIImage? {
    let group = DispatchGroup()
    var loadedImage: UIImage? = nil
    
    group.enter()
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
      self.imageLoader.loadImage(with: self.source.request) { error, reactImage in
        loadedImage = reactImage
        group.leave()
      }
    }
    
    group.wait()
    
    return loadedImage
  }
  
  public func useImage(with completion: @escaping (UIImage?) -> Void) {
    if let _image {
      completion(_image)
    } else {
      DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
        if let loadedImage = self.image {
          DispatchQueue.main.async {
            completion(loadedImage)
          }
        }
      }
    }
  }
}
