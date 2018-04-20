//
//  ReminderModel.h
//  Fibonacci
//
//  Created by shipeiyuan on 2016/12/20.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoseTime : NSObject
@property(nonatomic, copy)NSString *dose;
@property(nonatomic, copy)NSString *time;
@end

@interface ReminderModel : NSObject

@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *note;
@property(nonatomic, strong)NSMutableArray *weekArray;
@property(nonatomic, strong)NSMutableArray *doseTimeArray;
@property(nonatomic, copy)NSString *date;
@property(nonatomic, assign)BOOL isReminder;
@property(nonatomic, assign)BOOL isCompleted;
@end
