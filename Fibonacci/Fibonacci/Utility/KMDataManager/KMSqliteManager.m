//
//  KmSqliteManager.m
//  HqewWorldShop
//
//  Created by Jun Li on 12-7-9.
//  Copyright (c) 2012年 Shenzhen Huaqiang E-Commerce. All rights reserved.
//

#import "KMSqliteManager.h"

#define delay_close_database_time 30.0f

@interface KMSqliteManager ()
{
    NSTimer *timerClose;
    BOOL isDelayClose;
}

@end

@implementation KMSqliteManager

- (id) init {
    self = [super init];
    if (self) {
        self.dbName = @"";
    }
    return self;
}

- (void) dealloc {
    [self close];
    [self EnableDelayCloseDB:NO];
}

- (void) OnTimer:(NSTimer *)theTimer {
    if (isDelayClose) {
        [self close];
    }
    
    [self EnableDelayCloseDB:NO];
}

- (void) EnableDelayCloseDB:(BOOL)isDelay {
    if (isDelay) {
        isDelayClose = YES;
        timerClose = [NSTimer scheduledTimerWithTimeInterval:delay_close_database_time target:self selector:@selector(OnTimer:) userInfo:nil repeats:NO];
    }
    else {
        [timerClose invalidate];
        timerClose = nil;
        isDelayClose = NO;
    }
}

- (BOOL) open
{
    if (self.dbQueue == nil) {
        if ([self.dbName isEqualToString:@""]) {
            NSLog(@"%s: database name is empty.", __func__);
            return NO;
        }
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:self.dbName];
        if (self.dbQueue == nil) {
            NSLog(@"Could not open database: %@", self.dbName);
            return NO;
        }
        else {
            [self EnableDelayCloseDB:NO];
            return YES;
        }
    }
    return YES;
}

- (void) close {
    if (self.dbQueue) {
        [self.dbQueue close];
        self.dbQueue = nil;
    }
}

- (void) delayClose {
    [self EnableDelayCloseDB:YES];
}

@end
