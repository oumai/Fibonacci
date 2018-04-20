//
//  KMDataManager.m
//  TsuenWanBaptist
//
//  Created by Sgs on 14/11/1.
//  Copyright (c) 2014年 Sgs. All rights reserved.
//

#import "KMDataManager.h"

#import "HeartRateDataModel.h"
#import "BloodPressureDataModel.h"
#import "BloodOxygenDataModel.h"
#import "VisionDataModel.h"
#import "VitalCapacityDataModel.h"
#import "RequestHealthData.h"
#import "BloodSugarDataModel.h"
#import "InsulinDataModel.h"

#define DB_VERSION 3

@implementation KMDataManager

static KMDataManager *appDB = nil;

+ (KMDataManager *) sharedDatabaseInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (appDB == nil) {
            appDB = [KMDataManager new];
        }
    });
    return appDB;
}

- (void) dealloc {
    appDB = nil;
}

- (void)deleteDataBase{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    [fm removeItemAtPath:self.dbName error:nil];
    
}

- (BOOL)deleteTableName:(NSString *)name
{
    __block BOOL result = NO;
    if ([self open])
    {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            NSString *sql = @"";
            @try {
                sql = [NSString stringWithFormat:@"DELETE FROM %@", name];
                result = [db executeUpdate:sql];
                if (!result) {
                    NSLog(@"%s Failed: %@", __func__, [db lastErrorMessage]);
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s except: %@", __func__, exception.description);
            }
            @finally {
                [self delayClose];
            }
        }];
    }
    return result;
}

- (void)updateDataBase
{
    NSString *path = [self getUserDocumentPath];
    NSString *oldBb = [self getDocumentDataName];
    self.dbName = [path stringByAppendingPathComponent:oldBb];
    NSString * dataV = [[NSUserDefaults standardUserDefaults] valueForKey:@"DATA_VERSION"];
    if (![dataV isKindOfClass: [NSString class]] &&oldBb.length >0)
    {
        [self deleteDataBase];
        NSString *version = [NSString stringWithFormat:@"%d",DB_VERSION];
        [[NSUserDefaults standardUserDefaults] setValue:version forKey:@"DATA_VERSION"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(![dataV isEqualToString:[NSString stringWithFormat:@"%d",DB_VERSION]]&&oldBb.length >0)
    {
        if ([self addTable]) {
            NSLog(@"数据库更新了======= %@",dataV);
        }
    }
    
    [self setDatabaseName: App_Db_Name];
    NSLog(@"=== %@",path);
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 *NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self uploadHealthData];
    });
}

- (NSString *) getUserDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

- (NSString *) getDocumentDataName
{
    NSFileManager* fm=[NSFileManager defaultManager];
    NSString *path = [self getUserDocumentPath];
    NSArray *files = [fm subpathsAtPath: path];
    NSMutableArray *txtFile = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *dbName = @"";
    for (NSString * elem in files) {
        if ([elem containsString:@".db"])
        {
            [txtFile addObject:elem];
        }
    }
    if ([txtFile count]>0) {
        dbName = txtFile[0];
    }
    return dbName;
}

- (void) setDatabaseName:(NSString *)databaseName
{
    [self close];
    NSString *path = [self getUserDocumentPath];
    self.dbName = [path stringByAppendingPathComponent:databaseName];
    
    if (![KMTools fileIsExists:self.dbName])
    {
        if ([self open]) {
            [self.dbQueue inDatabase:^(FMDatabase *db)
            {
                if (![self createTables:db])
                {
                    NSLog(@"%s: create tables failed.", __func__);
                }
                
            }];
        }
    }
    else {
        
        if ([self open]) {
        }
    }
    
}


//修改数据库名称
- (void) changeDatabaseName
{
    NSString *newName = @"";
    NSString *currentStr = [self getDocumentDataName];
    NSString *path = [self getUserDocumentPath];
    if (LOGIN_STATION&&LOCAL_TOKEN)
    {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 *NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [self uploadHealthData];
        });
    }
    else
    {
        newName = App_Db_Name;
        self.dbName = [path stringByAppendingPathComponent:currentStr];
        [self deleteDataBase];
        [self setDatabaseName: newName];
    }
}

- (BOOL) createTables:(FMDatabase *)db {
    BOOL result = YES;
    
    // 所有数据版本表
    NSString *sql = @"CREATE TABLE IF NOT EXISTS DataVersionTable (TableName varchar(100), TableVersion integer not null default 0, IsUpdate integer not null default 0, primary key (TableName))";
    result = [db executeUpdate:sql];
    
    if (!result) {
        return result;
    }
    
    // 心率
    sql = @"CREATE TABLE if not exists heart_rate_table(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, value_id INTEGER,year INTEGER,month INTEGER,day INTEGER,time char,timeInterval double, upload integer not null default 0)";
    
    result = [db executeUpdate:sql];
    
    if (!result) {
        return result;
    }
    
    // 血压
    sql = @"CREATE TABLE if not exists blood_pressure_table(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, systolic_pressure_id INTEGER,diastolic_blood_id INTEGER,year INTEGER,month INTEGER,day INTEGER,time char,timeInterval double, upload integer not null default 0)";
    
    result = [db executeUpdate:sql];
    
    if (!result) {
        return result;
    }
    
    // 血氧
    sql = @"CREATE TABLE if not exists blood_oxygen_table(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, value_id INTEGER,year INTEGER,month INTEGER,day INTEGER,time char,timeInterval double, upload integer not null default 0)";
    
    result = [db executeUpdate:sql];
    
    if (!result) {
        return result;
    }
    
    // 视力
    sql = @"CREATE TABLE if not exists vision_table(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, value_id FLOAT,year INTEGER,month INTEGER,day INTEGER,time char,timeInterval double, upload integer not null default 0)";
    
    result = [db executeUpdate:sql];
    
    if (!result) {
        return result;
    }
    
    //肺活量
    sql = @"CREATE TABLE if not exists vital_capacity_table(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, value_id INTEGER,year INTEGER,month INTEGER,day INTEGER,time char,timeInterval double, upload integer not null default 0)";
    
    result = [db executeUpdate:sql];
    
    if (!result) {
        return result;
    }
    
    //步行
    sql = @"CREATE TABLE if not exists health_step_table(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, value_id TEXT, stepcount_id TEXT, timeInterval double, upload integer not null default 0)";

    result = [db executeUpdate:sql];
    if (!result) {
        return result;
    }
    
    //血糖
    sql = @"CREATE TABLE if not exists blood_sugar_table(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, value_id FLOAT,timeScale INTEGER, note NCHAR, year INTEGER, month INTEGER,day INTEGER,time char,timeInterval double, writeInterval double, upload integer not null default 0)";
    result = [db executeUpdate:sql];
    if (!result) {
        return result;
    }

    //胰岛素
    sql = @"CREATE TABLE if not exists insulin_table(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, name NCHAR, dose FLOAT, note NCHAR, year INTEGER, month INTEGER,day INTEGER,time char,timeInterval double, writeInterval double, upload integer not null default 0)";
    
    result = [db executeUpdate:sql];

    if (!result) {
        return result;
    }
    
    if (result) {

        NSArray *array = @[@"heart_rate_table", @"blood_pressure_table", @"blood_oxygen_table", @"vision_table", @"vital_capacity_table", @"health_step_table", @"blood_sugar_table", @"insulin_table"];
        NSArray *aryAddParams;
        for (int i = 0; i< [array count]; i++)
        {
            sql = [NSString stringWithFormat:@"insert into DataVersionTable(TableName, TableVersion, IsUpdate) values(?,?,?)"];
            aryAddParams = [NSArray arrayWithObjects:array[i],
                            [NSString stringWithFormat:@"%d", DB_VERSION],@"0",
                            nil];
            result = [db executeUpdate:sql withArgumentsInArray:aryAddParams];
        }
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d", DB_VERSION] forKey:@"DATA_VERSION"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return result;
}

- (BOOL)addTable
{
    __block BOOL result = NO;
    NSArray *aryAllTableNames = [self getAllTableName];
    if ([self open])
    {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            NSString *sql = @"";
            @try {
                
                //血糖
                if (![aryAllTableNames containsObject:@"blood_sugar_table"])
                {
                    sql = @"CREATE TABLE if not exists blood_sugar_table(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, value_id FLOAT,timeScale INTEGER, note NCHAR, year INTEGER, month INTEGER,day INTEGER,time char,timeInterval double, writeInterval double, upload integer not null default 0)";
                    result = [db executeUpdate:sql];
                }
                else
                {
                    result = YES;
                }
                
                if (![aryAllTableNames containsObject:@"insulin_table"])
                {
                    //胰岛素
                    sql = @"CREATE TABLE if not exists insulin_table(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, name NCHAR, dose FLOAT, note NCHAR, year INTEGER, month INTEGER,day INTEGER,time char,timeInterval double, writeInterval double, upload integer not null default 0)";
                    result = [db executeUpdate:sql];
                }
                else
                {
                    result = YES;
                }
                if (result) {

                    NSArray *array = @[@"heart_rate_table", @"blood_pressure_table", @"blood_oxygen_table", @"vision_table", @"vital_capacity_table", @"health_step_table", @"blood_sugar_table", @"insulin_table"];
                    NSArray *aryAddParams;
                    for (int i = 0; i< [array count]; i++)
                    {
                        NSString *tableName = array[i];
                        if ([aryAllTableNames containsObject:tableName])
                        {
                            sql = [NSString stringWithFormat:@"update DataVersionTable set TableVersion = '%@', IsUpdate = '%@' where TableName = '%@'", [NSString stringWithFormat:@"%d", DB_VERSION], @"0", tableName];
                            result = [db executeUpdate:sql];
                        }
                        else {
                            sql = [NSString stringWithFormat:@"insert into DataVersionTable(TableName, TableVersion, IsUpdate) values(?,?,?)"];
                            aryAddParams = [NSArray arrayWithObjects: tableName,
                                            [NSString stringWithFormat:@"%d", DB_VERSION],
                                            @"0",
                                            nil];
                            result = [db executeUpdate:sql withArgumentsInArray:aryAddParams];
                        }
                    }
                    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d", DB_VERSION] forKey:@"DATA_VERSION"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
                if (!result) {
                    NSLog(@"%s Failed: %@", __func__, [db lastErrorMessage]);
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s except: %@", __func__, exception.description);
            }
            @finally {
                [self delayClose];
            }
        }];
    }
    return result;
}

- (BOOL) addTableDataVersion:(NSString *)tableName Version:(NSString *)version IsUpdate:(NSString *)isUpdate {
    __block BOOL result = NO;
    
    if ([self open]) {
        
        NSArray *aryAllTableNames = [self getAllTableName];
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            NSString *sql = @"";
            @try {
                if ([aryAllTableNames containsObject:tableName]) {
                    sql = [NSString stringWithFormat:@"update DataVersionTable set TableVersion = '%@', IsUpdate = '%@' where TableName = '%@'", version, isUpdate, tableName];
                    //NSArray *aryUpdateParams = [NSArray arrayWithObjects:tableName, version, isUpdate, nil];
                    result = [db executeUpdate:sql];
                }
                else {
                    sql = @"insert into DataVersionTable(TableName, TableVersion, IsUpdate) values(?, ?, ?)";
                    NSArray *aryAddParams = [NSArray arrayWithObjects:tableName,
                                             version, isUpdate, nil];
                    result = [db executeUpdate:sql withArgumentsInArray:aryAddParams];
                }
                
                if (!result) {
                    NSLog(@"%s Failed: %@", __func__, [db lastErrorMessage]);
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s except: %@", __func__, exception.description);
            }
            @finally {
                [self delayClose];
            }
        }];
    }
    
    return result;
}

