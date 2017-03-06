//
//  MYZoomScrollView.h
//  MYPhotoBrowser_Example
//
//  Created by 孟遥 on 2017/2/22.
//  Copyright © 2017年 孟遥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYImageInfo.h"
#import "UIImage+imageSize.h"
#import "UIImageView+WebCache.h"

@interface MYZoomScrollView : UIScrollView

@property (nonatomic, strong) MYImageInfo *imageModel;
@property (nonatomic, strong) UIImageView *currentImgView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign,getter=isNeedAnimation) BOOL animation;
@property (nonatomic, strong) NSArray *handleNames;

@end
