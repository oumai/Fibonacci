//
//  BloodOxygenResultViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/22.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeartView;
@interface BloodOxygenResultViewController : KMUIViewController
{
    HeartView *bloodOxygenHeartView;
    CGFloat bloodOxygenResultHeartViewY;
    UILabel *hudLabel;
}
@property(nonatomic,assign) NSInteger bloodOxygenResultValue;
@end