- (NSArray *) getAllTbaleVersion
{
    __block NSMutableArray *aryTableNames = [[NSMutableArray alloc] init];
    if ([self open]) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            
            FMResultSet *rs;
            @try {
                NSString *sql = @"select TableVersion from DataVersionTable";
                rs = [db executeQuery:sql];
                
                while ([rs next]) {
                    
                    NSString *strName = [rs stringForColumn:@"TableVersion"];
                    [aryTableNames addObject:strName];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s except: %@", __func__, exception.description);
            }
            @finally {
                if (rs != nil) {
                    [rs close];
                }
            }
        }];
    }
    return aryTableNames;
}

- (NSArray *) getAllTableName {
    __block NSMutableArray *aryTableNames = [[NSMutableArray alloc] init];
    if ([self open]) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            
            FMResultSet *rs;
            @try {
                NSString *sql = @"select TableName from DataVersionTable";
                rs = [db executeQuery:sql];
                
                while ([rs next]) {
                    
                    NSString *strName = [rs stringForColumn:@"TableName"];
                    
                    [aryTableNames addObject:strName];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s except: %@", __func__, exception.description);
            }
            @finally {
                if (rs != nil) {
                    [rs close];
                }
            }
        }];
    }
    return aryTableNames;
}

- (NSMutableArray *) getTableIsUpdate:(NSString *)tableName {
    __block NSMutableArray *ary = [[NSMutableArray alloc] init];

    if ([self open]) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            
            FMResultSet *rs;
            @try {
                NSString *sql = [NSString stringWithFormat:@"select TableVersion,IsUpdate from DataVersionTable where TableName = '%@'", tableName];
                rs = [db executeQuery:sql];
                
                while ([rs next]) {
                    
                    NSString *strVersion = [rs stringForColumn:@"TableVersion"];
                    NSString *strIsUpdate = [rs stringForColumn:@"IsUpdate"];
                    
                    [ary addObject:strVersion];
                    [ary addObject:strIsUpdate];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%s except: %@", __func__, exception.description);
            }
            @finally {
                if (rs != nil) {
                    [rs close];
                }
            }
        }];
    }
    return ary;
}

- (void)addColumn:(NSString *)columnStr withType:(NSString *)type withOther:(NSString *)other withTableName:(NSString *)tableName
{
    __block BOOL result = NO;
    if ([self open]) {
        [self.dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback)
         {
             NSString *sql = @"";
             @try {
                 sql = [NSString stringWithFormat:@"ALTER TABLE '%@' ADD COLUMN '%@' %@ %@", tableName, columnStr, type,other];
                 result = [db executeUpdate:sql];
                 if (!result) {
                     NSLog(@"%s Failed: %@", __func__, [db lastErrorMessage]);
                 }
             }
             @catch (NSException *exception) {
                 *rollback = YES;
                 [db  rollback];
                 NSLog(@"%s except: %@", __func__, exception.description);
             }
             @finally {
                 if (!*rollback) {
                     [db  commit];
                 }
                 [self delayClose];
             }
         }];
    }
}
#pragma mark - 写入数据
#pragma mark -
//心率
- (BOOL) insertHeartRateDataModelNumber:(NSNumber *)value
{
    __block BOOL result = NO;
    HeartRateDataModel *model = [[HeartRateDataModel alloc] initHeartRateValueFromNumber:value];
    if ([self open]) {
        [self.dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback)
         {
             NSString *sql = @"";
             @try {
                 sql = @"insert into heart_rate_table(value_id, year, month, day, time, timeInterval) values(?,?,?,?,?,?)";
                 NSArray *aryAddParams = [NSArray arrayWithObjects:model.value_id, model.year, model.month, model.day, model.time, model.timeInterval, nil];
                 result = [db executeUpdate:sql withArgumentsInArray:aryAddParams];
                 if (!result) {
                     NSLog(@"%s Failed: %@", __func__, [db lastErrorMessage]);
                 }
                 else
                 {
                     [self uploadModel:model];
                 }
             }
             @catch (NSException *exception) {
                 *rollback = YES;
                 [db  rollback];
                 NSLog(@"%s except: %@", __func__, exception.description);
             }
             @finally {
                 if (!*rollback) {
                     [db  commit];
                 }
                 [self delayClose];
             }
         }];
    }
    return result;
}

