//
//  WeatherModel.h
//  Fibonacci
//
//  Created by shipeiyuan on 2016/11/28.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface WeartherBasic: NSObject
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *cnty;
@end

@interface WeartherCond: NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *txt;
@end

@interface WeartherNow: NSObject

@property (nonatomic, copy) NSString *tmp;
@property (nonatomic, strong) WeartherCond *cond;
@end

@interface WeartherAstro : NSObject
@property (nonatomic, copy) NSString *mr;
@property (nonatomic, copy) NSString *ms;
@property (nonatomic, copy) NSString *sr;
@property (nonatomic, copy) NSString *ss;
@end

@interface WeartherDaily : NSObject
@property (nonatomic, strong) WeartherAstro *astro;
@property (nonatomic, strong) WeartherCond *cond;
@end

@interface WeartherHe : NSObject
@property (nonatomic, strong) WeartherBasic *basic;
@property (nonatomic, strong) WeartherNow *now;
@property (nonatomic, strong) NSArray <WeartherDaily*> *daily_forecast;
@property (nonatomic, copy) NSString *status;
@end

@interface WeatherModel : NSObject
@property (nonatomic, strong) NSArray<WeartherHe*> *HeWeather5;
@end

