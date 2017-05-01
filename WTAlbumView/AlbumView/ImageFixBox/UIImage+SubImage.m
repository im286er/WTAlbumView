//
//  UIImage+SubImage.m
//  UIImage+Categories
//
//  Created by lisong on 16/9/4.
//  Copyright © 2016年 lisong. All rights reserved.
//

#import "UIImage+SubImage.h"

@implementation UIImage (SubImage)

#pragma mark - 截取当前image对象rect区域内的图像
- (UIImage *)subImageWithRect:(CGRect)rect
{
    CGImageRef newImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    
    return newImage;
}

#pragma mark - 等比例压缩图片至指定尺寸
- (UIImage *)scaleImageToSize:(CGSize)size;
{
    CGSize imageSize = self.size;
    CGSize newSize = CGSizeZero;
    if (size.width/size.height == imageSize.width/imageSize.height)
    {
        return self;
    }
    else if (size.width > imageSize.width && size.height > imageSize.height)
    {
        newSize = size;
    }
    else if (size.width < imageSize.width && size.height < imageSize.height)
    {
        //取小
        if (imageSize.width < imageSize.height)
        {
            newSize.width = imageSize.width;
            newSize.height = imageSize.width*(size.height/size.width);
        }
        else
        {
            newSize.height = imageSize.height;
            newSize.width = imageSize.height*(size.width/size.height);
        }
    }
    else
    {
        if (size.width < imageSize.width)
        {
            newSize.height = imageSize.height;
            newSize.width = imageSize.height*(size.width/size.height);
        }
        else
        {
            newSize.width = imageSize.width;
            newSize.height = imageSize.width*(size.height/size.width);
        }
    }
    CGSize boxSize = CGSizeMake(MAX(newSize.width, imageSize.width), MAX(newSize.height, imageSize.height));
    //合成图片
    UIImage* bgImage = [UIImage imageWithColor:[UIColor clearColor] size:newSize];
    UIGraphicsBeginImageContext(boxSize);
    [bgImage drawInRect:CGRectMake((boxSize.width-newSize.width)/2.0, (boxSize.height-newSize.height)/2.0, newSize.width, newSize.height)];
    [self drawInRect:CGRectMake((boxSize.width-imageSize.width)/2.0, (boxSize.height-imageSize.height)/2.0, imageSize.width, imageSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect newRect = CGRectMake((boxSize.width-newSize.width)/2.0, (boxSize.height-newSize.height)/2.0, newSize.width, newSize.height);
    return [newImage subImageWithRect:newRect];
}

#pragma mark - 根据颜色生成纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
