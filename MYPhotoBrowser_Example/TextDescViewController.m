//
//  TextDescViewController.m
//  MYPhotoBrowser_Example
//
//  Created by 孟遥 on 2017/2/22.
//  Copyright © 2017年 孟遥. All rights reserved.
//

#import "TextDescViewController.h"
#import "MYPhotoBrowser.h"

@interface TextDescViewController ()

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation TextDescViewController

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(150, 100, 150, 150)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487779530494&di=d80ef51eabf67bca5ad3140004133b28&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fw%3D580%2Fsign%3D65bac9fb0246f21fc9345e5bc6256b31%2F479ed790f603738d1b078b22bb1bb051f919ec86.jpg"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"带文本描述使用";
    [self.view addSubview:self.imageView];
}


- (void)click:(UITapGestureRecognizer *)tap
{
    MYPhotoBrowser *photoBrowser = [[MYPhotoBrowser alloc]initWithUrls:@[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487779530494&di=d80ef51eabf67bca5ad3140004133b28&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fw%3D580%2Fsign%3D65bac9fb0246f21fc9345e5bc6256b31%2F479ed790f603738d1b078b22bb1bb051f919ec86.jpg"] imgViews:@[self.imageView] placeholder:nil currentIdx:0 handleNames:@[@"1",@"2",@"3",@"4"] callback:^(UIImage *handleImage, NSString *handleType) {
        NSLog(@"-----------图片对象--%@---操作类型-%@",handleImage,handleType);
    }];
//    photoBrowser.controlStyle = MYPageIndicatorStyleText; 可以将指示器设置为数字，只在图片大于1张时生效
    photoBrowser.descText = @"熊本熊最初设计目的是以吉祥物的身份，为熊本县带来更多的观光以及其他附加收入，并在2011年被授予熊本县营业部长兼幸福部长，成为日本第一位吉祥物公务员。在振兴熊本县经济、宣传熊本县名气的同时，熊本熊依靠自身呆萌的形象、独特的授权运营方式，在日本本国及本国以外获得了超乎想象的欢迎，成为在世界上拥有极高人气的吉祥物。熊本熊最早由县政府工作人员客串，随着熊本熊接到的“业务”越来越多，官方不得不招聘更多的扮演着来分头完成这些工作，目前已知的熊本熊扮演者至少有 5 个，只有这样才能同时应付办公出差、商演、导游等各项工作.";
    [photoBrowser showWithAnimation:YES];
}

@end
