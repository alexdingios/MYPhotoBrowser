//
//  MYBottomMenuTool.m
//  MYPhotoBrowser_Example
//
//  Created by 孟遥 on 2017/2/21.
//  Copyright © 2017年 孟遥. All rights reserved.
//

#import "MYBottomMenuTool.h"
#import "UIImage+blankImage.h"
#import "MYBottomMenuCell.h"

@interface MYBottomMenuTool ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *menuView;
@property (nonatomic, strong) UIControl *coverView;
@property (nonatomic, assign,getter= isShow) BOOL show;
@property (nonatomic, copy) handleBlock callback;
@property (nonatomic, strong) NSArray *handleNames;

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



- (UITableView *)menuView
{
    if (!_menuView) {
        _menuView = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreen_height,kScreen_with,kScreen_height) style:UITableViewStylePlain];
        _menuView.backgroundColor = [UIColor clearColor];
        _menuView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuView.delegate = self;
        _menuView.dataSource = self;
        _menuView.rowHeight = 50;
        _menuView.scrollEnabled = NO;
        [_menuView registerClass:[MYBottomMenuCell class] forCellReuseIdentifier:@"MYBottomMenuCell"];
    }
    return _menuView;
}


+ (void)show:(handleBlock)callback handleNames:(NSArray *)handleNames
{
    if (!handleNames.count) return;
    
    MYBottomMenuTool *tool    = [MYBottomMenuTool shareInstance];
    tool.callback             = callback;
    tool.handleNames          = handleNames;
    if (tool.isShow) return;
    tool.show                 =  YES;
    UIControl   *cover        = [MYBottomMenuTool shareInstance].coverView;
    UITableView *menu              = [MYBottomMenuTool shareInstance].menuView;
    UIWindow *keyWindow       = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:cover];
    [UIView animateWithDuration:0.25 animations:^{
        cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        menu.frame = CGRectMake(0, kScreen_height - 50*(handleNames.count+1)-5, kScreen_with, 50*(handleNames.count+1)+5);
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

#pragma mark - dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.handleNames.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYBottomMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYBottomMenuCell"];
    if (indexPath.section == 0) {
       cell.handleName = self.handleNames[indexPath.row];
    }else{
        cell.handleName = @"取消";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row != self.handleNames.count + 1) {
        
        //回调
        if (self.callback) {
            self.callback(self.handleNames[indexPath.row]);
        }
    }
    [self removeMenu];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==1) {
        return 5.f;
    }
    return 0.00001;
}

@end