//血压
- (BOOL) insertBloodPressureDataModelFromSPNumber:(NSNumber *)sp andDPNumber:(NSNumber *)dp
{
    __block BOOL result = NO;
    BloodPressureDataModel *model = [[BloodPressureDataModel alloc] initBloodPressureSPValue:sp andDPValue:dp];
    if ([self open]) {
        [self.dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback)
         {
             NSString *sql = @"";
             @try {
                 sql = @"insert into blood_pressure_table(systolic_pressure_id,diastolic_blood_id,year, month, day, time, timeInterval) values(?,?,?,?,?,?,?)";
                 NSArray *aryAddParams = [NSArray arrayWithObjects:model.systolic_pressure_id, model.diastolic_blood_id, model.year,model.month,model.day, model.time, model.timeInterval, nil];
                 
                 result = [db executeUpdate:sql withArgumentsInArray:aryAddParams];
                 if (!result) {
                     NSLog(@"%s Failed: %@", __func__, [db lastErrorMessage]);
                 }
                 else
                 {
                     [self uploadModel:model];
                 }
             }
             @catch (NSException *exception) {
                 *rollback = YES;
                 [db  rollback];
                 NSLog(@"%s except: %@", __func__, exception.description);
             }
             @finally {
                 if (!*rollback) {
                     [db  commit];
                 }
                 [self delayClose];
             }
         }];
    }
    return result;
}

//血氧
- (BOOL) insertBloodOxygenDataModelFromNumber:(NSNumber *)value
{
    __block BOOL result = NO;
    BloodOxygenDataModel *model = [[BloodOxygenDataModel alloc] initBloodOxygenValueFromNumber:value];
    if ([self open]) {
        [self.dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback)
         {
             NSString *sql = @"";
             @try {
                 sql = @"insert into blood_oxygen_table(value_id, year, month, day, time, timeInterval) values(?,?,?,?,?,?)";
                 NSArray *aryAddParams = [NSArray arrayWithObjects:model.value_id,model.year,model.month,model.day,model.time, model.timeInterval, nil];
                 result = [db executeUpdate:sql withArgumentsInArray:aryAddParams];
                 if (!result) {
                     NSLog(@"%s Failed: %@", __func__, [db lastErrorMessage]);
                 }
                 else
                 {
                     [self uploadModel:model];
                 }
             }
             @catch (NSException *exception) {
                 *rollback = YES;
                 [db  rollback];
                 NSLog(@"%s except: %@", __func__, exception.description);
             }
             @finally {
                 if (!*rollback) {
                     [db  commit];
                 }
                 [self delayClose];
             }
         }];
    }
    return result;
}

//视力
- (BOOL) insertVisionDataModelFromNumber:(NSNumber *)value
{
    __block BOOL result = NO;
    VisionDataModel *model = [[VisionDataModel alloc] initVisionValueFromNumber:value];
    
    if ([self open]) {
        [self.dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback)
         {
             NSString *sql = @"";
             @try {
                 sql = @"insert into vision_table(value_id, year, month, day, time, timeInterval) values(?,?,?,?,?,?)";
                 NSArray *aryAddParams = [NSArray arrayWithObjects:model.value_id,model.year,model.month,model.day,model.time, model.timeInterval, nil];
                 result = [db executeUpdate:sql withArgumentsInArray:aryAddParams];
                 if (!result) {
                     NSLog(@"%s Failed: %@", __func__, [db lastErrorMessage]);
                 }
                 else
                 {
                     [self uploadModel:model];
                 }
             }
             @catch (NSException *exception) {
                 *rollback = YES;
                 [db  rollback];
                 NSLog(@"%s except: %@", __func__, exception.description);
             }
             @finally {
                 if (!*rollback) {
                     [db  commit];
                 }
                 [self delayClose];
             }
         }];
    }
    return result;
}

//肺活量
- (BOOL) insertVitalCapacityDataModelFromNumber:(NSNumber *)value
{
    __block BOOL result = NO;
    VitalCapacityDataModel *model = [[VitalCapacityDataModel alloc] initVitalCapacityValueFromNumber:value];
    if ([self open]) {
        [self.dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback)
         {
             NSString *sql = @"";
             @try {
                 sql = @"insert into vital_capacity_table(value_id, year, month, day, time, timeInterval) values(?,?,?,?,?,?)";
                 NSArray *aryAddParams = [NSArray arrayWithObjects:model.value_id,model.year,model.month,model.day,model.time, model.timeInterval, nil];
                 result = [db executeUpdate:sql withArgumentsInArray:aryAddParams];
                 if (!result) {
                     NSLog(@"%s Failed: %@", __func__, [db lastErrorMessage]);
                 }
                 else
                 {
                     [self uploadModel:model];
                 }
             }
             @catch (NSException *exception) {
                 *rollback = YES;
                 [db  rollback];
                 NSLog(@"%s except: %@", __func__, exception.description);
             }
             @finally {
                 if (!*rollback) {
                     [db  commit];
                 }
                 [self delayClose];
             }
         }];
    }
    return result;
}

//血糖
- (BOOL) insertBloodSugarDataModelFromNumber:(NSNumber *)value note:(NSString *)note timeScale:(NSString *)timeScale timer:(NSString *)timerString upload:(BOOL)upload
{
    __block BOOL result = NO;
    BloodSugarDataModel *model = [[BloodSugarDataModel alloc] initBloodSugarValueFromNumber:value note:note timeScale:timeScale timer:timerString];
    if ([self open]) {
        [self.dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback)
         {
             NSString *sql = @"";
             @try {
                 sql = [NSString stringWithFormat:@"SELECT * FROM blood_sugar_table where timeInterval = %@",model.timeInterval];
                 FMResultSet *rs = [db executeQuery:sql];
                 BOOL repeat = NO;
                 if ([rs next])
                 {
                     repeat = YES;
                 }
                 if (!repeat)
                 {
                     if (!upload) {
                         sql = @"insert into blood_sugar_table(value_id, timeScale, note, year, month, day, time, timeInterval, writeInterval) values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
                         NSArray *aryAddParams = [NSArray arrayWithObjects:model.value_id, model.timeScale, model.note?model.note:@"", model.year,model.month,model.day,model.time, model.timeInterval, model.writeInterval, nil];
                         result = [db executeUpdate:sql withArgumentsInArray:aryAddParams];
                         if (!result) {
                             NSLog(@"%s Failed: %@", __func__, [db lastErrorMessage]);
                         }
                         else
                         {
                             [self uploadBloodSugarData:model];
                         }

                     }
                     else
                     {
                         sql = @"insert into blood_sugar_table(value_id, timeScale, note, year, month, day, time, timeInterval, writeInterval, upload) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                         NSArray *aryAddParams = [NSArray arrayWithObjects:model.value_id, model.timeScale, model.note?model.note:@"", model.year,model.month,model.day,model.time, model.timeInterval, model.writeInterval, @"1", nil];
                         result = [db executeUpdate:sql withArgumentsInArray:aryAddParams];
                         
                     }
                 }
            }
             @catch (NSException *exception) {
                 *rollback = YES;
                 [db  rollback];
                 NSLog(@"%s except: %@", __func__, exception.description);
             }
             @finally {
                 if (!*rollback) {
                     [db  commit];
                 }
                 [self delayClose];
             }
         }];
    }
    return result;
}


- (BOOL) insertInsulinDataModelFromNumber:(NSString *)name dose:(NSNumber *)dose note:(NSString *)note timeScale:(NSString *)timeScale upload:(BOOL)upload
{
    __block BOOL result = NO;
    InsulinDataModel *model = [[InsulinDataModel alloc] initInsulinValueFromName: name dose:dose note:note timer:timeScale];
    if ([self open]) {
        [self.dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback)
         {
             NSString *sql = @"";
             @try {
                 sql = [NSString stringWithFormat:@"SELECT * FROM insulin_table where timeInterval = %@",model.timeInterval];
                 FMResultSet *rs = [db executeQuery:sql];
                 BOOL repeat = NO;
                 if ([rs next])
                 {
                     repeat = YES;
                 }
                 if (!repeat)
                 {
                     
                     if (!upload)
                     {
                         sql = @"insert into insulin_table(name, dose, note, year, month, day, time, timeInterval, writeInterval) values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
                         NSArray *aryAddParams = [NSArray arrayWithObjects:model.name, model.dose, model.note?model.note:@"", model.year,model.month,model.day,model.time, model.timeInterval, model.writeInterval, nil];
                         result = [db executeUpdate:sql withArgumentsInArray:aryAddParams];
                         if (!result) {
                             NSLog(@"%s Failed: %@", __func__, [db lastErrorMessage]);
                         }
                         else
                         {
                             [self uploadInsulinData:model];
                         }
                     }
                     else
                     {
                         sql = @"insert into insulin_table(name, dose, note, year, month, day, time, timeInterval, writeInterval, upload) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                         NSArray *aryAddParams = [NSArray arrayWithObjects:model.name, model.dose, model.note?model.note:@"", model.year,model.month,model.day,model.time, model.timeInterval, model.writeInterval, @"1", nil];
                         result = [db executeUpdate:sql withArgumentsInArray:aryAddParams];
                     }

                 }
             }
             @catch (NSException *exception) {
                 *rollback = YES;
                 [db  rollback];
                 NSLog(@"%s except: %@", __func__, exception.description);
             }
             @finally {
                 if (!*rollback) {
                     [db  commit];
                 }
                 [self delayClose];
             }
         }];
    }
    return result;
}
#pragma mark - 读取数据
#pragma mark -
/*
 *  @brief  读取心率数据
 */
