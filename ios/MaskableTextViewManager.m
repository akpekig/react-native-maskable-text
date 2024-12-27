#import <React/RCTBaseTextViewManager.h>
#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(MaskableTextViewManager, RCTViewManager)
  RCT_REMAP_SHADOW_PROPERTY(numberOfLines, numberOfLines, NSInteger)
  RCT_REMAP_SHADOW_PROPERTY(allowsFontScaling, allowsFontScaling, BOOL)
  RCT_REMAP_SHADOW_PROPERTY(colors, gradientColors, NSArray)
  RCT_REMAP_SHADOW_PROPERTY(positions, gradientPositions, NSArray)
  RCT_REMAP_SHADOW_PROPERTY(direction, gradientDirection,NSNumber)
  RCT_REMAP_SHADOW_PROPERTY(useMarkdown, useMarkdown, BOOL)

  RCT_EXPORT_VIEW_PROPERTY(onTextLayout, RCTDirectEventBlock)
  RCT_EXPORT_VIEW_PROPERTY(ellipsizeMode, NSString)
  RCT_EXPORT_VIEW_PROPERTY(colors, NSArray)
  RCT_EXPORT_VIEW_PROPERTY(positions, NSArray)
  RCT_EXPORT_VIEW_PROPERTY(direction, NSNumber)
  RCT_EXPORT_VIEW_PROPERTY(useMarkdown, BOOL)
@end

@interface RCT_EXTERN_MODULE(MaskableTextChildViewManager, RCTBaseTextViewManager)
  RCT_REMAP_SHADOW_PROPERTY(text, text, NSString)

  RCT_EXPORT_VIEW_PROPERTY(text, NSString)
  RCT_EXPORT_VIEW_PROPERTY(onPress, RCTBubblingEventBlock)
@end
