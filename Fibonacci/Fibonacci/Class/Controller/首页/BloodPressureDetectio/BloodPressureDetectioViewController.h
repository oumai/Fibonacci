//
//  BloodPressureDetectioViewController.h
//  Fibonacci
//
//  Created by shipeiyuan on 16/8/31.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreCameraDetection.h"
@class DetectView;
@class HeartLive;
@interface BloodPressureDetectioViewController : KMUIViewController<CoreCameraDetectionDelegate>
{
    CoreCameraDetection *coreCameraDetection;
    DetectView *heightPressureView;
    DetectView *lowPressureView;
    UILabel *heightLabel;
    UILabel *lowLabel;
    UILabel *hudLabel;
    UIButton *startButton;      //按钮
    NSTimer *circularLiveTimer;
    HeartLive *bloodPressureLiveView;
    NSMutableArray *bloodPressureArray;
    NSInteger xCoordinateInMoniter;
    NSInteger currntTimer;
    BOOL onceBPHelpPage;
    NSInteger netSPValue;
    NSInteger netDPValue;
    BOOL souceDataError;
}
@end
