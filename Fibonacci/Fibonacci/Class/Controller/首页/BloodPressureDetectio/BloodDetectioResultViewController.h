//
//  BloodDetectioResultViewController.h
//  Fibonacci
//
//  Created by shipeiyuan on 16/8/31.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeartBackgroundView;
@interface BloodDetectioResultViewController : KMUIViewController
{
    HeartBackgroundView *bloodResultView;
    NSTimer *animateTimer;
    CGFloat averageValue;
    CGFloat sumValue;
    UIImageView *crazyView;
    UILabel* textHudLabel;
}
@property (nonatomic) NSInteger systolicPressure;
@property (nonatomic) NSInteger diatolicPressure;

@end
