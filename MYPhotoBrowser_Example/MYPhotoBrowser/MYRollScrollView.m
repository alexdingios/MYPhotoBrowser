//
//  MYRollScrollView.m
//  MYPhotoBrowser_Example
//
//  Created by 孟遥 on 2017/2/22.
//  Copyright © 2017年 孟遥. All rights reserved.
//

#import "MYRollScrollView.h"
#import "MYZoomScrollView.h"

@interface MYRollScrollView ()<UIScrollViewDelegate>

@property (nonatomic, copy) scrollInfoCallBack callback;

@end

@implementation MYRollScrollView

- (NSMutableArray *)zoomViews
{
    if (!_zoomViews) {
        _zoomViews = [NSMutableArray array];
    }
    return _zoomViews;
}

- (instancetype)initWithFrame:(CGRect)frame callBack:(scrollInfoCallBack)callback
{
    if (self =[super initWithFrame:frame]) {
        
        self.pagingEnabled                  = YES;
        self.delegate                       = self;
        self.showsVerticalScrollIndicator   = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.callback                       = callback;
        self.backgroundColor                = [UIColor clearColor];
    }
    return self;
}


//回调页码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentPage = (scrollView.contentOffset.x + 0.5 *kScreen_with) / kScreen_with;
    if (self.callback) {
        self.callback(currentPage);
    }
}
@end
