//
//  UIButton+CustomButton.h
//  KMXYUser
//
//  Created by KM on 16/4/72016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CustomButton)

+ (UIButton *)buttonWithType:(UIButtonType)type Title:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor backgroundImage:(UIImage *)backgroundImage Font:(UIFont *)font;

@end
