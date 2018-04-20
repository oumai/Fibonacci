//
//  UILabel+CustomLabel.m
//  KMXYUser
//
//  Created by KM on 16/4/72016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "UILabel+CustomLabel.h"

@implementation UILabel (CustomLabel)

+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAligment {

    UILabel * label = [[UILabel alloc] init];

    [label setFont:font];
    [label setTextColor:textColor];
    [label setTextAlignment:textAligment];

    [label sizeToFit];
    
    return label;
}

@end
