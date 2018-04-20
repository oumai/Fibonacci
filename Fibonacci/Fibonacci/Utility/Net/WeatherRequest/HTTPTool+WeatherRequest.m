//
//  HTTPTool+WeatherRequest.m
//  Fibonacci
//
//  Created by shipeiyuan on 2016/11/28.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "HTTPTool+WeatherRequest.h"
#import "WeatherModel.h"
@implementation HTTPTool (WeatherRequest)

+ (void)requestCityWeatherWithURLString:(NSString *)url
                             parameters:(id)parameters
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError * error))failure
{
    AFHTTPSessionManager *manager = [HTTPTool managerWithBaseURL:nil sessionConfiguration:NO];
    
    NSString * URL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    [manager GET:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id dic = [HTTPTool responseConfiguration:responseObject];
        WeatherModel *baseModel = [WeatherModel mj_objectWithKeyValues:dic];
        if ([baseModel.HeWeather5 count]>0) {
            WeartherHe *hehe =baseModel.HeWeather5[0];
            if ([hehe.status isEqualToString:@"ok"]) {
                if (success) {
                    success(hehe);
                }
            }
            else
            {
                if (failure) {
                    failure(dic);
                }
            }
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DDLogError(@"\nURL---\n%@\n请求失败 error---\n%@", URL, error.description);
        if (failure) {
            failure(error);
        }
    }];
}

//+ (void)requestCitySunriseWithURLString:(NSString *)url
//                             parameters:(id)parameters
//                                success:(void (^)(id responseObject))success
//                                failure:(void (^)(NSError * error))failure
//{
//    
//}
@end
