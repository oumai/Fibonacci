//
//  BloodSugarSpreadView.h
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/12/13.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BloodSugarSpreadType) {
    BloodSugarSpreadTypeDefault         = 0,
    BloodSugarSpreadTypeLow             = 1,
    BloodSugarSpreadTypeHeight          = 2,
};

@interface BloodSugarSpreadView : UIView
{
    CAGradientLayer *gradientLayer;
    CAShapeLayer *masklayer;
}

@property (nonatomic, strong)UIView *maskView;
@property (nonatomic, assign)BloodSugarSpreadType type;
- (instancetype)initWithFrame:(CGRect)frame status:(BloodSugarSpreadType)type;
@end
