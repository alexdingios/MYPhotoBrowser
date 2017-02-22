//
//  MYRollScrollView.h
//  MYPhotoBrowser_Example
//
//  Created by 孟遥 on 2017/2/22.
//  Copyright © 2017年 孟遥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^scrollInfoCallBack)(NSInteger currentPage);

@interface MYRollScrollView : UIScrollView

@property (nonatomic, strong) NSMutableArray *zoomViews;

- (instancetype)initWithFrame:(CGRect)frame callBack:(scrollInfoCallBack)callback;
@end
