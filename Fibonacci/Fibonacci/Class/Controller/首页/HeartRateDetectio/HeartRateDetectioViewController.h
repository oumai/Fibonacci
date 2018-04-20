//
//  HeartRateDetectioViewController.h
//  Fibonacci
//
//  Created by shipeiyuan on 16/8/24.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreCameraDetection.h"

@interface HeartRateDetectioViewController : KMUIViewController<CoreCameraDetectionDelegate>
{
    CoreCameraDetection *coreCameraDetection;
    NSMutableArray *points;     //数据
    UILabel *sumLabel;          //提示
    UIView *headerView;
    UILabel *hudLabel;
    UIButton *startButton;      //按钮
    NSInteger xCoordinateInMoniter;
    UIImageView *suspendView;   //待机图
    UIImageView *jumpView;   //跳跳图
    NSInteger currntTimer;
    BOOL onceHeartRateHelp;
    NSInteger netHeartRateValue;
}
@end
