//
//  BloodSugarSlider.h
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/12/14.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCircleSlider.h"
typedef NS_ENUM(NSInteger, EBloodSugarSliderColorType) {
    EBloodSugarSliderColorTypeDefault         = 0,
    EBloodSugarSliderColorTypeHeight          = 1,
};

@interface BloodSugarSlider : UIView<UITextFieldDelegate>
{
    CAGradientLayer *gradientLayer;
    JXCircleSlider *slider;
}
@property (nonatomic,assign)CGFloat angle;
@property (nonatomic,assign)EBloodSugarSliderColorType colorType;
@property (nonatomic, strong)UITextField *textField;
@end
