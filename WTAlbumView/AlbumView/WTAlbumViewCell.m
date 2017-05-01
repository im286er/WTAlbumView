//
//  WTAlbumViewCell.m
//  WTAlbumView
//
//  Created by vaexiin on 2017/4/25.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import "WTAlbumViewCell.h"

@implementation WTAlbumViewCell

- (instancetype)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageView = [UIImageView new];
        [self.contentView addSubview:_imageView];
        _label = [UILabel new];
        [self.contentView addSubview:_label];
    }
    return self;
}
- (void)layoutSubviews;
{
    [super layoutSubviews];
    _imageView.frame = self.contentView.bounds;
    _label.frame = self.contentView.bounds;
}

@end
