//
//  UIButton+CustomButton.m
//  KMXYUser
//
//  Created by KM on 16/4/72016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "UIButton+CustomButton.h"

@implementation UIButton (CustomButton)

+ (UIButton *)buttonWithType:(UIButtonType)type Title:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage Font:(UIFont *)font{

    UIButton * button = [UIButton buttonWithType:type];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button setBackgroundColor:backgroundColor];
    button.titleLabel.font = font;

    [button sizeToFit];
    
    return button;
}

@end
