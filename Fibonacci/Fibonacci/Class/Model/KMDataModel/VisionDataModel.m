//
//  VisionDataModel.m
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/27.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "VisionDataModel.h"

@implementation VisionDataModel

@synthesize value_id = _value_id;
@synthesize year = _year;
@synthesize month = _month;
@synthesize day = _day;
@synthesize time = _time;
@synthesize timeInterval = _timeInterval;

- (id) initVisionValueFromNumber:(NSNumber *)value
{
    self = [super init];
    if (self) {
        _value_id = value;
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
