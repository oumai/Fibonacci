//
//  BATVersionModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/9/292016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VersionData;
@interface BATVersionModel : NSObject

@property (nonatomic, strong) VersionData *Data;

@property (nonatomic, assign) NSInteger RecordsCount;

@property (nonatomic, assign) NSInteger PageIndex;

@property (nonatomic, assign) NSInteger PageSize;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, assign) NSInteger PagesCount;

@property (nonatomic, assign) BOOL AllowPaging;

@property (nonatomic, copy) NSString *ResultMessage;

@end

@interface VersionData : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *UpAddress;

@property (nonatomic, assign) NSInteger AccountType;

@property (nonatomic, copy) NSString *Equipment;

@property (nonatomic, assign) BOOL IsUpdate;

@property (nonatomic, copy) NSString *VersionId;

@end

