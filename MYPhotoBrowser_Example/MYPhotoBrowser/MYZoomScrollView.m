//
//  MYZoomScrollView.m
//  MYPhotoBrowser_Example
//
//  Created by 孟遥 on 2017/2/22.
//  Copyright © 2017年 孟遥. All rights reserved.
//

#import "MYZoomScrollView.h"
#import "MYAnimationHelper.h"
#import "MYBottomMenuTool.h"

@interface MYZoomScrollView ()<UIScrollViewDelegate>

//单击手势
@property (nonatomic, strong) UITapGestureRecognizer *tap;
//双击手势
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
//捏合手势
@property (nonatomic, strong) UIPinchGestureRecognizer *pin;
//长按手势
@property (nonatomic, strong) UILongPressGestureRecognizer *longpress;
//长按回调
@property (nonatomic, copy) longpressCallback callback;

@end

@implementation MYZoomScrollView

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView                        = [[UIImageView alloc]init];
        _imageView.contentMode            = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor        = [UIColor clearColor];
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:self.pin];
        [_imageView addGestureRecognizer:self.doubleTap];
        [_imageView addGestureRecognizer:self.longpress];
    }
    return _imageView;
}

//单击手势
- (UITapGestureRecognizer *)tap
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(browserDismiss:)];
        [_tap requireGestureRecognizerToFail:self.doubleTap];
    }
    return _tap;
}

//双击手势
- (UITapGestureRecognizer *)doubleTap
{
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageZoomClick:)];
        _doubleTap.numberOfTapsRequired = 2;
    }
    return _doubleTap;
}

//捏合手势
- (UIPinchGestureRecognizer *)pin
{
    if (!_pin) {
        _pin = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(imageZoomOperation:)];
    }
    return _pin;
}

//长按手势
- (UILongPressGestureRecognizer *)longpress
{
    if (!_longpress) {
        _longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpressHandle)];
    }
    return _longpress;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.minimumZoomScale               = 1.f;
        self.bouncesZoom                    = YES;
        self.delegate                       = self;
        self.backgroundColor                = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator   = NO;
        [self addGestureRecognizer:self.tap];
        
        [self addSubview:self.imageView];
    }
    return self;
}


#pragma  mark - 双击放大
- (void)imageZoomClick:(UITapGestureRecognizer *)tap
{
    
    //缩小
    if (self.zoomScale >1.f) {
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self setZoomScale:1.f animated:YES];
        
        //放大
    }else{
        
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        CGPoint touchPoint         = [tap locationInView:tap.view];
        CGRect rect                = [self zoomImageWithTouchPoint:touchPoint AndScale:self.imageModel.k_scale];
        [self zoomToRect:rect animated:YES];
    }
}


//从点击点放大
- (CGRect)zoomImageWithTouchPoint:(CGPoint)Point AndScale:(CGFloat)scale
{
    CGRect zoomRect = CGRectZero;
    zoomRect.size.width  = CGRectGetWidth(self.frame) / scale;
    zoomRect.size.height = CGRectGetHeight(self.frame) / scale;
    zoomRect.origin.x    = Point.x - zoomRect.size.width / 2.0;
    zoomRect.origin.y    = Point.y - zoomRect.size.height / 2.0;
    
    return zoomRect;
}


#pragma  mark - 代理方法
//需要放大的控件   imageView
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    CGSize boundsSize  = scrollView.bounds.size;
    CGSize contentSize = scrollView.contentSize;
    CGPoint imgCenter  = CGPointMake(contentSize.width / 2.0, contentSize.height / 2.0);
    
    if (contentSize.width < boundsSize.width) {
        imgCenter.x = boundsSize.width / 2.0;
    }
    
    if (contentSize.height < boundsSize.height) {
        imgCenter.y = boundsSize.height / 2.0;
    }
    
    self.imageView.center = imgCenter;
}


#pragma mark - 捏合缩放
- (void)imageZoomOperation:(UIPinchGestureRecognizer *)pin
{
    switch (pin.state) {
            
        case UIGestureRecognizerStateChanged:
            
            self.imageView.transform = CGAffineTransformMakeScale(pin.scale, pin.scale);
            break;
        case UIGestureRecognizerStateEnded:
            
            self.imageView.transform = CGAffineTransformIdentity;
            
            break;
        default:
            break;
    }
}

#pragma mark - 长按
- (void)longpressHandle
{
    [MYBottomMenuTool show:^(NSString *handleType) {
        
        if (self.callback) {
            
            self.callback(self.imageView.image,handleType);
        }
    } handleNames:self.handleNames];
}



#pragma  mark - --- 调整imageView
- (void)setImageModel:(MYImageInfo *)imageModel
{
    
    _imageModel = imageModel;
    _callback   = imageModel.callback;
    
    if (!imageModel.urlString.length) return;
    
#pragma mark - 处理计算图片大小失误状态
    //最大缩放比例
    if (!imageModel.k_scale) {
        imageModel.k_scale = 2.0;
    }
    self.maximumZoomScale    = imageModel.k_scale;
    
    NSURL   *url             = [NSURL URLWithString:imageModel.urlString];
    UIImage *image           = [UIImage imageNamed:imageModel.placeholderName];
    
    [self.imageView sd_setImageWithURL:url placeholderImage:image options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
        NSLog(@"------------------------正在加载图片---------------------");
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"----------%@---------",self.imageView);
    }];
}


//browser消失
- (void)browserDismiss:(UITapGestureRecognizer *)tap
{
    [self setZoomScale:1.f animated:NO];
    if (self.animation) {
        [[MYAnimationHelper shareInstance]coreAnimationWithAnimationView:self.imageView relativeView:self.currentImgView style:MYRemoveAnimation finished:^{
        }];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.superview.superview removeFromSuperview];
    });
}



@end
