//
//  HealthKitManage.m
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/5.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "HealthKitManage.h"

@implementation HealthKitManage

@synthesize healthStore = _healthStore;

+(id)shareInstance
{
    static id manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

/*
 *  @brief  检查是否支持获取健康数据
 */
- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion
{
    if(HKVersion >= 8.0)
    {
        if (![HKHealthStore isHealthDataAvailable]) {
            NSError *error = [NSError errorWithDomain: @"com.raywenderlich.tutorials.healthkit" code: 2 userInfo: [NSDictionary dictionaryWithObject:@"HealthKit is not available in th is Device"                                                                      forKey:NSLocalizedDescriptionKey]];
            if (compltion != nil) {
                compltion(false, error);
            }
            return;
        }
        if ([HKHealthStore isHealthDataAvailable]) {
            if(_healthStore == nil)
                _healthStore = [[HKHealthStore alloc] init];
            /*
             组装需要读写的数据类型
             */
//            NSSet *writeDataTypes = [self dataTypesToWrite];
            NSSet *readDataTypes = [self dataTypesRead];
            
            /*
             注册需要读写的数据类型，也可以在“健康”APP中重新修改
             */
            [_healthStore requestAuthorizationToShareTypes:nil readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
                if (compltion != nil) {
                    if (!success)
                    {
//                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法获取健康数据" message:@"请开启健康权限：设置->隐私->健康->体检管家" preferredStyle:UIAlertControllerStyleAlert];
//                        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy"]];
//
//                        }];
//                        [alertController addAction:sureAction];
//                        UIAlertAction *canleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//                        [alertController addAction:canleAction];
//                        UIApplication *appDelegate = [UIApplication sharedApplication];
//                        [appDelegate.delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
                    }
                    else
                    {
                        HKQuantityType *stepsType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
                        HKQuantityType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
                        HKQuantityType *kaluolType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
                        
                        HKAuthorizationStatus stepsStatus = [_healthStore authorizationStatusForType:stepsType];
                        HKAuthorizationStatus distanceStatus = [_healthStore authorizationStatusForType:distanceType];
                        HKAuthorizationStatus kaluolStatus = [_healthStore authorizationStatusForType:kaluolType];
                        if (stepsStatus == HKAuthorizationStatusSharingDenied||distanceStatus == HKAuthorizationStatusSharingDenied||kaluolStatus ==HKAuthorizationStatusSharingDenied)
                        {
                        }
                    }
                    compltion (success, error);
                }
            }];
        }
    }
    else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"iOS 系统低于8.0" forKey:NSLocalizedDescriptionKey];
        NSError *aError = [NSError errorWithDomain:CustomHealthErrorDomain code:0 userInfo:userInfo];
        compltion(0,aError);
    }
}

/*!
 *  @brief  写权限
 *  @return 集合
 */
- (NSSet *)dataTypesToWrite
{
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantityType *temperatureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *stepsType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantityType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    return [NSSet setWithObjects:heightType, temperatureType, weightType,activeEnergyType,stepsType,distanceType,nil];
}

/*!
 *  @brief  读权限
 *  @return 集合
 */
- (NSSet *)dataTypesRead
{
//    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
//    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
//    HKQuantityType *temperatureType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
//    HKCharacteristicType *birthdayType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
//    HKCharacteristicType *sexType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex];
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantityType *distance = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    return [NSSet setWithObjects:stepCountType, distance, activeEnergyType,nil];
//    return [NSSet setWithObjects:heightType, temperatureType,birthdayType,sexType,weightType,stepCountType, distance, activeEnergyType,nil];
}

//获取步数
- (void)getStepCountFromDate:(NSDate *)date completion:(void(^)(double value, NSError *error))completion
{
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    // Since we are interested in retrieving the user's latest sample, we sort the samples in descending order, and set the limit to 1. We are not filtering the data, and so the predicate is set to nil.
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:stepType predicate:[HealthKitManage predicateForSamplesFromDate:date] limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if(error)
        {
            completion(0,error);
        }
        else
        {
            NSInteger totleSteps = 0;
            for(HKQuantitySample *quantitySample in results)
            {
                HKQuantity *quantity = quantitySample.quantity;
                HKUnit *heightUnit = [HKUnit countUnit];
                double usersHeight = [quantity doubleValueForUnit:heightUnit];
                totleSteps += usersHeight;
            }
            completion(totleSteps,error);
        }
    }];
    
    [self.healthStore executeQuery:query];
}

