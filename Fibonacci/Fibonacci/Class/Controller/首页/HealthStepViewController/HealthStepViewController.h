//
//  HealthStepViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/8.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetectView;

@interface HealthStepViewController : KMUIViewController
{
    NSUInteger healthStepResult;
    CGFloat averageValue;
    CGFloat sumValue;
    DetectView *heartRoundView;
    UILabel *valuelabel;
    UILabel * kilometresLabel;
    UILabel * caloriesLabel;
    BOOL healthStatus;
}
@end
