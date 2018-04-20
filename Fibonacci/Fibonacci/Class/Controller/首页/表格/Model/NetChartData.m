//
//  NetChartData.m
//  Fibonacci
//
//  Created by woaiqiu947 on 2017/3/8.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import "NetChartData.h"

@implementation NetChartData
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"Data": [NetChartDataModel class]};
}
@end

@implementation NetChartDataModel
@end

