//
//  UITextField+CustomTextField.m
//  KMXYUser
//
//  Created by KM on 16/4/72016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "UITextField+CustomTextField.h"

@implementation UITextField (CustomTextField)

+ (UITextField *)textFieldWithfont:(UIFont *)font textColor:(UIColor *)textColor placeholder:(NSString *)placeholder BorderStyle:(UITextBorderStyle)borderStyle {

    UITextField * tf = [[UITextField alloc] init];

    [tf setBorderStyle:borderStyle];
    [tf setTextColor:textColor];
    [tf setFont:font];
    [tf setPlaceholder:placeholder];
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;

    return tf;
}

@end
