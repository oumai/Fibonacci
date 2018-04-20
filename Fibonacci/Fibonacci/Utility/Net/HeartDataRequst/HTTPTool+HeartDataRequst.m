//
//  HTTPTool+HeartDataRequst.m
//  Fibonacci
//
//  Created by woaiqiu947 on 2017/3/10.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import "HTTPTool+HeartDataRequst.h"
#import "BATPerson.h"
#import "NetChartData.h"

@implementation HTTPTool (HeartDataRequst)

+ (void)getPhysicalRecoidCompletion:(void(^)(BOOL success,NSMutableDictionary * dict, NSError *error))completion
{
    BATPerson *person = PERSON_INFO;
    if (!LOGIN_STATION || person.Data.IDNumber.length< 1)
    {
        completion(NO,nil,nil);
        return;
    }
    NSArray *dataKeyArray = @[@"心率", @"舒张压", @"收缩压", @"血氧", @"血糖"];
    NSMutableDictionary *dataDic = [NSMutableDictionary new];
    NSDictionary *dic = @{@"pageIndex":@"NULL",
                          @"pageSize":@"NULL",
                          @"idNumber":person.Data.IDNumber};
    [HTTPTool requestWithURLString:@"/api/HealthManager/GetHealthRecordList" parameters:dic showStatus:NO type:kGET success:^(id responseObject) {
        NetChartData *data = [NetChartData mj_objectWithKeyValues:responseObject];
        if (data.RecordsCount == 0 && data.Data.count > 0)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @autoreleasepool {
                    NSMutableDictionary *temporaryArray = [NSMutableDictionary new];
                    [data.Data enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NetChartDataModel *model = (NetChartDataModel *)obj;
                        model.CreateDate = [model.CreateDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                        NSMutableArray *array = [temporaryArray objectForKey:model.CodeName];
                        if (array.count < 1) {
                            array = [NSMutableArray new];
                        }
                        [array addObject:model];
                        [temporaryArray setObject:array forKey:model.CodeName];
                    }];
                    [temporaryArray.allKeys enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString *key = temporaryArray.allKeys[idx];
                        NSMutableArray *array = temporaryArray[key];
                        NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                                                {
                                                    NetChartDataModel *model1 = (NetChartDataModel *)obj1;
                                                    NetChartDataModel *model2 = (NetChartDataModel *)obj2;
                                                    NSTimeInterval objInterval1 = [KMTools getIntervalFromString:model1.CreateDate];
                                                    NSTimeInterval objInterval2 = [KMTools getIntervalFromString:model2.CreateDate];
                                                    if (objInterval2 > objInterval1)
                                                    {
                                                        return NSOrderedAscending;
                                                    }
                                                    return NSOrderedDescending;
                                                }];
                        __block NSString *dicKey = @"";
                        [dataKeyArray enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSString *keyStr = dataKeyArray[idx];
                            if ([key containsString:keyStr])
                            {
                                dicKey = keyStr;
                                *stop = YES;
                            }
                        }];
                        [sortedArray enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            NetChartDataModel *model = (NetChartDataModel *)obj;
                            NSMutableDictionary *resultDic = [dataDic objectForKey:@"result"];
                            NSMutableDictionary *dateDic = [dataDic objectForKey:@"date"];
                            if (resultDic.allKeys.count < 1)
                            {
                                resultDic = [NSMutableDictionary new];
                                dateDic = [NSMutableDictionary new];
                            }
                            NSMutableArray *resultArray = [resultDic objectForKey:dicKey];
                            NSMutableArray *dateArray = [dateDic objectForKey:dicKey];
                            if (resultArray.count < 1)
                            {
                                resultArray = [NSMutableArray new];
                                dateArray = [NSMutableArray new];
                            }
                            [resultArray addObject:model.Result];
                            [dateArray addObject:model.CreateDate];
                            [resultDic setObject:resultArray forKey:dicKey];
                            [dateDic setObject:dateArray forKey:dicKey];
                            [dataDic setObject:resultDic forKey:@"result"];
                            [dataDic setObject:dateDic forKey:@"date"];
                        }];
                    }];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (dataDic.allKeys.count > 0) {
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:dataDic forKey: KEY_PHYSICALRECORD_DIC];
                        [defaults synchronize];
                        completion(YES,dataDic,nil);
                        return;
                    }
                    else
                    {
                        completion(NO,nil,nil);
                    }
                });
            });
        }
        else
        {
            completion(NO,nil,nil);
        }
    } failure:^(NSError *error) {
        completion(NO,nil,nil);
    }];
    
}

//+(BOOL)isUpdateWeather
//{
//    NSNumber * lastDateNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"NETHEALTH_INTERVAL_TIME"];
//    if (![lastDateNumber isKindOfClass:[NSNumber class]]) {
//        return YES;
//    }
//    double lastInterval = [lastDateNumber doubleValue];
//    double nowInterval = [[NSDate date ]timeIntervalSince1970];
//    if (nowInterval - lastInterval > 3600) {
//        return YES;
//    }
//    return NO;
//}

@end
