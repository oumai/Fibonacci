//
//  UITextField+CustomTextField.h
//  KMXYUser
//
//  Created by KM on 16/4/72016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (CustomTextField)

+ (UITextField *)textFieldWithfont:(UIFont *)font textColor:(UIColor *)textColor placeholder:(NSString *)placeholder BorderStyle:(UITextBorderStyle)borderStyle;

@end
