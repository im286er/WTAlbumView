# WTAlbumView
图片轮播控件，简单实用

```OC

typedef NS_ENUM(NSUInteger , WTAlbumViewType){
    WTAlbumViewTypeNormal = 0,   /* 常规图片轮播 */
    WTAlbumViewTypeLocal,         /* 本地图片轮播 */
    WTAlbumViewTypeTextOnly,     /* 文字轮播 */
};

@protocol WTAlbumViewDelegate <NSObject>

@optional
/* 图片/文字点击事件 */
- (void)albumView:(WTAlbumView* )albumView didClickAtIndex:(NSInteger)index;

@end

@interface WTAlbumView : UIView

/**
 轮播控件代理
 */
@property (nonatomic,weak) id<WTAlbumViewDelegate>delegate;
/**
 轮播类型
 */
@property (nonatomic,assign)WTAlbumViewType type;


/**
 轮播数据
 可传图片链接(NSString)、本地图片(NSString)和文字(NSString)类型的数据
 */
@property (nonatomic,copy)NSArray<NSString* >* dataArr;
/** 
 图片滚动方向，默认为水平滚动 (卡片式轮播不支持该功能)
 */
@property (nonatomic, assign)UICollectionViewScrollDirection scrollDirection;
/**
 是否自动轮播，默认为是
 */
@property (nonatomic,assign)BOOL autoScroll;
/**
 轮播时间，仅当autoScroll为YES时有效，默认为3s
 */
@property (nonatomic,assign)CGFloat autoScrollTimeInterval;



/**
 是否需要对图片进行裁剪操作，可按比例压缩裁剪，若否则平铺图片
 */
@property (nonatomic,assign)BOOL autoSubImage;
/**
 占位图
 */
@property (nonatomic,copy)UIImage* placeholderImage;
/**
 是否需要显示pageControl，默认为是
 */
@property (nonatomic,assign)BOOL showPageControl;



/** 
 轮播文字label字体颜色，默认为黑色
 */
@property (nonatomic,copy)UIColor* titleLabelTextColor;
/**
 轮播文字label字体大小，默认为15号字体
 */
@property (nonatomic,copy)UIFont* titleLabelTextFont;
/** 
 轮播文字label背景颜色
 */
@property (nonatomic,copy)UIColor* titleLabelBackgroundColor;



/**
 滚动修复 （可在使用此方法修正轮播，一般在界面 - (void)viewWillAppear:(BOOL)animated 使用）
 */
- (void)fixScroll;

```