- (NSMutableArray *) getHeartRateDataModels:(EDataTimePeriod)status forDate:(NSDate *)selectedDate
{
    __block NSMutableArray *aryDatas = [[NSMutableArray alloc] init];
    if ([self open]) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            if ([self open]) {
                FMResultSet *rs;
                @try {
                    NSString *sql = @"";
                    if (!selectedDate) {
                        NSTimeInterval interval = [self getTimePeriod:status];
                        sql = [NSString stringWithFormat:@"SELECT * FROM `heart_rate_table` where timeInterval > %f",interval];
                    }
                    else
                    {
                        NSTimeInterval starInterval = [self starTimeIntervalFromDate:selectedDate];
                        NSTimeInterval endInterval = [self endTimeIntervalFromDate:selectedDate];
                        sql = [NSString stringWithFormat:@"SELECT * FROM `heart_rate_table` where %f < timeInterval AND timeInterval < %f",starInterval,endInterval];
                    }

                    rs = [db executeQuery:sql];

                    while ([rs next]) {
                        HeartRateDataModel *obj = [[HeartRateDataModel alloc] init];
                        obj.value_id = [NSNumber numberWithInteger:[rs intForColumn:@"value_id"]];
                        obj.year = [rs stringForColumn:@"year"];
                        obj.month = [rs stringForColumn:@"month"];
                        obj.day = [rs stringForColumn:@"day"];
                        obj.time = [rs stringForColumn:@"time"];
                        obj.upload = [rs stringForColumn:@"upload"];
                        obj.timeInterval = [NSNumber numberWithDouble:[rs doubleForColumn:@"timeInterval"]];
                        [aryDatas addObject:obj];
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"%s except: %@", __func__, exception.description);
                }
                @finally {
                    [self delayClose];
                }
            }
        }];
    }
    
    return aryDatas;
}

/*
 *  @brief  读取血压数据
 */
- (NSMutableArray *) getBloodPressureDataModels:(EDataTimePeriod)status forDate:(NSDate *)selectedDate
{
    __block NSMutableArray *aryDatas = [[NSMutableArray alloc] init];
    if ([self open]) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            if ([self open]) {
                FMResultSet *rs;
                @try {
                    NSString *sql = @"";
                    if(!selectedDate)
                    {
                        NSTimeInterval interval = [self getTimePeriod:status];
                        sql = [NSString stringWithFormat:@"SELECT * FROM `blood_pressure_table` where timeInterval > %f",interval];

                    }
                    else
                    {
                        NSTimeInterval starInterval = [self starTimeIntervalFromDate:selectedDate];
                        NSTimeInterval endInterval = [self endTimeIntervalFromDate:selectedDate];
                        sql = [NSString stringWithFormat:@"SELECT * FROM `blood_pressure_table` where %f < timeInterval AND timeInterval < %f",starInterval,endInterval];
                    }
                    
                    rs = [db executeQuery:sql];
                    
                    while ([rs next]) {
                        BloodPressureDataModel *obj = [[BloodPressureDataModel alloc] init];
                        obj.systolic_pressure_id = [NSNumber numberWithInteger:[rs intForColumn:@"systolic_pressure_id"]];
                        obj.diastolic_blood_id = [NSNumber numberWithInteger:[rs intForColumn:@"diastolic_blood_id"]];
                        obj.year = [rs stringForColumn:@"year"];
                        obj.month = [rs stringForColumn:@"month"];
                        obj.day = [rs stringForColumn:@"day"];
                        obj.time = [rs stringForColumn:@"time"];
                        obj.upload = [rs stringForColumn:@"upload"];
                        obj.timeInterval = [NSNumber numberWithDouble:[rs doubleForColumn:@"timeInterval"]];
                        [aryDatas addObject:obj];
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"%s except: %@", __func__, exception.description);
                }
                @finally {
                    [self delayClose];
                }
            }
        }];
    }
    
    return aryDatas;
}

/*
 *  @brief  读取血氧数据
 */
- (NSMutableArray *) getBloodOxygenDataModels:(EDataTimePeriod)status forDate:(NSDate *)selectedDate
{
    __block NSMutableArray *aryDatas = [[NSMutableArray alloc] init];
    if ([self open]) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            if ([self open]) {
                FMResultSet *rs;
                @try {
                    NSString *sql = @"";
                    if(!selectedDate)
                    {
                        NSTimeInterval interval = [self getTimePeriod:status];
                        sql = [NSString stringWithFormat:@"SELECT * FROM `blood_oxygen_table` where timeInterval > %f",interval];
                        
                    }
                    else
                    {
                        NSTimeInterval starInterval = [self starTimeIntervalFromDate:selectedDate];
                        NSTimeInterval endInterval = [self endTimeIntervalFromDate:selectedDate];
                        sql = [NSString stringWithFormat:@"SELECT * FROM `blood_oxygen_table` where %f < timeInterval AND timeInterval < %f",starInterval,endInterval];
                    }
                    
                    rs = [db executeQuery:sql];
                    
                    while ([rs next]) {
                        BloodOxygenDataModel *obj = [[BloodOxygenDataModel alloc] init];
                        obj.value_id = [NSNumber numberWithInteger:[rs intForColumn:@"value_id"]];
                        obj.year = [rs stringForColumn:@"year"];
                        obj.month = [rs stringForColumn:@"month"];
                        obj.day = [rs stringForColumn:@"day"];
                        obj.time = [rs stringForColumn:@"time"];
                        obj.upload = [rs stringForColumn:@"upload"];
                        obj.timeInterval = [NSNumber numberWithDouble:[rs doubleForColumn:@"timeInterval"]];
                        [aryDatas addObject:obj];
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"%s except: %@", __func__, exception.description);
                }
                @finally {
                    [self delayClose];
                }
            }
        }];
    }
    return aryDatas;
}

/*
 *  @brief  读取肺活量数据
 */
- (NSMutableArray *) getVitalCapacityDataModels:(EDataTimePeriod)status forDate:(NSDate *)selectedDate
{
    __block NSMutableArray *aryDatas = [[NSMutableArray alloc] init];
    if ([self open]) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            if ([self open]) {
                FMResultSet *rs;
                @try {
                    NSString *sql = @"";
                    if(!selectedDate)
                    {
                        NSTimeInterval interval = [self getTimePeriod:status];
                       sql = [NSString stringWithFormat:@"SELECT * FROM `vital_capacity_table` where timeInterval > %f",interval];
                        
                    }
                    else
                    {
                        NSTimeInterval starInterval = [self starTimeIntervalFromDate:selectedDate];
                        NSTimeInterval endInterval = [self endTimeIntervalFromDate:selectedDate];
                        sql = [NSString stringWithFormat:@"SELECT * FROM `vital_capacity_table` where %f < timeInterval AND timeInterval < %f",starInterval,endInterval];
                    }
                    rs = [db executeQuery:sql];
                    
                    while ([rs next]) {
                        VitalCapacityDataModel *obj = [[VitalCapacityDataModel alloc] init];
                        obj.value_id = [NSNumber numberWithInteger:[rs intForColumn:@"value_id"]];
                        obj.year = [rs stringForColumn:@"year"];
                        obj.month = [rs stringForColumn:@"month"];
                        obj.day = [rs stringForColumn:@"day"];
                        obj.time = [rs stringForColumn:@"time"];
                        obj.upload = [rs stringForColumn:@"upload"];
                        obj.timeInterval = [NSNumber numberWithDouble:[rs doubleForColumn:@"timeInterval"]];
                        [aryDatas addObject:obj];
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"%s except: %@", __func__, exception.description);
                }
                @finally {
                    [self delayClose];
                }
            }
        }];
    }
    return aryDatas;
}

