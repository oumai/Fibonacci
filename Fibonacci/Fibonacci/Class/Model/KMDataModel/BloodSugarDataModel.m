//
//  BloodSugarDataModel.m
//  Fibonacci
//
//  Created by shipeiyuan on 2016/12/17.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "BloodSugarDataModel.h"

@implementation BloodSugarDataModel

@synthesize value_id = _value_id;
@synthesize timeScale = _timeScale;
@synthesize note = _note;
@synthesize year = _year;
@synthesize month = _month;
@synthesize day = _day;
@synthesize time = _time;
@synthesize timeInterval = _timeInterval;
@synthesize writeInterval = _writeInterval;

- (id) initBloodSugarValueFromNumber:(NSNumber *)value note:(NSString *)note timeScale:(NSString *)timeScale timer:(NSString *)timerString
{
    self = [super init];
    if (self) {
        _value_id = value;
        _note = note;
        _timeScale = timeScale;
        [self getModelDateTimeFromString:timerString];
    }
    return self;
}

- (void)getModelDateTimeFromString:(NSString *)timerString
{
    NSLog(@"%@",timerString);
    
    NSArray *array = [timerString componentsSeparatedByString:@" "];
    _time = array[1];
    NSString *dateStr = array[0];
    NSArray *dateArray = [dateStr componentsSeparatedByString:@"-"];
    _year = dateArray[0];
    _month = dateArray[1];
    _day = dateArray[2];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *b = [timerString substringFromIndex:[timerString length]-2];
    double timer = [b doubleValue];
    timerString = [timerString substringToIndex:([timerString length]-3)];
    NSDate *date = [dateFormatter dateFromString:timerString];
    
    NSTimeInterval interval= [date timeIntervalSince1970];
    interval =  interval + timer;
    _timeInterval =  [NSNumber numberWithDouble:interval];
    
    NSTimeInterval nowInterval= [[NSDate date]timeIntervalSince1970];
    _writeInterval =  [NSNumber numberWithDouble:nowInterval];
}

@end
