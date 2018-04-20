//
//  URLModel.h
//  HealthBAT
//
//  Created by KM on 16/6/302016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATDomainData;

@interface BATDomainModel : NSObject

@property (nonatomic, assign) NSInteger     PagesCount;

@property (nonatomic, assign) NSInteger     ResultCode;

@property (nonatomic, assign) NSInteger     RecordsCount;

@property (nonatomic, copy  ) NSString      *ResultMessage;

@property (nonatomic, strong) BATDomainData *Data;

@end


@interface BATDomainData : NSObject

@property (nonatomic, copy  ) NSString      *storedominUrl;

@property (nonatomic, copy  ) NSString      *appdominUrl;

@property (nonatomic, copy  ) NSString      *hotquestionUrl;

@end

