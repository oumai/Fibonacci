//
//  CoreCameraDetection.h
//  Fibonacci
//
//  Created by shipeiyuan on 16/8/30.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;
@import CoreVideo;
@class CoreCameraDetection;
@protocol CoreCameraDetectionDelegate <NSObject>
@optional
-(void)cameraDetection:(CoreCameraDetection* )cameraDetection didOutputSamplePassValue:(float)passValue;
-(void)cameraDetection:(CoreCameraDetection* )cameraDetection didOutputSampleErrorCount:(NSUInteger)errorCount;
-(void)cameraDetection:(CoreCameraDetection* )cameraDetection didOutputSampleHeartCount:(NSUInteger)heartCount andTimerCount:(NSUInteger)timerCount;
@end

@interface CoreCameraDetection : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    NSUInteger stopCount;
    NSUInteger ratioNumber;
    NSUInteger sumCount;        //心跳数
    CGFloat lastValue;            //上一个数据
    NSUInteger positiveCount;   //证书次数
    NSUInteger negativeCount;   //负数次数
    AVCaptureSession *captureSession;
    AVCaptureDevice *captureDevice;
    NSTimer *sosTimer;          //闪光灯定时器
    NSTimer *heheTimer;
    NSMutableArray *storageArray;
    NSUInteger errorCount;
//    dispatch_queue_t aQueue;
    CGFloat smooth; //平均值
}
@property(nonatomic,assign)NSUInteger timerCount;   //记时器
@property (nonatomic, assign) id <CoreCameraDetectionDelegate>delegate;

+ (CoreCameraDetection *)sharedCoreCameraDetection;
-(void)detectionStartRunning;
-(void)detectionStopRunning;
- (void)closeDetectionTimer;
-(void)sendErrorCount:(NSUInteger)count;
-(BOOL)cameraRunningStatus;
@end






