//
//  TextScrollVC.m
//  WTAlbumView
//
//  Created by vaexiin on 2017/4/30.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import "TextScrollVC.h"
#import "WTAlbumView.h"

@interface TextScrollVC ()

@end

@implementation TextScrollVC

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"文字轮播";
    self.view.backgroundColor = [UIColor whiteColor];
    
    WTAlbumView* albumView = [WTAlbumView new];
    [self.view addSubview:albumView];
    albumView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 40);
    albumView.dataArr = @[@"文字1",@"文字2",@"文字3"];
    albumView.type = WTAlbumViewTypeTextOnly;
    albumView.scrollDirection = UICollectionViewScrollDirectionVertical;
}

@end