- (void)getStepCountFromPeriod:(EHealthKitDataTimePeriod)timePeriod completion:(void (^)(NSMutableArray *valueArray, NSMutableArray *dateArray, NSError *error))completion
{
    NSPredicate *predicate = [HealthKitManage predicateForSamplesFromPeriod:timePeriod];
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:stepType predicate:predicate limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if(error)
        {
            completion(nil,nil,error);
        }
        else
        {
            NSMutableArray *valueArray = [NSMutableArray new];
            NSMutableArray *dateArray = [NSMutableArray new];
            NSString *dateElem = @"";
            NSString *dateLast = @"";
            double totleSteps = 0;
            NSInteger index = 0;
            @autoreleasepool
            {
                for(HKQuantitySample *quantitySample in results)
                {
                    HKQuantity *quantity = quantitySample.quantity;
                    HKUnit *heightUnit = [HKUnit countUnit];
                    double usersHeight = [quantity doubleValueForUnit:heightUnit];
                    NSString *dateStr = [KMTools getStringFromDate:quantitySample.endDate];
//                    NSLog(@"%@",dateStr);
//                    NSLog(@"%f",usersHeight);
//                    NSLog(@"一共%f",totleSteps);
                    dateElem = [dateStr substringToIndex:10];
                    switch (timePeriod) {
                        case EHealthKitDataTimePeriodStatusDay:
                        {
                            NSRange range = NSMakeRange(11, 5);
                            dateStr = [dateStr substringWithRange:range];
                            [dateArray insertObject:dateStr atIndex:0];
                            NSString *str = [NSString stringWithFormat:@"%.0f",usersHeight];
                            [valueArray insertObject:str atIndex:0];
                        }
                            break;
                        case EHealthKitDataTimePeriodStatusWeek:
                        case EHealthKitDataTimePeriodStatusMonth:
                        case EHealthKitDataTimePeriodStatusYear:
                        {
                            if (([dateElem isEqualToString:dateLast] || index == 0)&&index!= [results count]-1)
                            {
                                totleSteps += usersHeight;
                            }
                            else
                            {
                                NSRange range = NSMakeRange(5, 5);
                                NSString *date = [dateLast substringWithRange:range];
                                date = [date stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                                [dateArray insertObject:date atIndex:0];
                                
                                NSString *str = [NSString stringWithFormat:@"%.0f",totleSteps];
                                [valueArray insertObject:str atIndex:0];
                                totleSteps = 0;
                                totleSteps += usersHeight;

                            }
                            dateLast = [dateStr substringToIndex:10];
                            index ++;
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
            }
            completion(valueArray,dateArray,error);
        }
    }];
    
    [self.healthStore executeQuery:query];
}
//获取公里数
- (void)getDistanceFromDate:(NSDate *)date completion:(void(^)(double value, NSError *error))completion
{
    HKQuantityType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:distanceType predicate:[HealthKitManage predicateForSamplesFromDate:date] limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        
        if(error)
        {
            completion(0,error);
        }
        else
        {
            double totleSteps = 0;
            for(HKQuantitySample *quantitySample in results)
            {
                HKQuantity *quantity = quantitySample.quantity;
                HKUnit *distanceUnit = [HKUnit meterUnitWithMetricPrefix:HKMetricPrefixKilo];
                double usersHeight = [quantity doubleValueForUnit:distanceUnit];
                totleSteps += usersHeight;
            }
            completion(totleSteps,error);
        }
    }];
    [self.healthStore executeQuery:query];
}

/*!
 *  @brief  获取卡路里
 */
- (void)getCaloriesFromDate:(NSDate *)date completion:(void(^)(double value, NSError *error))completion
{
    
    HKQuantityType *distanceType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:distanceType predicate:[HealthKitManage predicateForSamplesFromDate:date] limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        if(error)
        {
            completion(0,error);
        }
        else
        {
            double totleSteps = 0;
            for(HKQuantitySample *quantitySample in results)
            {
                HKQuantity *quantity = quantitySample.quantity;
                HKUnit *distanceUnit = [HKUnit kilocalorieUnit];
                double usersHeight = [quantity doubleValueForUnit:distanceUnit];
                totleSteps += usersHeight;
            }
            completion(totleSteps,error);
        }
    }];
    
    [self.healthStore executeQuery:query];
}

/*!
 *  @brief  当天时间段
 *
 *  @return 时间段
 */
+ (NSPredicate *)predicateForSamplesToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    
#if __IPHONE_8_0
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
#else
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
#endif
    [components setHour:0];
    [components setMinute:0];
    [components setSecond: 0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}

+ (NSPredicate *)predicateForSamplesFromDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = date;
    
#if __IPHONE_8_0
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
#else
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
#endif
    [components setHour:0];
    [components setMinute:0];
    [components setSecond: 0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}

+ (NSPredicate *)predicateForSamplesFromPeriod:(EHealthKitDataTimePeriod)timePeriod
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    switch (timePeriod) {
        case EHealthKitDataTimePeriodStatusDay:
            [comps setDay:0];
            break;
        case EHealthKitDataTimePeriodStatusWeek:
            [comps setDay:-6];
            break;
        case EHealthKitDataTimePeriodStatusMonth:
            [comps setMonth:-1];
            break;
        case EHealthKitDataTimePeriodStatusYear:
            [comps setYear:-1];
            break;
        default:
            break;
    }
    NSDate *nowdate = [NSDate date];
    NSDate *newdate = [calendar dateByAddingComponents:comps toDate:nowdate options:0];
    NSDate *startDate = [calendar startOfDayForDate:newdate];
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:nowdate options:HKQueryOptionNone];
    return predicate;
}
@end
