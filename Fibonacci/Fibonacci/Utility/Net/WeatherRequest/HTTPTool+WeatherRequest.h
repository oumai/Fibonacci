//
//  HTTPTool+WeatherRequest.h
//  Fibonacci
//
//  Created by shipeiyuan on 2016/11/28.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "HTTPTool.h"

@interface HTTPTool (WeatherRequest)
+ (void)requestCityWeatherWithURLString:(NSString *)url
                             parameters:(id)parameters
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError * error))failure;

//+ (void)requestCitySunriseWithURLString:(NSString *)url
//                             parameters:(id)parameters
//                                success:(void (^)(id responseObject))success
//                                failure:(void (^)(NSError * error))failure;
@end