/*
 *  @brief  获取视力数据
 */
- (NSMutableArray *) getVisionDataModels:(EDataTimePeriod)status forDate:(NSDate *)selectedDate
{
    __block NSMutableArray *aryDatas = [[NSMutableArray alloc] init];
    if ([self open]) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            if ([self open]) {
                FMResultSet *rs;
                @try {
                    NSString *sql = @"";
                    if(!selectedDate)
                    {
                        NSTimeInterval interval = [self getTimePeriod:status];
                        sql = [NSString stringWithFormat:@"SELECT * FROM `vision_table` where timeInterval > %f",interval];
                    }
                    else
                    {
                        NSTimeInterval starInterval = [self starTimeIntervalFromDate:selectedDate];
                        NSTimeInterval endInterval = [self endTimeIntervalFromDate:selectedDate];
                        sql = [NSString stringWithFormat:@"SELECT * FROM `vision_table` where %f < timeInterval AND timeInterval < %f",starInterval,endInterval];
                    }
                    
                    rs = [db executeQuery:sql];
                    while ([rs next]) {
                        VisionDataModel *obj = [[VisionDataModel alloc] init];
                        obj.value_id = [NSNumber numberWithFloat:[rs doubleForColumn:@"value_id"]];
                        obj.year = [rs stringForColumn:@"year"];
                        obj.month = [rs stringForColumn:@"month"];
                        obj.day = [rs stringForColumn:@"day"];
                        obj.time = [rs stringForColumn:@"time"];
                        obj.upload = [rs stringForColumn:@"upload"];
                        obj.timeInterval = [NSNumber numberWithDouble:[rs doubleForColumn:@"timeInterval"]];
                        [aryDatas addObject:obj];
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"%s except: %@", __func__, exception.description);
                }
                @finally {
                    [self delayClose];
                }
            }
        }];
    }
    return aryDatas;
}


- (NSMutableArray *)getBloodSugarDataModels:(EDataTimePeriod)status forDate:(NSDate *)selectedDate
{
    __block NSMutableArray *aryDatas = [[NSMutableArray alloc] init];
    if ([self open]) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            if ([self open]) {
                FMResultSet *rs;
                @try {
                    NSString *sql = @"";
                    if(!selectedDate)
                    {
                        NSTimeInterval interval = [self getTimePeriod:status];
                        sql = [NSString stringWithFormat:@"SELECT * FROM `blood_sugar_table` where timeInterval > %f",interval];
                    }
                    else
                    {
                        NSTimeInterval starInterval = [self starTimeIntervalFromDate:selectedDate];
                        NSTimeInterval endInterval = [self endTimeIntervalFromDate:selectedDate];
                        sql = [NSString stringWithFormat:@"SELECT * FROM `blood_sugar_table` where %f < timeInterval AND timeInterval < %f",starInterval,endInterval];
                    }
                    
                    rs = [db executeQuery:sql];
                    while ([rs next]) {
                        BloodSugarDataModel *obj = [[BloodSugarDataModel alloc] init];
                        obj.value_id = [NSNumber numberWithFloat:[rs doubleForColumn:@"value_id"]];
                        obj.timeScale = [rs stringForColumn:@"timeScale"];
                        obj.note = [rs stringForColumn:@"note"];
                        obj.year = [rs stringForColumn:@"year"];
                        obj.month = [rs stringForColumn:@"month"];
                        obj.day = [rs stringForColumn:@"day"];
                        obj.time = [rs stringForColumn:@"time"];
                        obj.upload = [rs stringForColumn:@"upload"];
                        obj.timeInterval = [NSNumber numberWithDouble:[rs doubleForColumn:@"timeInterval"]];
                        obj.writeInterval = [NSNumber numberWithDouble:[rs doubleForColumn:@"writeInterval"]];
                        [aryDatas addObject:obj];
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"%s except: %@", __func__, exception.description);
                }
                @finally {
                    [self delayClose];
                }
            }
        }];
    }
    return aryDatas;
}

- (NSMutableArray *)getInsulinDataModels
{
    __block NSMutableArray *aryDatas = [[NSMutableArray alloc] init];
    if ([self open]) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            if ([self open]) {
                FMResultSet *rs;
                @try {
                    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM `insulin_table` where timeInterval > %f",NSTimeIntervalSince1970];
                    rs = [db executeQuery:sql];
                    while ([rs next]) {
                        InsulinDataModel *obj = [[InsulinDataModel alloc] init];
                        obj.name = [rs stringForColumn:@"name"];
                        obj.dose = [NSNumber numberWithFloat:[rs doubleForColumn:@"dose"]];
                        obj.note = [rs stringForColumn:@"note"];
                        obj.year = [rs stringForColumn:@"year"];
                        obj.month = [rs stringForColumn:@"month"];
                        obj.day = [rs stringForColumn:@"day"];
                        obj.time = [rs stringForColumn:@"time"];
                        obj.upload = [rs stringForColumn:@"upload"];
                        obj.timeInterval = [NSNumber numberWithDouble:[rs doubleForColumn:@"timeInterval"]];
                        obj.writeInterval = [NSNumber numberWithDouble:[rs doubleForColumn:@"writeInterval"]];
                        [aryDatas addObject:obj];
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"%s except: %@", __func__, exception.description);
                }
                @finally {
                    [self delayClose];
                }
            }
        }];
    }
    return aryDatas;
}


- (id)getLastDataModelFromeType:(EDataType )type
{
    id peopleClass;
    __block id model;
    NSString *tableName = @"";
    switch (type) {
        case 0:
        {
            //心率
            peopleClass = objc_getClass("HeartRateDataModel");
            tableName = @"heart_rate_table";
        }
            break;
        case 1:
        {
            peopleClass = objc_getClass("BloodPressureDataModel");
            tableName = @"blood_pressure_table";

        }
            break;
        case 3:
        {
            peopleClass = objc_getClass("BloodOxygenDataModel");
            tableName = @"blood_oxygen_table";

        }
            break;
        case 4:
        {
            peopleClass = objc_getClass("VitalCapacityDataModel");
            tableName = @"vital_capacity_table";
        }
            break;
        case 5:
        {
            peopleClass = objc_getClass("VisionDataModel");
            tableName = @"vision_table";
        }
            break;
        case 6:
        {
            peopleClass = objc_getClass("BloodSugarDataModel");
            tableName = @"blood_sugar_table";
        }
            break;
            
        default:
            break;
    }
    if ([self open]) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            if ([self open]) {
                FMResultSet *rs;
                @try {
                    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM `%@` WHERE rowid = (SELECT max(rowid) FROM `%@`)", tableName, tableName];
                    rs = [db executeQuery:sql];
                    if ([db hasOpenResultSets])
                    {
                        while ([rs next])
                        {
                            unsigned int countProperty;
                            objc_property_t *propertyList = class_copyPropertyList(peopleClass, &countProperty);
                            model= [[peopleClass alloc] init];
                            for (int j = 0; j < countProperty; j++) {
                                const char *propertyname = property_getName(propertyList[j]);
                                NSString *name = [NSString stringWithFormat:@"%s",propertyname];
                                [model setValue:[rs stringForColumn:name] forKey:[NSString stringWithUTF8String:propertyname]];
                            }
                        }
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"%s except: %@", __func__, exception.description);
                }
                @finally {
                    [self delayClose];
                }
            }
        }];
    }
    return model;
}

#pragma mark - 处理时间周期
- (NSTimeInterval)getTimePeriod:(EDataTimePeriod)status
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
        switch (status) {
            case EDataTimePeriodStatusDay:
                [comps setDay:0];
                break;
            case EDataTimePeriodStatusWeek:
                [comps setDay:-6];
                break;
            case EDataTimePeriodStatusMonth:
                [comps setMonth:-1];
                break;
            case EDataTimePeriodStatusYear:
                [comps setYear:-1];
                break;
            case EDataTimePeriodStatusAll:
                return NSTimeIntervalSince1970;
                break;
            default:
                break;
        }
    NSDate *newdate = [calendar dateByAddingComponents:comps toDate:date options:0];
    NSDate *zeroDate = [calendar startOfDayForDate:newdate];
    NSTimeInterval intervals = [zeroDate timeIntervalSince1970];
    return intervals;
}

