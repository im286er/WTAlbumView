//
//  WTAlbumViewCell.h
//  WTAlbumView
//
//  Created by vaexiin on 2017/4/25.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTAlbumViewCell : UICollectionViewCell

/**
 图片
 */
@property (nonatomic,strong,readonly)UIImageView* imageView;

/**
 文字
 */
@property (nonatomic,strong,readonly)UILabel* label;

@end
