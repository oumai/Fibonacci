//
//  DetectioResultViewController.h
//  Fibonacci
//
//  Created by shipeiyuan on 16/8/26.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetectioResultView;
@class HeartView;
@interface DetectioResultViewController : KMUIViewController
{
    DetectioResultView *detectioResultView;
    HeartView *detectioHeartView;
    CGFloat detectioHeartViewY;
    CGFloat HeightHeartRate; //设定显示的最大心率值
    CGFloat LowHeartRate; //设定显示的最小心率值
}

@property (nonatomic) NSUInteger sumCount;
@end