- (NSTimeInterval)starTimeIntervalFromDate:(NSDate*)date
{
   NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDate *starDate = [calendar startOfDayForDate:date];
    NSTimeInterval starInterval = [starDate timeIntervalSince1970];
    return starInterval;
}

- (NSTimeInterval)endTimeIntervalFromDate:(NSDate*)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    NSDate *newdate = [calendar dateByAddingComponents:comps toDate:date options:0];
    NSDate *endDate = [calendar startOfDayForDate:newdate];
    NSTimeInterval endInterval = [endDate timeIntervalSince1970];
    return endInterval;
}

#pragma mark - 查找需要上传的数据
- (void)uploadHealthData
{
    if (LOGIN_STATION&&LOCAL_TOKEN)
    {
        NSArray *aryAllTableNames = [self getAllTableName];
        for (int i = 0; i < [aryAllTableNames count]; i++) {
            [self getNotUploadDataFromTable:aryAllTableNames[i]];
        }
        double newValue = 0.f;
//        newValue = [self getUserHealthDataMaxTimeInterval];
        [self requestGetUserHealthData:newValue];
        [self getBloodSugarRequest];
        [self getInsulinRequest];
    }
}

- (void)getNotUploadDataFromTable:(NSString *)tableName
{
    NSArray *array = @[@"heart_rate_table", @"blood_pressure_table", @"blood_oxygen_table", @"vision_table", @"vital_capacity_table", @"health_step_table",@"blood_sugar_table", @"insulin_table"];
    NSInteger index = [array indexOfObject:tableName];
    __block NSMutableArray *aryDatas = [NSMutableArray new];
    if ([self open]) {
        [self.dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback)
         {
             FMResultSet *rs;
             @try {
                 NSString *sql = [NSString stringWithFormat:@"SELECT * FROM `%@` where upload < 1",tableName];
                 rs = [db executeQuery:sql];
                 while ([rs next]) {
                     switch (index) {
                         case 0:
                         {
                             HeartRateDataModel *obj = [[HeartRateDataModel alloc] init];
                             obj.value_id = [NSNumber numberWithInteger:[rs intForColumn:@"value_id"]];
                             obj.year = [rs stringForColumn:@"year"];
                             obj.month = [rs stringForColumn:@"month"];
                             obj.day = [rs stringForColumn:@"day"];
                             obj.time = [rs stringForColumn:@"time"];
                             obj.upload = [rs stringForColumn:@"upload"];
                             obj.timeInterval = [NSNumber numberWithDouble:[rs doubleForColumn:@"timeInterval"]];
                             [aryDatas addObject:obj];
                         }
                             break;
                         case 1:
                         {
                             BloodPressureDataModel *obj = [[BloodPressureDataModel alloc] init];
                             obj.systolic_pressure_id = [NSNumber numberWithInteger:[rs intForColumn:@"systolic_pressure_id"]];
                             obj.diastolic_blood_id = [NSNumber numberWithInteger:[rs intForColumn:@"diastolic_blood_id"]];
                             obj.year = [rs stringForColumn:@"year"];
                             obj.month = [rs stringForColumn:@"month"];
                             obj.day = [rs stringForColumn:@"day"];
                             obj.time = [rs stringForColumn:@"time"];
                             obj.upload = [rs stringForColumn:@"upload"];
                             obj.timeInterval = [NSNumber numberWithDouble:[rs doubleForColumn:@"timeInterval"]];
                             [aryDatas addObject:obj];
                         }
                             break;
                         case 2:
                         {
                             BloodOxygenDataModel *obj = [[BloodOxygenDataModel alloc] init];
                             obj.value_id = [NSNumber numberWithInteger:[rs intForColumn:@"value_id"]];
                             obj.year = [rs stringForColumn:@"year"];
                             obj.month = [rs stringForColumn:@"month"];
                             obj.day = [rs stringForColumn:@"day"];
                             obj.time = [rs stringForColumn:@"time"];
                             obj.upload = [rs stringForColumn:@"upload"];
                             obj.timeInterval = [NSNumber numberWithDouble:[rs doubleForColumn:@"timeInterval"]];
                             [aryDatas addObject:obj];
                         }
                             break;
                         case 3:
                         {
                             VisionDataModel *obj = [[VisionDataModel alloc] init];
                             obj.value_id = [NSNumber numberWithFloat:[rs doubleForColumn:@"value_id"]];
                             obj.year = [rs stringForColumn:@"year"];
                             obj.month = [rs stringForColumn:@"month"];
                             obj.day = [rs stringForColumn:@"day"];
                             obj.time = [rs stringForColumn:@"time"];
                             obj.upload = [rs stringForColumn:@"upload"];
                             obj.timeInterval = [NSNumber numberWithDouble:[rs doubleForColumn:@"timeInterval"]];
                             [aryDatas addObject:obj];
                         }
                             break;
                         case 4:
                         {
                             VitalCapacityDataModel *obj = [[VitalCapacityDataModel alloc] init];
                             obj.value_id = [NSNumber numberWithInteger:[rs intForColumn:@"value_id"]];
                             obj.year = [rs stringForColumn:@"year"];
                             obj.month = [rs stringForColumn:@"month"];
                             obj.day = [rs stringForColumn:@"day"];
                             obj.time = [rs stringForColumn:@"time"];
                             obj.upload = [rs stringForColumn:@"upload"];
                             obj.timeInterval = [NSNumber numberWithDouble:[rs doubleForColumn:@"timeInterval"]];
                             [aryDatas addObject:obj];
                         }
                             break;
                         case 6:
                         {
                             BloodSugarDataModel *obj = [[BloodSugarDataModel alloc] init];
                             obj.value_id = [NSNumber numberWithFloat:[rs doubleForColumn:@"value_id"]];
                             obj.timeScale = [rs stringForColumn:@"timeScale"];
                             obj.note = [rs stringForColumn:@"note"];
                             obj.year = [rs stringForColumn:@"year"];
                             obj.month = [rs stringForColumn:@"month"];
                             obj.day = [rs stringForColumn:@"day"];
                             obj.time = [rs stringForColumn:@"time"];
                             obj.upload = [rs stringForColumn:@"upload"];
                             obj.timeInterval = [NSNumber numberWithDouble:[rs doubleForColumn:@"timeInterval"]];
                             obj.writeInterval = [NSNumber numberWithDouble:[rs doubleForColumn:@"writeInterval"]];
                             [aryDatas addObject:obj];
                         }
                             break;
                         case 7:
                         {
                             InsulinDataModel *obj = [[InsulinDataModel alloc] init];
                             obj.name = [rs stringForColumn:@"name"];
                             obj.dose = [NSNumber numberWithFloat:[rs doubleForColumn:@"dose"]];
                             obj.note = [rs stringForColumn:@"note"];
                             obj.year = [rs stringForColumn:@"year"];
                             obj.month = [rs stringForColumn:@"month"];
                             obj.day = [rs stringForColumn:@"day"];
                             obj.time = [rs stringForColumn:@"time"];
                             obj.upload = [rs stringForColumn:@"upload"];
                             obj.timeInterval = [NSNumber numberWithDouble:[rs doubleForColumn:@"timeInterval"]];
                             obj.writeInterval = [NSNumber numberWithDouble:[rs doubleForColumn:@"writeInterval"]];
                             [aryDatas addObject:obj];
                         }
                             break;
                             
                         default:
                             break;
                     }
                 }

             }
             @catch (NSException *exception) {
                 *rollback = YES;
                 [db  rollback];
                 NSLog(@"%s except: %@", __func__, exception.description);
             }
             @finally {
                 if (!*rollback) {
                     [db  commit];
                 }
                 [self delayClose];
             }
         }];
    }
    for (int i = 0; i < [aryDatas count]; i ++)
    {
        id model = aryDatas[i];
        if ([model isKindOfClass:[BloodSugarDataModel class]]) {
            BloodSugarDataModel *obj = (BloodSugarDataModel *)model;
            [self uploadBloodSugarData:obj];
        }
        else if ([model isKindOfClass:[InsulinDataModel class]])
        {
            InsulinDataModel *obj = (InsulinDataModel *)model;
            [self uploadInsulinData:obj];
        }
        else
        {
            [self uploadModel:model];
        }
    }
}

