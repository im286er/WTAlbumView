//
//  OtherVC.m
//  WTAlbumView
//
//  Created by vaexiin on 2017/4/30.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import "OtherVC.h"
#import "WTAlbumView.h"

@interface OtherVC ()

@end

@implementation OtherVC

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"上下轮播";
    self.view.backgroundColor = [UIColor whiteColor];
    
    WTAlbumView* albumView = [WTAlbumView new];
    [self.view addSubview:albumView];
    albumView.frame = CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.width/2.0);
    albumView.dataArr = @[@"http://image.baidu.com/search/down?tn=download&word=download&ie=utf8&fr=detail&url=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201510%2F10%2F20151010211325_ZdA4R.jpeg&thumburl=http%3A%2F%2Fh.hiphotos.baidu.com%2Fimage%2Fh%253D200%2Fsign%3D86e60d2bd754564efa65e33983df9cde%2F38dbb6fd5266d016c696af109d2bd40735fa357e.jpg",@"http://image.baidu.com/search/down?tn=download&word=download&ie=utf8&fr=detail&url=http%3A%2F%2Fpic4.nipic.com%2F20091121%2F3764872_215617048242_2.jpg&thumburl=http%3A%2F%2Fimg1.imgtn.bdimg.com%2Fit%2Fu%3D569334953%2C1638673400%26fm%3D23%26gp%3D0.jpg",@"http://image.baidu.com/search/down?tn=download&word=download&ie=utf8&fr=detail&url=http%3A%2F%2Fpic.qiantucdn.com%2F01%2F61%2F38%2F93bOOOPIC15.jpg&thumburl=http%3A%2F%2Fimg4.imgtn.bdimg.com%2Fit%2Fu%3D659323563%2C2437967239%26fm%3D23%26gp%3D0.jpg"];
    albumView.scrollDirection = UICollectionViewScrollDirectionVertical;
}

@end
