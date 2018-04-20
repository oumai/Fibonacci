//
//  BloodSugarDataModel.h
//  Fibonacci
//
//  Created by shipeiyuan on 2016/12/17.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BloodSugarDataModel : NSObject
@property (nonatomic, copy) NSNumber *value_id; //值
@property (nonatomic, copy) NSString *note; //备注
@property (nonatomic, copy) NSString *timeScale; //时间段
@property (nonatomic, copy) NSString *year; //年
@property (nonatomic, copy) NSString *month; //月
@property (nonatomic, copy) NSString *day; //日
@property (nonatomic, copy) NSString *time; //时间
@property (nonatomic, copy) NSNumber *timeInterval;
@property (nonatomic, copy) NSNumber *writeInterval;
@property (nonatomic, assign) NSString *upload;

- (id) initBloodSugarValueFromNumber:(NSNumber *)value note:(NSString *)note timeScale:(NSString *)timeScale timer:(NSString *)timerString;
@end
