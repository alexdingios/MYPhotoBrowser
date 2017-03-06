//
//  MYBottomMenuCell.m
//  MYPhotoBrowser_Example
//
//  Created by 孟遥 on 2017/3/6.
//  Copyright © 2017年 孟遥. All rights reserved.
//

#import "MYBottomMenuCell.h"

@interface MYBottomMenuCell ()

@property (nonatomic, strong) UILabel *lineLabel; //分割线

@end

@implementation MYBottomMenuCell

- (UILabel *)lineLabel
{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return _lineLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont systemFontOfSize:15.f weight:0.5];
        [self.contentView addSubview:self.lineLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.lineLabel.frame = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1.f);
}

- (void)setHandleName:(NSString *)handleName
{
    _handleName = handleName;
    
    self.textLabel.text = handleName;
}


@end
