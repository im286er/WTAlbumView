
#import <UIKit/UIKit.h>

@interface UIImage (SubImage)

/**
 截取当前image对象rect区域内的图像 
 */
- (UIImage *)subImageWithRect:(CGRect)rect;

/** 
 等比例压缩图片至指定尺寸
 */
- (UIImage *)scaleImageToSize:(CGSize)size;

/** 
 根据颜色生成纯色图片 
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
