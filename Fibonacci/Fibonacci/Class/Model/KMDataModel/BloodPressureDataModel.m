//
//  BloodPressureDataModel.m
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/27.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "BloodPressureDataModel.h"

@implementation BloodPressureDataModel

@synthesize systolic_pressure_id = _systolic_pressure_id;
@synthesize diastolic_blood_id = _diastolic_blood_id;
@synthesize year = _year;
@synthesize month = _month;
@synthesize day = _day;
@synthesize time = _time;

- (id) initBloodPressureSPValue:(NSNumber *)sp andDPValue:(NSNumber *)dp
{
    self = [super init];
    if (self) {
        _systolic_pressure_id = sp;
        _diastolic_blood_id = dp;
        [self getModelDateTime];
    }
    return self;
}

- (void)getModelDateTime
{
    NSString *dateStr = [KMTools getLocalDateWithTimeString:YES];
    NSArray *array = [dateStr componentsSeparatedByString:@"-"];
    _year = array[0];
    _month = array[1];
    _day = array[2];
    _time = array[3];
    NSTimeInterval interval= [[NSDate date]timeIntervalSince1970];
    _timeInterval =  [NSNumber numberWithDouble:interval];
}
@end
