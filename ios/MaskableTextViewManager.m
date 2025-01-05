#import <React/RCTBaseTextViewManager.h>
#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(MaskableTextViewManager, RCTViewManager)
  RCT_REMAP_SHADOW_PROPERTY(numberOfLines, numberOfLines, NSInteger)
  RCT_REMAP_SHADOW_PROPERTY(allowsFontScaling, allowsFontScaling, BOOL)
  RCT_REMAP_SHADOW_PROPERTY(gradientColors, gradientColors, NSArray<UIColor>)
  RCT_REMAP_SHADOW_PROPERTY(gradientPositions, gradientPositions, NSArray<NSNumber>)
  RCT_REMAP_SHADOW_PROPERTY(gradientDirection, gradientDirection, NSNumber)
  RCT_REMAP_SHADOW_PROPERTY(image, image, RCTImageSource)

  RCT_EXPORT_VIEW_PROPERTY(onTextLayout, RCTDirectEventBlock)
  RCT_EXPORT_VIEW_PROPERTY(ellipsizeMode, NSString)
  RCT_EXPORT_VIEW_PROPERTY(gradientColors, NSArray<UIColor>)
  RCT_EXPORT_VIEW_PROPERTY(gradientPositions, NSArray<NSNumber>)
  RCT_EXPORT_VIEW_PROPERTY(gradientDirection, NSNumber)
  RCT_EXPORT_VIEW_PROPERTY(image, RCTImageSource)
@end

@interface RCT_EXTERN_MODULE(MaskableTextChildViewManager, RCTBaseTextViewManager)
  RCT_REMAP_SHADOW_PROPERTY(padding, textAttributes.padding, YGValue)
  RCT_REMAP_SHADOW_PROPERTY(borderRadius, textAttributes.borderRadius, YGValue)

  RCT_REMAP_SHADOW_PROPERTY(text, text, NSString)

  RCT_EXPORT_SHADOW_PROPERTY(gradientColors, NSArray<UIColor>)
  RCT_EXPORT_SHADOW_PROPERTY(gradientPositions, NSArray<NSNumber>)
  RCT_EXPORT_SHADOW_PROPERTY(gradientDirection, NSNumber)
  RCT_EXPORT_SHADOW_PROPERTY(image, RCTImageSource)
  RCT_EXPORT_SHADOW_PROPERTY(useGradient, BOOL)
  RCT_EXPORT_SHADOW_PROPERTY(useImage, BOOL)
  RCT_EXPORT_SHADOW_PROPERTY(useMarkdown, BOOL)

  RCT_EXPORT_VIEW_PROPERTY(text, NSString)
  RCT_EXPORT_VIEW_PROPERTY(onPress, RCTBubblingEventBlock)
@end
