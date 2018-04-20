//
//  KMWeatherManage.h
//  Fibonacci
//
//  Created by shipeiyuan on 2016/11/26.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
@class WeartherHe;
@class WeartherAstro;
@interface KMWeatherManage : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    NSString *currentCity;
    __block BOOL loading;
    __block BOOL loadingSunrise;
}

@property(nonatomic) BOOL isFirstUpdate;

+ (KMWeatherManage *)sharedWeatherManage;
- (void)getWeathercompletion:(void(^)(BOOL success,WeartherHe * obj, NSError *error))completion;
- (void)getWeatherSunriseCompletion:(void(^)(BOOL success,WeartherAstro * obj, NSError *error))completion;
@end
