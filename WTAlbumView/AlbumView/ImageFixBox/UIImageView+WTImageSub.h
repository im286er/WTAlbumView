//
//  UIImageView+WTImageSub.h
//  WisdomGarden
//
//  Created by vaexiin on 2017/4/6.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (WTImageSub)

/**
 图片压缩 (image地址)
 */
- (void)setImageSubWithURLStr:(NSString* )urlStr toSize:(CGSize)size placeHolderImage:(UIImage* )placeHolderImage;
/**
 图片压缩 (image地址)
 completion完成回调
 */
- (void)setImageSubWithURLStr:(NSString* )urlStr toSize:(CGSize)size placeHolderImage:(UIImage* )placeHolderImage completion:(void(^)(UIImage* image))completion;


/**
 图片压缩 (image)
 keyStr 可用来解决复用问题
 */
- (void)setImageSubWithImage:(id )image toSize:(CGSize)size placeHolderImage:(UIImage* )placeHolderImage;
/**
 图片压缩 (image)
 keyStr 可用来解决复用问题
 completion完成回调
 */
- (void)setImageSubWithImage:(id )image toSize:(CGSize)size placeHolderImage:(UIImage* )placeHolderImage completion:(void(^)(UIImage* image))completion;



/**
 取消方法
 */
- (void)cancelAll;

@end
