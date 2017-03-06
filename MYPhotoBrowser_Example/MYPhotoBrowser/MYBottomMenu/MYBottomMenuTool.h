//
//  MYBottomMenuTool.h
//  MYPhotoBrowser_Example
//
//  Created by 孟遥 on 2017/2/21.
//  Copyright © 2017年 孟遥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYImageInfo.h"

@interface MYBottomMenuTool : NSObject

+ (void)show:(handleBlock)callback handleNames:(NSArray *)handleNames;

@end
