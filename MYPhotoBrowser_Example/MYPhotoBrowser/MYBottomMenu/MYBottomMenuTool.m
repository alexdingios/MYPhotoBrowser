//
//  MYBottomMenuTool.m
//  MYPhotoBrowser_Example
//
//  Created by 孟遥 on 2017/2/21.
//  Copyright © 2017年 孟遥. All rights reserved.
//

#import "MYBottomMenuTool.h"
#import "UIImage+blankImage.h"
#import <objc/runtime.h>

@interface MYBottomMenuTool ()

@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UILabel *linelabel;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIControl *coverView;
@property (nonatomic, assign,getter= isShow) BOOL show;
@property (nonatomic, copy) handleBlock callback;
@end

@implementation MYBottomMenuTool

+ (instancetype)shareInstance
{
    static MYBottomMenuTool *menuTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menuTool = [[MYBottomMenuTool alloc]init];
    });
    return menuTool;
}

- (UIControl *)coverView
{
    if (!_coverView) {
        _coverView = [[UIControl alloc]initWithFrame:kScreen_bounds];
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        [_coverView addTarget:self action:@selector(removeMenu) forControlEvents:UIControlEventTouchUpInside];
        [_coverView addSubview:self.menuView];
    }
    return _coverView;
}



- (UIView *)menuView
{
    if (!_menuView) {
        _menuView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_height + 155, kScreen_with, 155)];
        _menuView.backgroundColor = [UIColor grayColor];
        [_menuView addSubview:self.saveButton];
        [_menuView addSubview:self.sendButton];
        [_menuView addSubview:self.cancelButton];
        [_menuView addSubview:self.linelabel];
        self.saveButton.frame     = CGRectMake(0, 0, kScreen_with, 50);
        self.linelabel.frame      = CGRectMake(0, CGRectGetMaxY(self.saveButton.frame), kScreen_with, 1.f);
        self.sendButton.frame     = CGRectMake(0, CGRectGetMaxY(self.linelabel.frame), kScreen_with, 50);
        self.cancelButton.frame   = CGRectMake(0,CGRectGetMaxY(self.sendButton.frame)+5, kScreen_with, 50);
    }
    return _menuView;
}

- (UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton     = [UIButton buttonWithType:UIButtonTypeCustom];
        [self buttonConfig:_saveButton];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        _saveButton.tag = 19910805 + 0;
        [_saveButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton     = [UIButton buttonWithType:UIButtonTypeCustom];
        [self buttonConfig:_sendButton];
        [_sendButton setTitle:@"发送给好友" forState:UIControlStateNormal];
        _sendButton.tag = 19910805 + 1;
        [_sendButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton     = [UIButton buttonWithType:UIButtonTypeCustom];
        [self buttonConfig:_cancelButton];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.tag = 19910805 + 2;
        [_cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UILabel *)linelabel
{
    if (!_linelabel) {
        _linelabel = [[UILabel alloc]init];
        _linelabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    }
    return _linelabel;
}


+ (void)show:(handleBlock)callback
{
    MYBottomMenuTool *tool    = [MYBottomMenuTool shareInstance];
    tool.callback             = callback;
    if (tool.isShow) return;
    tool.show                 =  YES;
    UIControl   *cover        = [MYBottomMenuTool shareInstance].coverView;
    UIView *menu              = [MYBottomMenuTool shareInstance].menuView;
    UIWindow *keyWindow       = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:cover];
    [UIView animateWithDuration:0.25 animations:^{
        cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        menu.frame = CGRectMake(0, kScreen_height - 155, kScreen_with, 155);
    }];
}

- (void)removeMenu
{
    UIControl *control                             = [MYBottomMenuTool shareInstance].coverView;
    [UIView animateWithDuration:0.15 animations:^{
        self.menuView.frame                        = CGRectMake(0, kScreen_height, kScreen_with, 155);
        self.coverView.backgroundColor             = [UIColor colorWithWhite:0 alpha:0.0];
    } completion:^(BOOL finished) {
        [control removeFromSuperview];
        [MYBottomMenuTool shareInstance].coverView = nil;
        [MYBottomMenuTool shareInstance].menuView  = nil;
        [MYBottomMenuTool shareInstance].show      = NO;
    }];
}


//点击
- (void)buttonClick:(UIButton *)button
{
    switch (button.tag - 19910805) {
        case 0:
        {
            if (self.callback) {
                self.callback(MYHandleTypeSave);
                [self removeMenu];
            }
        }
            break;
        case 1:
        {
            if (self.callback) {
                self.callback(MYHandleTypeSend);
                [self removeMenu];
            }
        }
            break;
        case 2:
        {
            if (self.callback) {
                self.callback(MYHandleTypeCancel);
                [self removeMenu];
            }
        }
            break;
        default:
            break;
    }
}

- (void)buttonConfig:(UIButton *)button
{
    UIImage *norBackImg             = [UIImage imageFromContextWithColor:[UIColor whiteColor]];
    UIImage *highBackImg            = [UIImage imageFromContextWithColor:[UIColor colorWithRed:50.f green:50.f blue:50.f alpha:0.5]];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:norBackImg forState:UIControlStateNormal];
    [button setBackgroundImage:highBackImg forState:UIControlStateHighlighted];
}


@end
