//
//  NormalViewController.m
//  MYPhotoBrowser_Example
//
//  Created by 孟遥 on 2017/2/22.
//  Copyright © 2017年 孟遥. All rights reserved.
//

#import "NormalViewController.h"
#import "MYPhotoBrowser.h"

@interface NormalViewController ()

@property (nonatomic, strong) NSArray *urls;
@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation NormalViewController

- (NSMutableArray *)imageViews
{
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

- (NSArray *)urls
{
    if (!_urls) {
        _urls = @[
                  @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487709799463&di=e8b4dc7f5bee128da2ab3437f4bfa5a3&imgtype=0&src=http%3A%2F%2Fimg.shoukeyi.com%2Fupload%2Fpicture%2Fscene%2F20143%2Flarge_6dd4013d-05ed-4d6a-8ebb-b5f138e26401.jpg",
                  @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487709987493&di=a76528a9ff0ae0da95e214c6ddaa6588&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fladyproduct%2F1606%2F15%2Fc0%2F22859886_1465963410000_medium.jpg",
                  @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487710151517&di=b23e277c1bdeb46634993fcc8d1383e0&imgtype=0&src=http%3A%2F%2Fdimg04.c-ctrip.com%2Fimages%2F300d0a0000004yz78AFD9.jpg",
                  @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487710246204&di=122cbf74925dca4e9b8e2620cd5de7c9&imgtype=0&src=http%3A%2F%2Fimg3.fengniao.com%2Fforum%2Fattachpics%2F771%2F191%2F30838047_1024.jpg"];
    }
    return _urls;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"常规使用";
    for (NSInteger index = 0; index < 4; index ++) {
        NSInteger row   = index%2;
        NSInteger colum = index/2;
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(50 + row *(150 + 10), 200 + colum *(150 + 10), 150, 150);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor grayColor];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.urls[index]]];
        [self.view addSubview:imageView];
        [self.imageViews addObject:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        [imageView addGestureRecognizer:tap];
    }
}


- (void)click:(UITapGestureRecognizer *)tap
{
    
    UIImageView *currentImageView = (UIImageView *)tap.view;
    NSInteger index = [self.imageViews indexOfObject:currentImageView];
    MYPhotoBrowser *photoBrowser = [[MYPhotoBrowser alloc]initWithUrls:self.urls imgViews:self.imageViews placeholder:nil currentIdx:index handleNames:@[@"1",@"2",@"3",@"4"] callback:^(UIImage *handleImage,NSString *handleType) {
        
        NSLog(@"-------------图片对象-%@----操作类型-%ld",handleImage,(long)handleType);
        
    }];
    [photoBrowser showWithAnimation:YES];
}


@end
