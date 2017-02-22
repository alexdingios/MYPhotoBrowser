//
//  UIImage+blankImage.m
//  MYPhotoBrowser_Example
//
//  Created by 孟遥 on 2017/2/20.
//  Copyright © 2017年 孟遥. All rights reserved.
//

#import "UIImage+blankImage.h"

@implementation UIImage (blankImage)

+ (UIImage *)imageFromContextWithColor:(UIColor *)color
{
    
    CGRect rect=(CGRect){{0.0f,0.0f},CGSizeMake(1.f, 1.f)};
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
