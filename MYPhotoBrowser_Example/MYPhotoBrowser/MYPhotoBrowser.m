//
//  MYPhotoBrowser.m
//  MYPhotoBrowser_Example
//
//  Created by 孟遥 on 2017/2/22.
//  Copyright © 2017年 孟遥. All rights reserved.
//

#import "MYPhotoBrowser.h"
#import "MYRollScrollView.h"
#import "MYZoomScrollView.h"
#import "MYAnimationHelper.h"

@interface MYPhotoBrowser ()

@property (nonatomic, strong) NSArray *imagesUrlString;
//占位图
@property (nonatomic, copy) NSString *placeholderName;
//用于滚动
@property (nonatomic, strong) MYRollScrollView *rollScrollView;
//pageControl
@property (nonatomic, strong) UIPageControl *pageControl;
//当前第几张模式显示
@property (nonatomic, strong) UILabel *pageLabel;
//当前页码
@property (nonatomic, assign) NSInteger currentIndex;
//文本显示tableView
@property (nonatomic, strong) UITextView *descView;
//传入imageView数组
@property (nonatomic, strong) NSArray *imageViews;
//图片操作回调
@property (nonatomic, copy) longpressCallback callback;
//是否需要动画
@property (nonatomic, assign,getter=isNeedAnimation) BOOL animation;
@end

@implementation MYPhotoBrowser

//用于滚动容器
- (MYRollScrollView *)rollScrollView
{
    if (!_rollScrollView) {
        
        __weak typeof(self) weakself    = self;
        _rollScrollView                 = [[MYRollScrollView alloc]initWithFrame:self.bounds callBack:^(NSInteger currentPage) {
            
            [weakself loadImage:currentPage];
            
            if (weakself.pageControl.hidden) {
                
                weakself.pageLabel.text = [NSString stringWithFormat:@"%li / %li",currentPage+1,_imagesUrlString.count];
            }else{
                weakself.pageControl.currentPage = currentPage;
            }
        }];
        _rollScrollView.contentSize     = CGSizeMake(kScreen_with *_imagesUrlString.count, kScreen_height);
    }
    return _rollScrollView;
}

//pageControl
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl                               = [[UIPageControl alloc]init];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor        = [UIColor grayColor];
    }
    return _pageControl;
}

//文本页码指示器
- (UILabel *)pageLabel
{
    if (!_pageLabel) {
        
        CGFloat width            = 100;
        CGFloat height           = 50;
        _pageLabel               = [[UILabel alloc]init];
        _pageLabel.font          = [UIFont systemFontOfSize:15];
        _pageLabel.textColor     = [UIColor whiteColor];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.frame         = CGRectMake((kScreen_with - width) *0.5,kScreen_height - 150, width, height);
        _pageLabel.text          = [NSString stringWithFormat:@"%li / %li",self.currentIndex+1,self.imagesUrlString.count];
    }
    return _pageLabel;
}

//描述文本view
- (UITextView *)descView
{
    if (!_descView) {
        CGFloat height = 100;
        
        _descView = [[UITextView alloc]initWithFrame:CGRectMake(0, kScreen_height - height, kScreen_with, height)];
        _descView.showsVerticalScrollIndicator   = NO;
        _descView.showsHorizontalScrollIndicator = NO;
        _descView.editable                       = NO;
        _descView.selectable                     = NO;
        _descView.textColor                      = [UIColor whiteColor];
        _descView.backgroundColor                = [UIColor clearColor];
    }
    return _descView;
}



#pragma  mark - 照片浏览初始化
- (instancetype)initWithUrls:(NSArray<NSString *> *)urlString imgViews:(NSArray *)imageViews placeholder:(NSString *)imageName currentIdx:(NSInteger)currentIdx handleNames:(NSArray *)names callback:(longpressCallback)callback
{
    
    if (!urlString.count) return nil;
    _imagesUrlString = urlString;
    _placeholderName = imageName;
    _currentIndex    = currentIdx;
    _imageViews      = imageViews;
    _callback        = callback;
    CGRect frame = CGRectMake(0, 0, kScreen_with, kScreen_height);
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor        = [UIColor colorWithWhite:0 alpha:1];
        [self addSubview:self.rollScrollView];
        [self addphotosScrollView:names];
    }
    return self;
}


//初始化子控件
- (void)addphotosScrollView:(NSArray *)handleNames
{
    
    for (NSInteger index = 0; index < self.imagesUrlString.count; index ++) {
        
        MYZoomScrollView *zooScrollView = [[MYZoomScrollView alloc]initWithFrame:CGRectMake(index *kScreen_with, 0, kScreen_with, kScreen_height)];
        zooScrollView.handleNames       = handleNames; //长按操作
        [self.rollScrollView addSubview:zooScrollView];
        [self.rollScrollView.zoomViews addObject:zooScrollView];
        //计算imageView大小
        [self imageFrame:zooScrollView index:index];
        if (!_imageViews.count) continue;
        //记录当前对应的原始imageView
        zooScrollView.currentImgView     = self.imageViews[index];
     }
    if (self.imagesUrlString.count == 1) return;
    //初始化pageControl
    [self configPageControl];
}

