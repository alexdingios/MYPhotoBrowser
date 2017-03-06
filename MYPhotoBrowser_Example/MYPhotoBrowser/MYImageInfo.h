//
//  MYImageInfo.h
//  MYPhotoBrowser_Example
//
//  Created by 孟遥 on 2017/2/22.
//  Copyright © 2017年 孟遥. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef  kScreen_with
#define kScreen_with  [UIScreen mainScreen].bounds.size.width

#ifndef  kScreen_height
#define kScreen_height [UIScreen mainScreen].bounds.size.height

#ifndef  kScreen_bounds
#define kScreen_bounds [UIScreen mainScreen].bounds

#endif
#endif
#endif

typedef NS_ENUM(NSInteger) {
    
    MYPageIndicatorStylePageControl  = 1<<0,
    MYPageIndicatorStyleText         = 1<<1
    
}MYPageIndicatorStyle;

typedef void(^handleBlock)(NSString *handleType);
typedef void(^longpressCallback)(UIImage *handleImage,NSString *handleType);

@interface MYImageInfo : NSObject

@property (nonatomic, strong) NSString *urlString;

@property (nonatomic, strong) NSString *placeholderName;

//是否需要描述文本
@property (nonatomic, assign) BOOL isNeedText;
//缩放比例
@property (nonatomic, assign) CGFloat k_scale;
//图片实际大小
@property (nonatomic, assign) CGSize imageActualSize;
//长按
@property (nonatomic, copy) longpressCallback callback;

@end