#pragma mark -上传数据
- (void)uploadModel:(id)data
{
    if (!LOGIN_STATION&&!LOCAL_TOKEN)
    {
        return;
    }
//    NSArray *typeArray = @[@"心率测量",@"血压测量",@"视力测量",@"肺活量测量",@"血氧测量",@"健康计步"];
    NSInteger type = 0;
    NSString *TimeStamp = @"";
    NSNumber *timeNumber;
    NSNumber *value;
    NSNumber *BloodValue;
    if ([data isKindOfClass:[HeartRateDataModel class]])
    {
        HeartRateDataModel *model = (HeartRateDataModel *)data;
        timeNumber = model.timeInterval;
        value = model.value_id;
        type = 1;
    }
    else if ([data isKindOfClass:[BloodPressureDataModel class]])
    {
        BloodPressureDataModel *model = (BloodPressureDataModel *)data;
        timeNumber = model.timeInterval;
        value = model.systolic_pressure_id;
        BloodValue = model.diastolic_blood_id;
        type = 2;
    }
    else if ([data isKindOfClass:[BloodOxygenDataModel class]])
    {
        BloodOxygenDataModel *model = (BloodOxygenDataModel *)data;
        timeNumber = model.timeInterval;
        value = model.value_id;
        type = 5;
    }
    else if ([data isKindOfClass:[VisionDataModel class]])
    {
        VisionDataModel *model = (VisionDataModel *)data;
        timeNumber = model.timeInterval;
        value = model.value_id;
        type = 3;
    }
    else if ([data isKindOfClass:[VitalCapacityDataModel class]])
    {
        VitalCapacityDataModel *model = (VitalCapacityDataModel *)data;
        timeNumber = model.timeInterval;
        value = model.value_id;
        type = 4;
    }
    else
    {
        return;
    }
    double timeFloat = [timeNumber doubleValue]*1000;
    
    TimeStamp = [NSString stringWithFormat:@"%.f",timeFloat]; //时间戳
    NSString *typeStr = [NSString stringWithFormat:@"%li", type]; //类型
    NSString *BloodStr = [NSString stringWithFormat:@"%@",BloodValue];//血压
    if (type != 2) {
        BloodStr = @"";
    }
    NSString *ResultValue = [NSString stringWithFormat:@"%@",value];//值
    
    NSDictionary *dic = @{@"OBJType":typeStr, @"TimeStamp":TimeStamp, @"ResultValue":ResultValue, @"BloodValue":BloodStr};
    [self requestUpload:dic type:type timer:timeNumber];
}

- (void) requestUpload:(NSDictionary *)dic type:(NSInteger)type timer:(NSNumber *)timeNumber
{
    [HTTPTool requestWithURLString:@"/api/HealthManager/InsertHealthResult" parameters:dic showStatus:NO type:kPOST success:^(id responseObject) {
        NSString *code = [responseObject objectForKey:@"ResultCode"];
        if ([code integerValue] == 0) {
            [self updateDataUploadStatusFromTable:type timeInterval:timeNumber];
        }
        else
        {
            NSLog(@"22222");
        }
    } failure:^(NSError *error) {
        NSLog(@"1111");
    }];
}

-(void)updateDataUploadStatusFromTable:(NSInteger)type timeInterval:(NSNumber *)timeNumber
{
    NSArray *typeArray = @[@"heart_rate_table", @"blood_pressure_table",@"vision_table",  @"vital_capacity_table", @"blood_oxygen_table",@"health_step_table"];
    NSString *typeStr = [typeArray objectAtIndex:type-1];
    __block BOOL result;
    if ([self open]) {
        [self.dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback)
         {
             @try {
                 NSString *sql = [NSString stringWithFormat:@"update %@ set upload = 1 WHERE timeInterval = %@",typeStr,timeNumber];
                 result = [db executeUpdate:sql];
                 if (!result) {
                     NSLog(@"%s Failed: %@", __func__, [db lastErrorMessage]);
                 }
             }
             @catch (NSException *exception) {
                 *rollback = YES;
                 [db  rollback];
                 NSLog(@"%s except: %@", __func__, exception.description);
             }
             @finally {
                 if (!*rollback) {
                     [db  commit];
                 }
                 [self delayClose];
             }
         }];
    }

}

#pragma mark - 获取健康数据
- (double)getUserHealthDataMaxTimeInterval
{
    NSArray *typeArray = @[@"heart_rate_table", @"blood_pressure_table",@"vision_table", @"vital_capacity_table", @"blood_oxygen_table", @"health_step_table"];
    double max =0.f;
    for (int i = 0; i< [typeArray count]; i++)
    {
        max = MAX(max, [self getMaxTimeIntervalFromTableName:typeArray[i]]);
    }
    return max;
}

- (double)getMaxTimeIntervalFromTableName:(NSString *)name
{
    __block double max = 0;
    if ([self open]) {
        [self.dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback)
         {
             FMResultSet *rs;
             @try {
                 NSString *sql = [NSString stringWithFormat:@"SELECT * FROM `%@` where timeInterval > 0",name];
                 rs = [db executeQuery:sql];
                 while ([rs next])
                 {
                     double newNumber = [rs doubleForColumn:@"timeInterval"];
                     max = MAX(max, newNumber);
                 }
             }
             @catch (NSException *exception) {
                 *rollback = YES;
                 [db  rollback];
                 NSLog(@"%s except: %@", __func__, exception.description);
             }
             @finally {
                 if (!*rollback) {
                     [db  commit];
                 }
                 [self delayClose];
             }
         }];
    }
    return max;
}

- (void)requestGetUserHealthData:(double)max
{
//    NSString *timeStemp = @"0";
//    if (max >100000) {
//        timeStemp = [NSString stringWithFormat:@"%.0f",max*1000];
//    }
//因为测试环境 传时间戳还是会返回0数据 所以传0返回全部
    NSString *urlStr = [NSString stringWithFormat:@"/api/HealthManager/GetHealthResultList?timeStemp=%@&pageIndex=0&pageSize=1000",@"0"];
    [HTTPTool requestWithURLString:urlStr parameters:nil showStatus:NO type:kGET success:^(id responseObject) {
        NSString *code = [responseObject objectForKey:@"ResultCode"];
        if ([code integerValue] == 0) {
            NSArray *array = responseObject[@"Data"];
            NSArray *typeArray = @[@"heart_rate_table", @"blood_pressure_table", @"vision_table", @"vital_capacity_table", @"blood_oxygen_table"];
            for (int i = 0; i< [typeArray count]; i++)
            {
                [self deleteTableName:typeArray[i]];
            }
            [self addTable];
            if ([array isKindOfClass: [NSArray class]]) {
                for (int i = 0; i < [array count]; i ++) {
                    RequestHealthData *model = [RequestHealthData mj_objectWithKeyValues:array[i]];
                    [self insertDataModelFromServer:model];
                }
            }
        }
    } failure:^(NSError *error) {
    }];
}


- (BOOL) insertDataModelFromServer:(RequestHealthData *)model
{
    __block BOOL result = NO;
    NSArray *typeArray = @[@"heart_rate_table", @"blood_pressure_table", @"vision_table", @"vital_capacity_table", @"blood_oxygen_table", @"health_step_table"];
    NSString *tableName = typeArray[[model.OBJType integerValue]-1];
    double value = [model.TimeStamp doubleValue]/1000;
    NSNumber *number = [NSNumber numberWithDouble:value];
    if ([self open]) {
        [self.dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback)
         {
             NSString *sql = @"";
             FMResultSet *rs;
             @try {
                 sql = [NSString stringWithFormat:@"SELECT * FROM `%@` where timeInterval = %@",tableName,number];
                 rs = [db executeQuery:sql];
                 BOOL repeat = NO;
                 if ([rs next]) {
                     repeat = YES;
                 }
                 if (!repeat)
                 {
                     NSDate *date = [NSDate dateWithTimeIntervalSince1970:value];
                     NSTimeZone *zone = [NSTimeZone systemTimeZone];
                     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                     [formatter setTimeZone:zone];
                     [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
                     NSString *strTime = [formatter stringFromDate:date];
                     NSArray *array = [strTime componentsSeparatedByString:@"-"];
                     NSString * _year = array[0];
                     NSString *_month = array[1];
                     NSString *_day = array[2];
                     NSString *_time = array[3];
                     if ([model.OBJType isEqualToString: @"2"]) {
                         sql = [NSString stringWithFormat:@"insert into %@(systolic_pressure_id,diastolic_blood_id,year, month, day, time, timeInterval,upload) values(?,?,?,?,?,?,?,?)",tableName];
                         NSArray *aryAddParams = [NSArray arrayWithObjects:model.ResultValue,model.BloodValue,_year,_month,_day,_time,number,@"1", nil];
                         result = [db executeUpdate:sql withArgumentsInArray:aryAddParams];
                     }
                     else
                     {
                         sql = [NSString stringWithFormat:@"insert into %@(value_id,year, month, day, time, timeInterval,upload) values(?,?,?,?,?,?,?)",tableName];
                         NSArray *aryAddParams = [NSArray arrayWithObjects:model.ResultValue,_year,_month,_day,_time,number,@"1", nil];
                         result = [db executeUpdate:sql withArgumentsInArray:aryAddParams];
                     }
                     if (!result) {
                         NSLog(@"%s Failed: %@", __func__, [db lastErrorMessage]);
                     }
                 }
             }
             @catch (NSException *exception) {
                 *rollback = YES;
                 [db  rollback];
                 NSLog(@"%s except: %@", __func__, exception.description);
             }
             @finally {
                 if (!*rollback) {
                     [db  commit];
                 }
                 [self delayClose];
             }
         }];
    }
    return result;
}