- (void)configPageControl
{
    CGSize controlSize             = [self.pageControl sizeForNumberOfPages:self.imagesUrlString.count];
    self.pageControl.frame         = CGRectMake((self.frame.size.width - controlSize.width) *0.5, self.frame.size.height - 100, controlSize.width, controlSize.height);
    self.pageControl.numberOfPages = self.imagesUrlString.count;
    self.pageControl.currentPage   = self.currentIndex;
    [self.rollScrollView setContentOffset:CGPointMake(kScreen_with * self.currentIndex, 0) animated:NO];
    [self addSubview:self.pageControl];
}


//配置缩放比例等信息
- (CGFloat)configZoomScaleWithImageSize:(CGSize)imageSize
{
    if (!imageSize.width ||!imageSize.height) {
        
        return 0.0;
    }
    
    CGFloat width  = imageSize.width;
    CGFloat height = imageSize.height;
    
    if (height > width) {
        
        return 2.0;
    }else{
        
        return [self fillScaleCalculate:width height:height];
    }
}

- (CGFloat)fillScaleCalculate:(CGFloat)width height:(CGFloat)height
{
    return kScreen_height/(kScreen_with / width  *height) ;
}


//设置指示器风格
- (void)setControlStyle:(MYPageIndicatorStyle)controlStyle
{
    _controlStyle = controlStyle;
    
    if (controlStyle == MYPageIndicatorStyleText &&self.imagesUrlString.count !=1) {
        
        self.pageControl.hidden = YES;
        
        [self addSubview:self.pageLabel];
    }
}


//是否显示描述文本
- (void)setDescText:(NSString *)descText
{
    _descText          = descText;
    self.descView.text = descText;
    [self addSubview:self.descView];
}



//开启照片浏览器
- (void)showWithAnimation:(BOOL)animation
{
    _animation                   = animation;
    
    [self.rollScrollView.zoomViews enumerateObjectsUsingBlock:^(MYZoomScrollView  *_Nonnull zoomView, NSUInteger idx, BOOL * _Nonnull stop) {
        zoomView.animation       = animation;
    }];
    UIWindow *keyWindow          = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    if (!animation) {
        [self loadImage:_currentIndex];
        return;
    }
    __weak typeof(self) weakself = self;
    //动画
    MYZoomScrollView *zoomView   = self.rollScrollView.zoomViews[_currentIndex];
    [[MYAnimationHelper shareInstance]coreAnimationWithAnimationView:zoomView.imageView relativeView:self.imageViews[self.currentIndex] style:MYShowAnimation finished:^{
        
        [weakself loadImage:self.currentIndex];
    }];
}

- (void)loadImage:(NSInteger )idx
{
        NSString *imageUrlString         = self.imagesUrlString[idx];
        NSURL *url                       = [NSURL URLWithString:imageUrlString];
        CGSize imageActualSize           = [UIImage getImageSizeWithURL:url];
        MYImageInfo *imageModel          = [[MYImageInfo alloc]init];
        imageModel.urlString             = imageUrlString;
        imageModel.placeholderName       = self.placeholderName;
        imageModel.imageActualSize       = imageActualSize;
        imageModel.callback              = _callback;
        imageModel.k_scale               = [self configZoomScaleWithImageSize:imageActualSize];
        MYZoomScrollView *zoomScrollView = self.rollScrollView.zoomViews[idx];
        zoomScrollView.imageModel        = imageModel;
}

- (void)imageFrame:(MYZoomScrollView *)zooScrollView index:(NSInteger)index
{
    NSURL *url = [NSURL URLWithString:self.imagesUrlString[index]];
    CGSize imageActualSize           = [UIImage getImageSizeWithURL:url];
    CGFloat width                    = imageActualSize.width;
    CGFloat height                   = imageActualSize.height;
    if (width || height) {
        imageActualSize              = [UIScreen mainScreen].bounds.size;
    }
    if (width >= height) {
        
        CGFloat showHeight   = kScreen_with/width * height;
        zooScrollView.imageView.frame = CGRectMake(0,(self.frame.size.height - showHeight) *0.5, self.frame.size.width,showHeight);
    }else{
        zooScrollView.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    
    if (!_imageViews.count) {
        [self loadImage:0 ];
        return;
    }
    UIImageView *currentImageView     = _imageViews[index];
    zooScrollView.imageView.image     = currentImageView.image;
}



@end
