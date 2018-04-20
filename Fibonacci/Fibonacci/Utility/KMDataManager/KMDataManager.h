//
//  KMDataManager.h
//  TsuenWanBaptist
//
//  Created by Sgs on 14/11/1.
//  Copyright (c) 2014年 Sgs. All rights reserved.
//

#import "KMDataManager.h"
#import "KMSqliteManager.h"

typedef NS_ENUM(NSInteger, EDataTimePeriod) {
    EDataTimePeriodStatusDay            = 0,
    EDataTimePeriodStatusWeek           = 1,
    EDataTimePeriodStatusMonth          = 2,
    EDataTimePeriodStatusYear           = 3,
    EDataTimePeriodStatusAll            = 4
};

typedef NS_ENUM(NSInteger, EDataType) {
    EDataHeartRateType             = 0,     //心率
    EDataBloodPressureType         = 1,     //血压
    ECDataHealthStepType           = 2,     //步行
    EDataBloodOxygenType           = 3,     //血氧
    EDataVitalCapacityType         = 4,     //肺活量
    EDataVisionDataType            = 5,     //视力
    EDataBloodSugarDataType        = 6,     //血糖
};

@interface KMDataManager : KMSqliteManager

+ (KMDataManager *) sharedDatabaseInstance;

- (void) setDatabaseName:(NSString *)databaseName;

- (void) updateDataBase;

- (void) changeDatabaseName;

- (BOOL) addTableDataVersion:(NSString *)tableName Version:(NSString *)version IsUpdate:(NSString *)isUpdate;

- (NSMutableArray *) getTableIsUpdate:(NSString *)tableName;

//删除数据库
- (void)deleteDataBase;

#pragma mark - 写入
/*
 *  @brief  写入心率数据
 */
- (BOOL) insertHeartRateDataModelNumber:(NSNumber *)value;

/*
 *  @brief  写入血氧数据
 */
- (BOOL) insertBloodPressureDataModelFromSPNumber:(NSNumber *)sp andDPNumber:(NSNumber *)dp;

/*
 *  @brief  写入血氧数据
 */
- (BOOL) insertBloodOxygenDataModelFromNumber:(NSNumber *)value;

/*
 *  @brief  写入肺活量数据
 */
- (BOOL) insertVitalCapacityDataModelFromNumber:(NSNumber *)value;

/*
 *  @brief  写入视力数据
 */
- (BOOL) insertVisionDataModelFromNumber:(NSNumber *)value;

/*
 *  @brief  写入血糖数据
 */
- (BOOL) insertBloodSugarDataModelFromNumber:(NSNumber *)value note:(NSString *)note timeScale:(NSString *)timeScale timer:(NSString *)timerString upload:(BOOL)upload;

/*
 *  @brief  写入胰岛素数据
 */
- (BOOL) insertInsulinDataModelFromNumber:(NSString *)name dose:(NSNumber *)dose note:(NSString *)note timeScale:(NSString *)timeScale upload:(BOOL)upload;

#pragma mark - 获取
/*
 *  @brief  读取心率数据
 */
- (NSMutableArray *) getHeartRateDataModels:(EDataTimePeriod)status forDate:(NSDate *)selectedDate;

/*
 *  @brief  读取血压数据
 */
- (NSMutableArray *) getBloodPressureDataModels:(EDataTimePeriod)status forDate:(NSDate *)selectedDate;

/*
 *  @brief  读取血氧数据
 */
- (NSMutableArray *) getBloodOxygenDataModels:(EDataTimePeriod)status forDate:(NSDate *)selectedDate;

/*
 *  @brief  读取肺活量数据
 */
- (NSMutableArray *) getVitalCapacityDataModels:(EDataTimePeriod)status forDate:(NSDate *)selectedDate;

/*
 *  @brief  获取视力数据
 */
- (NSMutableArray *) getVisionDataModels:(EDataTimePeriod)status forDate:(NSDate *)selectedDate;


/*
 *  @brief  读取血糖数据
 */
- (NSMutableArray *)getBloodSugarDataModels:(EDataTimePeriod)status forDate:(NSDate *)selectedDate;

/*
 *  @brief  读取胰岛素数据
 */
- (NSMutableArray *)getInsulinDataModels;

/*
 *  @brief  根据类型返回最新数据
 */
- (id)getLastDataModelFromeType:(EDataType )type;
@end