#pragma mark - 上传血糖 胰岛素
- (void)uploadBloodSugarData:(BloodSugarDataModel *)model
{
    if (!LOGIN_STATION&&!LOCAL_TOKEN)
    {
        return;
    }
    double timeFloat = [model.timeInterval doubleValue]*1000;
    NSString *TimeStep = [NSString stringWithFormat:@"%.f",timeFloat]; //时间戳
    NSInteger type = [model.timeScale integerValue];
    NSString *Type = [NSString stringWithFormat:@"%li", type+1]; //类型
    NSString *Value = [NSString stringWithFormat:@"%@", model.value_id];
    NSString *Note = @"";
    if (model.note.length > 0) {
        Note = [NSString stringWithFormat:@"%@", model.note];
    }
    NSDictionary *dic = @{@"Value":Value, @"Type":Type, @"Note":Note, @"TimeStep":TimeStep};
    [HTTPTool requestWithURLString:@"/api/HealthManager/InsertBloodSugar" parameters:dic showStatus:NO type:kPOST success:^(id responseObject) {
        NSString *code = [responseObject objectForKey:@"ResultCode"];
        if ([code integerValue] == 0) {
            [self setBloodSugarUploadState: model];
        }
        else
        {
            NSLog(@"22222");
        }
    } failure:^(NSError *error) {
        NSLog(@"1111");
    }];
}

-(BOOL)setBloodSugarUploadState:(BloodSugarDataModel*)model
{
    __block BOOL result = NO;
    if ([self open]) {
        [self.dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback)
         {
             @try {
                 NSString *sql = [NSString stringWithFormat:@"update `blood_sugar_table` set upload = 1 WHERE timeInterval = %@", model.timeInterval];
                 result = [db executeUpdate:sql];
                 if (!result) {
                     NSLog(@"%s Failed: %@", __func__, [db lastErrorMessage]);
                 }
             }
             @catch (NSException *exception) {
                 *rollback = YES;
                 [db  rollback];
                 NSLog(@"%s except: %@", __func__, exception.description);
             }
             @finally {
                 if (!*rollback) {
                     [db  commit];
                 }
                 [self delayClose];
             }
         }];
    }
    return result;
}

//上传胰岛素
- (void)uploadInsulinData:(InsulinDataModel *)model
{
    if (!LOGIN_STATION&&!LOCAL_TOKEN)
    {
        return;
    }
    CGFloat timeFloat = [model.timeInterval floatValue]*1000;
    NSString *MedicineTime = [NSString stringWithFormat:@"%.f",timeFloat]; //时间戳
    CGFloat dose = [model.dose doubleValue];
    NSString *Dose = [NSString stringWithFormat:@"%.f", dose]; //类型
    NSString *IsletName = [NSString stringWithFormat:@"%@", model.name];
    NSString *Note = @"";
    if (model.note.length > 0) {
        Note = [NSString stringWithFormat:@"%@", model.note];
    }
    NSDictionary *dic = @{@"IsletName":IsletName, @"Dose":Dose, @"Note":Note, @"MedicineTime":MedicineTime};
    [HTTPTool requestWithURLString:@"/api/HealthManager/InsertIsLet" parameters:dic showStatus:NO type:kPOST success:^(id responseObject) {
        NSString *code = [responseObject objectForKey:@"ResultCode"];
        if ([code integerValue] == 0) {
            [self setInsulinUploadState: model];
        }
        else
        {
            NSLog(@"22222");
        }
    } failure:^(NSError *error) {
        NSLog(@"1111");
    }];
}

-(BOOL)setInsulinUploadState:(InsulinDataModel*)model
{
    __block BOOL result = NO;
    if ([self open]) {
        [self.dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback)
         {
             @try {
                 NSString *sql = [NSString stringWithFormat:@"update `insulin_table` set upload = 1 WHERE timeInterval = %@", model.timeInterval];
                 result = [db executeUpdate:sql];
                 if (!result) {
                     NSLog(@"%s Failed: %@", __func__, [db lastErrorMessage]);
                 }
             }
             @catch (NSException *exception) {
                 *rollback = YES;
                 [db  rollback];
                 NSLog(@"%s except: %@", __func__, exception.description);
             }
             @finally {
                 if (!*rollback) {
                     [db  commit];
                 }
                 [self delayClose];
             }
         }];
    }
    return result;
}

#pragma mark - 再次上传上传失败的血糖和胰岛素数据

#pragma mark - 
- (void)getBloodSugarRequest
{
//    NSMutableArray *array = [NSMutableArray new];
    NSDictionary *dic = @{@"pageIndex":@"0", @"pageSize":@"1000"};
    [HTTPTool requestWithURLString:@"/api/HealthManager/GetBloodSugarList" parameters:dic showStatus:NO type:kGET success:^(id responseObject) {
        NSString *code = [responseObject objectForKey:@"ResultCode"];
        if ([code integerValue] == 0) {
            NSArray *array =  [responseObject objectForKey:@"Data"];
            [array enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                NSString *Note = [dic objectForKey:@"Note"];
                NSString *TimeStep = [dic objectForKey:@"TimeStep"];
                NSString *Value = [dic objectForKey:@"Value"];
                NSString * Type = [dic objectForKey:@"Type"];
                
                NSTimeInterval interval = [TimeStep doubleValue];
                NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970: interval/1000];
                NSString *timerStr = [KMTools getStringFromDate:confromTimesp];
                double value = [Value doubleValue];
                NSNumber *valueNumber = [NSNumber numberWithDouble:value];
                [self insertBloodSugarDataModelFromNumber:valueNumber note:Note timeScale:Type timer:timerStr upload:YES];
            }];
        }

    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}

- (void)getInsulinRequest
{
    NSDictionary *dic = @{@"pageIndex":@"0", @"pageSize":@"1000"};
    [HTTPTool requestWithURLString:@"/api/HealthManager/GetIsLetList" parameters:dic showStatus:NO type:kGET success:^(id responseObject) {
        NSString *code = [responseObject objectForKey:@"ResultCode"];
        if ([code integerValue] == 0) {
            NSArray *array =  [responseObject objectForKey:@"Data"];
            [array enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                NSString *Note = [dic objectForKey:@"Note"];
                NSString *Dose = [dic objectForKey:@"Dose"];
                NSString *IsletName = [dic objectForKey:@"IsletName"];
                
                NSString * MedicineTime = @"1.0";
                if ( ![[dic objectForKey:@"MedicineTime"] isKindOfClass: [NSNull class]])
                {
                    MedicineTime = [dic objectForKey:@"MedicineTime"];
                }
                double time = [MedicineTime doubleValue]/1000;
                NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
                NSString *hehe = [KMTools getStringFromDate:confromTimesp];
                double DoseValue = [Dose doubleValue];
                if (DoseValue == 0)
                {
                    DoseValue = 1.0;
                }
                NSNumber *DosNumber = [NSNumber numberWithDouble:DoseValue];
                [self insertInsulinDataModelFromNumber:IsletName dose:DosNumber note:Note timeScale:hehe upload:YES];
            }];
        }
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}
@end
