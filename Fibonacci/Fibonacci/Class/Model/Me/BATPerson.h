//
//  Person.h
//  HealthBAT
//
//  Created by KM on 16/6/72016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATPersonData;
@interface BATPerson : NSObject


@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, copy) NSString *ResultMessage;

@property (nonatomic, strong) BATPersonData *Data;

@end

@interface BATPersonData : NSObject

@property (nonatomic, assign) NSInteger FansCount;

@property (nonatomic, copy) NSString *Treatments;

@property (nonatomic, assign) NSInteger GuanZhuCount;

@property (nonatomic, copy) NSString *InvitedTime;

@property (nonatomic, assign) BOOL IsFollowed;

@property (nonatomic, assign) BOOL IsMaster;

@property (nonatomic, copy) NSString *Signature;

@property (nonatomic, copy) NSString *CreatedTime;

@property (nonatomic, copy) NSString *PhoneNumber;

@property (nonatomic, copy) NSString *UserName;

@property (nonatomic, copy) NSString *Sex;

@property (nonatomic, copy) NSString *IDNumber;

@property (nonatomic, assign) NSInteger AccountID;

@property (nonatomic, copy) NSString *City;

@property (nonatomic, copy) NSString *GeneticDisease;

@property (nonatomic, copy) NSString *PhotoPath;

@property (nonatomic, copy) NSString *MyConditions;

@property (nonatomic, copy) NSString *Allergies;

@property (nonatomic, copy) NSString *Birthday;

@property (nonatomic, copy) NSString *Birthdays;

@property (nonatomic, copy) NSString *Province;

@property (nonatomic, assign) NSInteger Height;

@property (nonatomic, copy) NSString *PrimaryConditionName;

@property (nonatomic, copy) NSString *Symptoms;

@property (nonatomic, assign) NSInteger AccountType;

@property (nonatomic, copy) NSString *AccountLevel;

@property (nonatomic, copy) NSString *Anamnese;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *NativeCity;

@property (nonatomic, assign) NSInteger Weight;

@property (nonatomic, copy) NSString *NativeProvince;

@property (nonatomic, assign) NSInteger Age;

@property (nonatomic, assign) NSInteger PatientID;

@property (nonatomic, assign) BOOL IsBindQQ;

@property (nonatomic, assign) BOOL IsBindWX;

@end

