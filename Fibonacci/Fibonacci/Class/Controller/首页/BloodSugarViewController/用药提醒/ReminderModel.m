//
//  ReminderModel.m
//  Fibonacci
//
//  Created by shipeiyuan on 2016/12/20.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "ReminderModel.h"

@implementation DoseTime

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.dose forKey:@"dose"];
    [encoder encodeObject:self.time forKey:@"time"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.dose = [decoder decodeObjectForKey:@"dose"];
        self.time = [decoder decodeObjectForKey:@"time"];
    }
    return  self;
}

@end

@implementation ReminderModel
- (id)init
{
    self = [super init];
    if (self) {
        self.weekArray = [NSMutableArray new];
        self.doseTimeArray = [NSMutableArray new];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.note forKey:@"note"];
    [encoder encodeObject:self.weekArray forKey:@"weekArray"];
    [encoder encodeObject:self.doseTimeArray forKey:@"doseTimeArray"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeBool:self.isReminder forKey:@"isReminder"];
    [encoder encodeBool:self.isCompleted forKey:@"isCompleted"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.note = [decoder decodeObjectForKey:@"note"];
        self.weekArray = [decoder decodeObjectForKey:@"weekArray"];
        self.doseTimeArray = [decoder decodeObjectForKey:@"doseTimeArray"];
        self.date = [decoder decodeObjectForKey:@"date"];
        self.isReminder = [decoder decodeBoolForKey:@"isReminder"];
        self.isCompleted = [decoder decodeBoolForKey:@"isCompleted"];
    }
    return  self;
}

@end
