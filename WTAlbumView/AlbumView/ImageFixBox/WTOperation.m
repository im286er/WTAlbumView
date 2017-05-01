//
//  WTOperation.m
//  WisdomGarden
//
//  Created by vaexiin on 2017/4/18.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import "WTOperation.h"
#import <SDImageCache.h>
#import "UIImage+SubImage.h"

@interface WTOperation (){
    BOOL executing;  // 执行中
    BOOL finished;   // 已完成
}

@property (nonatomic,assign)CGSize size;
@property (nonatomic,copy)NSString* url;

@property (nonatomic,copy)id image;

@property (nonatomic,copy)CompletionBlock completion;

@end

@implementation WTOperation

#pragma mark - 初始化
- (instancetype)init;
{
    self = [super init];
    if (self)
    {
        executing = NO;
        finished = NO;
    }
    return self;
}
- (void)dealloc;
{
    ;
}

#pragma mark - start
- (void)start;
{
    if ([self isCancelled])
    {
        //结束
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    //开始
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}
#pragma mark - main
- (void)main;
{
    @try {
        // 必须为自定义的 operation 提供 autorelease pool，因为 operation 完成后需要销毁。
        @autoreleasepool
        {
            if (self.image)
            {
                UIImage* subImage = nil;
                if ([self.image isKindOfClass:[NSString class]])
                {
                    subImage = [[UIImage imageNamed:self.image] scaleImageToSize:self.size];
                    [self saveImage:subImage forKey:[NSString stringWithFormat:@"WTImageSub%@%@",self.image,NSStringFromCGSize(self.size)]];
                }
                else
                {
                    subImage = [self.image scaleImageToSize:self.size];
                }
                if (self.cancelled) [self completeOperation:nil]; //返回结束
                else
                {
                    [self completeOperation:subImage];
                }
            }
            else
            {
                //创建唯一标识符
                NSString* identifierStr = [NSString stringWithFormat:@"WTImageSub%@%@",self.url,NSStringFromCGSize(self.size)];
                if (self.cancelled) [self completeOperation:nil]; //返回结束
                //下载数据
                else
                {
                    //下载新数据
                    NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.url]];
                    [self saveImageData:imageData forKey:self.url];
                    if (self.cancelled) [self completeOperation:nil];
                    else if (imageData)
                    {
                        UIImage* oldImage = [UIImage imageWithData:imageData];
                        double imageLength = imageData.length/1024.0;
                        UIImage* newImage = nil;
                        if (imageLength > 150)
                        {
                            if (self.cancelled) [self completeOperation:nil];
                            NSData* newImageData = UIImageJPEGRepresentation(oldImage, 150/imageLength);
                            if (self.cancelled) [self completeOperation:nil];
                            newImage = [UIImage imageWithData:newImageData];
                        }
                        else
                        {
                            newImage = oldImage;
                        }
                        if (self.cancelled) [self completeOperation:nil];
                        else
                        {
                            if (self.cancelled) [self completeOperation:nil];
                            else
                            {
                                UIImage* subImage = [newImage scaleImageToSize:self.size];
                                [self saveImage:subImage forKey:identifierStr];
                                [self completeOperation:subImage];
                            }
                        }
                    }
                    else [self completeOperation:nil];
                }
            }
        }
    }
    @catch (NSException* e)
    {
        NSLog(@"Exception %@", e);
    }
}
#pragma mark - 结束
- (void)completeOperation:(UIImage* )subImage;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self willChangeValueForKey:@"isFinished"];
        [self willChangeValueForKey:@"isExecuting"];
        executing = NO;
        finished = YES;
        [self didChangeValueForKey:@"isExecuting"];
        [self didChangeValueForKey:@"isFinished"];
        
        if (_completion && subImage && !self.cancelled)
        {
            _completion(subImage);
        }
    });
}
#pragma mark - 状态值
- (BOOL)isAsynchronous;
{
    return YES;
}
- (BOOL)isExecuting;
{
    return executing;
}
- (BOOL)isFinished;
{
    return finished;
}
#pragma mark - 执行操作
- (BOOL)startSubImageWithUrl:(NSString* )urlStr size:(CGSize)size completion:(CompletionBlock )completionBlock
{
    if (self.isReady && !self.isCancelled)
    {
        self.url = urlStr;
        self.size = size;
        self.image = nil;
        _completion = completionBlock;
        //开始
        [self start];
        //判断缓存数据
        __weak typeof(self) weakSelf = self;
        SDImageCache* cache = [SDImageCache sharedImageCache];
        [cache queryCacheOperationForKey:[NSString stringWithFormat:@"WTImageSub%@%@",self.url,NSStringFromCGSize(self.size)] done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
            if (image && weakSelf.completion && !self.cancelled)
            {
                [weakSelf cancel];
                weakSelf.completion(image);
            }
        }];
        return YES;
    }
    else if (self.isCancelled)
    {
        [self willChangeValueForKey:@"isFinished"];
        [self willChangeValueForKey:@"isExecuting"];
        executing = NO;
        finished = YES;
        [self didChangeValueForKey:@"isExecuting"];
        [self didChangeValueForKey:@"isFinished"];
        _completion = nil;
        return YES;
    }
    else
    {
        _completion = nil;
        return NO;
    }
}
- (BOOL)startSubImageWithImage:(id )image size:(CGSize)size completion:(CompletionBlock )completionBlock;
{
    if (self.isReady && !self.isCancelled)
    {
        self.image = image;
        self.size = size;
        self.url = nil;
        _completion = completionBlock;
        //开始
        [self start];
        if ([image isKindOfClass:[NSString class]])
        {
            //判断缓存数据
            __weak typeof(self) weakSelf = self;
            SDImageCache* cache = [SDImageCache sharedImageCache];
            [cache queryCacheOperationForKey:[NSString stringWithFormat:@"WTImageSub%@%@",self.image,NSStringFromCGSize(self.size)] done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
                if (image && weakSelf.completion && !self.cancelled)
                {
                    [weakSelf cancel];
                    weakSelf.completion(image);
                }
            }];
        }
        return YES;
    }
    else if (self.isCancelled)
    {
        [self willChangeValueForKey:@"isFinished"];
        [self willChangeValueForKey:@"isExecuting"];
        executing = NO;
        finished = YES;
        [self didChangeValueForKey:@"isExecuting"];
        [self didChangeValueForKey:@"isFinished"];
        _completion = nil;
        return YES;
    }
    else
    {
        _completion = nil;
        return NO;
    }
}

- (void)saveImage:(UIImage* )image forKey:(NSString* )keyStr;
{
    SDImageCache* cache = [SDImageCache sharedImageCache];
    [cache storeImage:image forKey:keyStr completion:nil];
}
- (void)saveImageData:(NSData* )imageData forKey:(NSString* )keyStr;
{
    SDImageCache* cache = [SDImageCache sharedImageCache];
    dispatch_queue_t queue = [cache valueForKey:@"ioQueue"];
    if (queue)
    {
        dispatch_async(queue, ^{
            [cache storeImageDataToDisk:imageData forKey:keyStr];
        });
    }
    else
    {
        [cache storeImageDataToDisk:imageData forKey:keyStr];
    }
}

@end
