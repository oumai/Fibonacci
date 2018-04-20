//
//  LoginModel.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/7/17.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATLoginData;


@interface BATLoginModel : NSObject

@property (nonatomic, assign) NSInteger    PagesCount;

@property (nonatomic, assign) NSInteger    ResultCode;

@property (nonatomic, assign) NSInteger    RecordsCount;

@property (nonatomic, copy  ) NSString     *ResultMessage;

@property (nonatomic, assign) BOOL         AllowPaging;

@property (nonatomic, strong) BATLoginData *Data;

@end


@interface BATLoginData : NSObject

@property (nonatomic, copy  ) NSString     *Email;

@property (nonatomic, assign) NSInteger    ConditionID;

@property (nonatomic, copy  ) NSString     *RegisterTime;

@property (nonatomic, copy  ) NSString     *Token;

@property (nonatomic, assign) NSInteger    AccountType;

@property (nonatomic, copy  ) NSString     *UserName;

@property (nonatomic, assign) NSInteger    ID;

@property (nonatomic, copy  ) NSString     *AccountName;

@property (nonatomic, assign) BOOL         IsOtherLogin;

@end

