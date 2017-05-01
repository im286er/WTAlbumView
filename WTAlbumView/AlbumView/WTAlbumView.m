//
//  WTAlbumView.m
//
//  Created by vaexiin on 2017/4/25.
//  Copyright © 2017年 Sean. All rights reserved.
//

#import "WTAlbumView.h"
#import "UIImageView+WTImageSub.h"
#import <UIImageView+WebCache.h>

#import "WTAlbumViewCell.h"

#define WKSelf(self) ({__weak typeof(self) weakSelf = self;(weakSelf);})

static NSString* const cellId = @"WTAlbumViewCell";

@interface WTAlbumView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionViewFlowLayout* _layout;
    UICollectionView* _collection;
    UIPageControl* _pageControl;
    
    NSMutableArray* _scrollDataArr; //轮播数组
    
    NSTimer* _timer; //计时器
}

@end

@implementation WTAlbumView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self shareData];
    }
    return self;
}
- (void)awakeFromNib;
{
    [super awakeFromNib];
    [self shareData];
}
- (void)shareData;
{
    //设置默认数据
    _type = WTAlbumViewTypeNormal;
    _dataArr = @[];
    _scrollDataArr = [NSMutableArray arrayWithCapacity:0];
    _scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _autoScroll = YES;
    _autoScrollTimeInterval = 3.0f;
    _autoSubImage = YES;
    _placeholderImage = nil;
    _showPageControl = YES;
    _titleLabelTextColor = [UIColor blackColor];
    _titleLabelTextFont = [UIFont systemFontOfSize:15];
    _titleLabelBackgroundColor = [UIColor whiteColor];
    
    //布局
    _layout = [UICollectionViewFlowLayout new];
    _layout.scrollDirection = _scrollDirection;
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = 0;
    _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.backgroundColor = [UIColor whiteColor];
    _collection.pagingEnabled = YES;
    _collection.showsHorizontalScrollIndicator = NO;
    _collection.showsVerticalScrollIndicator = NO;
    [_collection registerClass:[WTAlbumViewCell class] forCellWithReuseIdentifier:cellId];
    [self addSubview:_collection];
    
    _pageControl = [UIPageControl new];
    _pageControl.hidesForSinglePage = YES;
    _pageControl.userInteractionEnabled = NO;
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self addSubview:_pageControl];
}
- (void)layoutSubviews;
{
    [super layoutSubviews];
    _layout.itemSize = self.bounds.size;
    _collection.frame = self.bounds;
    _pageControl.frame = CGRectMake(0, self.bounds.size.height>15?self.bounds.size.height-15:0, self.bounds.size.width, self.bounds.size.height>15?10:0);
    [_collection reloadData];
    if (_dataArr.count < 2)
    {
        [_collection setContentOffset:CGPointZero animated:NO];
    }
    else
    {
        [_collection setContentOffset:_scrollDirection==UICollectionViewScrollDirectionHorizontal?CGPointMake(_layout.itemSize.width, 0):CGPointMake(0,_layout.itemSize.height) animated:NO];
    }
}
#pragma mark - timer
- (void)willMoveToSuperview:(UIView *)newSuperview;
{
    if (!newSuperview)
    {
        [self deleteTimer];
    }
}
- (void)createTimer;
{
    if (_autoScroll)
    {
        if (_timer)
        {
            [self deleteTimer];
        }
        //创建计时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollTimeInterval target:self selector:@selector(scroll) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}
- (void)deleteTimer;
{
    if (_timer)
    {
        //移除计时器
        [_timer invalidate];
        _timer = nil;
    }
}
#pragma mark  scroll
- (void)scroll;
{
    if (_dataArr.count < 2)
    {
        return;
    }
    int scrollIndex = _scrollDirection==UICollectionViewScrollDirectionHorizontal?_collection.contentOffset.x/_layout.itemSize.width:_collection.contentOffset.y/_layout.itemSize.height;
    [_collection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:scrollIndex+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
#pragma mark - set
- (void)setDataArr:(NSArray<NSString *> *)dataArr;
{
    //添加数据
    [_scrollDataArr removeAllObjects];
    if (dataArr.count == 1)
    {
        [_scrollDataArr addObjectsFromArray:dataArr];
    }
    else if (dataArr.count > 1)
    {
        [_scrollDataArr addObject:[dataArr lastObject]];
        [_scrollDataArr addObjectsFromArray:dataArr];
        [_scrollDataArr addObject:[dataArr firstObject]];
    }
    _pageControl.numberOfPages = dataArr.count;
    //刷新界面
    [_collection reloadData];
    if (dataArr.count < 2)
    {
        [_collection setContentOffset:CGPointZero animated:NO];
        _pageControl.currentPage = 0;
        [self deleteTimer];
    }
    else
    {
        if (_dataArr.count < dataArr.count)
        {
            [_collection setContentOffset:_scrollDirection==UICollectionViewScrollDirectionHorizontal?CGPointMake(_layout.itemSize.width, 0):CGPointMake(0,_layout.itemSize.height) animated:NO];
        }
        [self createTimer];
    }
    _dataArr = dataArr.copy;
}
- (void)setType:(WTAlbumViewType)type;
{
    _type = type;
    [_collection reloadData];
    _pageControl.alpha = _showPageControl&&_type!=WTAlbumViewTypeTextOnly;
}
- (void)setAutoScroll:(BOOL)autoScroll;
{
    _autoScroll = autoScroll;
    if (autoScroll)
    {
        [self createTimer];
    }
    else
    {
        [self deleteTimer];
    }
}
- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval;
{
    if (_autoScrollTimeInterval != autoScrollTimeInterval && _autoScroll)
    {
        _autoScrollTimeInterval = autoScrollTimeInterval;
        [self createTimer];
    }
}
- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection;
{
    _scrollDirection = scrollDirection;
    _layout.scrollDirection = _scrollDirection;
}
- (void)setShowPageControl:(BOOL)showPageControl;
{
    _showPageControl = showPageControl;
    _pageControl.alpha = _showPageControl&&_type!=WTAlbumViewTypeTextOnly;
}
#pragma mark - 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return _scrollDataArr.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return 1;
}
- (__kindof UICollectionViewCell* )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(WTAlbumViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (_type == WTAlbumViewTypeTextOnly)
    {
        cell.label.textColor = _titleLabelTextColor;
        cell.label.text = _scrollDataArr[indexPath.item];
        cell.label.font = _titleLabelTextFont;
        cell.label.backgroundColor = _titleLabelBackgroundColor;
        cell.imageView.hidden = YES;
    }
    else
    {
        if(_autoSubImage)
        {
            if (_type == WTAlbumViewTypeLocal)
            {
                [cell.imageView setImageSubWithImage:_scrollDataArr[indexPath.item] toSize:_layout.itemSize placeHolderImage:_placeholderImage];
            }
            else
            {
                [cell.imageView setImageSubWithURLStr:_scrollDataArr[indexPath.item] toSize:_layout.itemSize placeHolderImage:_placeholderImage];
            }
        }
        else
        {
            if (_type == WTAlbumViewTypeLocal)
            {
                [cell.imageView cancelAll];
                cell.imageView.image = [UIImage imageNamed:_scrollDataArr[indexPath.item]];
            }
            else
            {
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_scrollDataArr[indexPath.item]] placeholderImage:_placeholderImage];
            }
        }
        cell.label.hidden = YES;
    }
}
#pragma mark 滚动事件
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //手动滑动开始
    [self deleteTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //手动滑动结束
    [self createTimer];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (_dataArr.count <= 1)
    {
        return;
    }
    CGFloat scrollFloat = _scrollDirection==UICollectionViewScrollDirectionHorizontal?(scrollView.contentOffset.x/_layout.itemSize.width):(scrollView.contentOffset.y/_layout.itemSize.height);
    int scrollIndex = scrollFloat+0.5;
    //设置pageControl
    if (scrollIndex == 0)
    {
        _pageControl.currentPage = _dataArr.count-1;
    }
    else if (scrollIndex == _scrollDataArr.count-1)
    {
        _pageControl.currentPage = 0;
    }
    else
    {
        _pageControl.currentPage = scrollIndex-1;
    }
    //极点数据判断
    if (scrollFloat <= 0)
    {
        [_collection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_scrollDataArr.count-2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    else if (scrollFloat >= _scrollDataArr.count-1)
    {
        [_collection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}
#pragma mark - 点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    //点击位置判断
    if ([_delegate respondsToSelector:@selector(albumView:didClickAtIndex:)])
    {
        if (_dataArr.count == 1)
        {
            [_delegate albumView:WKSelf(self) didClickAtIndex:0];
        }
        else if (_dataArr.count > 1)
        {
            if (indexPath.item == 0)
            {
                [_delegate albumView:WKSelf(self) didClickAtIndex:_dataArr.count-1];
            }
            else if (indexPath.item == _scrollDataArr.count-1)
            {
                [_delegate albumView:WKSelf(self) didClickAtIndex:0];
            }
            else
            {
                [_delegate albumView:WKSelf(self) didClickAtIndex:indexPath.item-1];
            }
        }
    }
}

#pragma mark - 修复滚动
- (void)fixScroll;
{
    CGFloat scrollFloat = _scrollDirection==UICollectionViewScrollDirectionHorizontal?_collection.contentOffset.x/_layout.itemSize.width:_collection.contentOffset.y/_layout.itemSize.height;
    int scrollIndex = scrollFloat+0.5;
    [_collection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:scrollIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)dealloc;
{
    ;
}

@end
