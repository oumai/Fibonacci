//
//  HealthKitManage.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/5.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <Foundation/Foundation.h>
@import HealthKit;
@import UIKit;

#define HKVersion [[[UIDevice currentDevice] systemVersion] doubleValue]
#define CustomHealthErrorDomain @"com.sdqt.healthError"

typedef NS_ENUM(NSInteger, EHealthKitDataTimePeriod) {
    EHealthKitDataTimePeriodStatusDay            = 0,
    EHealthKitDataTimePeriodStatusWeek           = 1,
    EHealthKitDataTimePeriodStatusMonth          = 2,
    EHealthKitDataTimePeriodStatusYear           = 3,
    EHealthKitDataTimePeriodStatusAll            = 4
};

@interface HealthKitManage : NSObject

@property (nonatomic, strong)HKHealthStore *healthStore;

+(id)shareInstance;
- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion;
- (void)getDistanceFromDate:(NSDate *)date completion:(void(^)(double value, NSError *error))completion;

- (void)getStepCountFromDate:(NSDate *)date completion:(void(^)(double value, NSError *error))completion;
- (void)getCaloriesFromDate:(NSDate *)date completion:(void(^)(double value, NSError *error))completion;

- (void)getStepCountFromPeriod:(EHealthKitDataTimePeriod)timePeriod completion:(void (^)(NSMutableArray *valueArray, NSMutableArray *dateArray, NSError *error))completion;
@end
