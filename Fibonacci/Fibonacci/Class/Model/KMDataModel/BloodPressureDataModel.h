//
//  BloodPressureDataModel.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/27.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BloodPressureDataModel : NSObject

@property (nonatomic, copy) NSNumber *systolic_pressure_id; //收缩压
@property (nonatomic, copy) NSNumber *diastolic_blood_id; //舒张压
@property (nonatomic, copy) NSString *year; //年
@property (nonatomic, copy) NSString *month; //月
@property (nonatomic, copy) NSString *day; //日
@property (nonatomic, copy) NSString *time; //时间
@property (nonatomic, copy) NSNumber *timeInterval;
@property (nonatomic, assign) NSString *upload;

- (id) initBloodPressureSPValue:(NSNumber *)sp andDPValue:(NSNumber *)dp;

@end
