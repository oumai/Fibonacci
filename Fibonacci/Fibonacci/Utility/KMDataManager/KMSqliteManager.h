//
//  KmSqliteManager.h
//  HqewWorldShop
//
//  Created by Jun Li on 12-7-9.
//  Copyright (c) 2012年 Shenzhen Huaqiang E-Commerce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"
#import "FMDatabaseQueue.h"

@interface KMSqliteManager : NSObject
@property (nonatomic, retain) NSString *dbName;
@property (nonatomic, retain) FMDatabaseQueue *dbQueue;

- (BOOL) open;
- (void) close;
- (void) delayClose;
@end
