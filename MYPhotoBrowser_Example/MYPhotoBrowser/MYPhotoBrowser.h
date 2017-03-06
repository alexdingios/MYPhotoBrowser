//
//  MYPhotoBrowser.h
//  MYPhotoBrowser_Example
//
//  Created by 孟遥 on 2017/2/22.
//  Copyright © 2017年 孟遥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYZoomScrollView.h"

@interface MYPhotoBrowser : UIView

/*
  注意 ： imageViews数组的作用在于实现效果 ，从哪张图片点击，就从哪张图片位置放大效果，缩小亦是如此 。 如果不传imageViews数组 ， 效果则是 默认从屏幕中间开始放大，缩小效果也是回到屏幕中间 。为了效果更好，建议传入imageViews数组 。 callback会回调出照片长按操作的一些信息 ， 比如图片对象 ， 操作的类型（保存，发送给好友）
*/

/**
 初始化
 
 @param urlString  url字符串
 @param imageName  占位图名
 @param currentIdx 当前索引
 @param imageViews imageViews数组
 @return <#return value description#>
 */
- (instancetype)initWithUrls:(NSArray<NSString *> *)urlString imgViews:(NSArray *)imageViews placeholder:(NSString *)imageName currentIdx:(NSInteger)currentIdx handleNames:(NSArray *)names callback:(longpressCallback)callback;


/**
 是否需要动画
 
 @param animation <#animation description#>
 */
- (void)showWithAnimation:(BOOL)animation;
/**
 默认为原点指示器
 */
@property (nonatomic, assign) MYPageIndicatorStyle controlStyle;


/**
 如果需要附带描述文本 , 直接赋值即可
 */
@property (nonatomic, copy) NSString *descText;

@end
