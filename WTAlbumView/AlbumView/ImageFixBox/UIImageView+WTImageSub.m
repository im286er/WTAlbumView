//
//  UIImageView+WTImageSub.m
//  WisdomGarden
//
//  Created by vaexiin on 2017/4/6.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import "UIImageView+WTImageSub.h"
#import <objc/runtime.h>
#import "WTOperation.h"

static const char* keyStr = "identifierStr";

@interface UIImageView ()

@property (nonatomic,strong)WTOperation* operation; //请求

@end

@implementation UIImageView (WTImageSub)

#pragma mark - 图片压缩 (image地址)
/**
 图片压缩
 */
- (void)setImageSubWithURLStr:(NSString* )urlStr toSize:(CGSize)size placeHolderImage:(UIImage* )placeHolderImage;
{
    [self setImageSubWithURLStr:urlStr toSize:size placeHolderImage:placeHolderImage  completion:nil];
}
/**
 图片压缩
 completion完成回调
 */
- (void)setImageSubWithURLStr:(NSString* )urlStr toSize:(CGSize)size placeHolderImage:(UIImage* )placeHolderImage completion:(void(^)(UIImage* image))completion;
{
    //判段数据类型
    NSAssert([urlStr isKindOfClass:[NSString class]], @"地址类型不正确");
    //设置默认数据
    self.image = [placeHolderImage isKindOfClass:[UIImage class]]?placeHolderImage:nil; //设置默认图
    __weak typeof(self) weakSelf = self;
    //结束上一个
    [self.operation cancel];
    self.operation = [WTOperation new];
    [self.operation startSubImageWithUrl:urlStr size:size completion:^(UIImage *image) {
        if (image)
        {
            weakSelf.image = image;
        }
        if (completion)
        {
            completion(image);
        }
    }];
}
#pragma mark - 图片压缩 (image)
/**
 图片压缩 (image)
 */
- (void)setImageSubWithImage:(id )image toSize:(CGSize)size placeHolderImage:(UIImage* )placeHolderImage;
{
    [self setImageSubWithImage:image toSize:size placeHolderImage:placeHolderImage completion:nil];
}
/**
 图片压缩 (image)
 completion完成回调
 */
- (void)setImageSubWithImage:(id )image toSize:(CGSize)size placeHolderImage:(UIImage* )placeHolderImage completion:(void(^)(UIImage* image))completion;
{
    //判段数据类型
    NSAssert([image isKindOfClass:[NSString class]]||[image isKindOfClass:[UIImage class]], @"image必须为 NSString或UIImage ！");
    
    self.image = [placeHolderImage isKindOfClass:[UIImage class]]?placeHolderImage:nil; //设置默认图
    //开始
    //分线程裁剪
    __weak typeof(self) weakSelf = self;
    [self.operation cancel];
    self.operation = [WTOperation new];
    [self.operation startSubImageWithImage:image size:size completion:^(UIImage *image) {
        if (image)
        {
            weakSelf.image = image;
        }
        if (completion)
        {
            completion(image);
        }
    }];
}
#pragma mark - identifierStr
//set operation
- (void)setOperation:(WTOperation *)operation;
{
    objc_setAssociatedObject(self, keyStr, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//get operation
- (WTOperation* )operation;
{
    WTOperation* operation = objc_getAssociatedObject(self, keyStr);
    return operation;
}


#pragma mark - cancel
- (void)cancelAll;
{
    [self.operation cancel];
}

@end
