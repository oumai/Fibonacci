//
//  BloodOxygenDataModel.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/27.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BloodOxygenDataModel : NSObject

@property (nonatomic, copy) NSNumber *value_id; //值
@property (nonatomic, copy) NSString *year; //年
@property (nonatomic, copy) NSString *month; //月
@property (nonatomic, copy) NSString *day; //日
@property (nonatomic, copy) NSString *time; //时间
@property (nonatomic, copy) NSNumber *timeInterval;
@property (nonatomic, assign) NSString *upload;

- (id) initBloodOxygenValueFromNumber:(NSNumber *)value;

@end
