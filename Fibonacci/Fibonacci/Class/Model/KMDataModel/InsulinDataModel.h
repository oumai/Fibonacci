//
//  InsulinDataModel.h
//  Fibonacci
//
//  Created by shipeiyuan on 2016/12/17.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InsulinDataModel : NSObject

@property (nonatomic, copy) NSString *name; //名称
@property (nonatomic, copy) NSNumber *dose; //剂量值
@property (nonatomic, copy) NSString *note; //备注
@property (nonatomic, copy) NSString *year; //年
@property (nonatomic, copy) NSString *month; //月
@property (nonatomic, copy) NSString *day; //日
@property (nonatomic, copy) NSString *time; //时间
@property (nonatomic, copy) NSNumber *timeInterval;
@property (nonatomic, copy) NSNumber *writeInterval;
@property (nonatomic, assign) NSString *upload;

- (id) initInsulinValueFromName:(NSString *)name dose:(NSNumber *)dose note:(NSString *)note timer:(NSString *)timerString;

@end
