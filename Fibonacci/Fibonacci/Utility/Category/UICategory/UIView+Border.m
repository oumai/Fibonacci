//
//  UIView+Border.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/132016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "UIView+Border.h"
#import "Masonry.h"

@implementation UIView (Border)

- (void)setBottomBorderWithColor:(UIColor *)color width:(float)width height:(float)height {

    if (width == 0) {
        width = self.frame.size.width;
    }
    if (height == 0) {
        height = 0.5f;
    }

    UIView * line = [[UIView alloc] init];
    line.backgroundColor = color;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];
}

- (void)setTopBorderWithColor:(UIColor *)color width:(float)width height:(float)height {
    if (height == 0) {
        height = 0.5f;
    }
    if (width == 0) {
        width = self.frame.size.width;
    }

    UIView * line = [[UIView alloc] init];
    line.backgroundColor = color;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];
}

- (void)setLeftBorderWithColor:(UIColor *)color width:(float)width height:(float)height {
    if (height == 0) {
        height = self.frame.size.height;
    }
    if (width == 0) {
        width = 0.5f;
    }

    UIView * line = [[UIView alloc] init];
    line.backgroundColor = color;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];

}

- (void)setRightBorderWithColor:(UIColor *)color width:(float)width height:(float)height {
    if (height == 0) {
        height = self.frame.size.height;
    }
    if (width == 0) {
        width = 0.5f;
    }

    UIView * line = [[UIView alloc] init];
    line.backgroundColor = color;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];

}

@end
