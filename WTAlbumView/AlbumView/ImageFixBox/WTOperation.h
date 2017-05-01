//
//  WTOperation.h
//  WisdomGarden
//
//  Created by vaexiin on 2017/4/18.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CompletionBlock)(UIImage* image);

@interface WTOperation : NSOperation

/**
 执行操作 url
 */
- (BOOL)startSubImageWithUrl:(NSString* )urlStr size:(CGSize)size completion:(CompletionBlock )completionBlock;

/**
 执行操作 image
 */
- (BOOL)startSubImageWithImage:(id )image size:(CGSize)size completion:(CompletionBlock )completionBlock;

@end
