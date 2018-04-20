//
//  BloodOxygenViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/18.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreCameraDetection.h"
@class HeartBackgroundView;
@class DetectView;
@class HeartLive;
@interface BloodOxygenViewController : KMUIViewController<CoreCameraDetectionDelegate>
{
    CoreCameraDetection *coreCameraDetection;
    UIView *headerSPO2HView;
    DetectView *SPO2HView;
    HeartLive *liveSPO2HView;
    UILabel *sumSPO2HLable;
    UILabel *hudSPO2HLabel;
    UIButton *startSPO2HButton;
    
    NSTimer *SPO2HTimer;
    NSMutableArray *SPO2HArray;
    NSInteger xCoordinateInMoniter;
    CGFloat  augendValue;
    NSInteger currntTimer;
    BOOL onceHelpPages;
    NSInteger netRecordValue;
}

@end
