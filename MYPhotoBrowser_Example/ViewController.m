//
//  ViewController.m
//  MYPhotoBrowser_Example
//
//  Created by 孟遥 on 2017/2/19.
//  Copyright © 2017年 孟遥. All rights reserved.
//

#import "ViewController.h"
#import "NormalViewController.h"
#import "TextDescViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.rowHeight  = 80;
        _tableView.delegate   = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"使用场景";
    [self.view addSubview:self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSString *desc = nil;
    if (indexPath.row == 0) {
        desc = @"常规使用";
    }else{
        desc = @"带文本描述,修改样式";
    }
    cell.textLabel.text = desc;
    cell.textLabel.font = [UIFont systemFontOfSize:18.f weight:1.f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        NormalViewController *normalVc = [[NormalViewController alloc]init];
        [self.navigationController pushViewController:normalVc animated:YES];
    }else{
        TextDescViewController *descVc = [[TextDescViewController alloc]init];
        [self.navigationController pushViewController:descVc animated:YES];
    }
}





@end
