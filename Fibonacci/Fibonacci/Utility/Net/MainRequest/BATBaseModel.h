//
//  SuccessModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/272016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface BATBaseModel : NSObject

@property (nonatomic, copy  ) NSString  *Msg;

@property (nonatomic, assign) NSInteger ResultCode;

@property (nonatomic, copy  ) NSString  *ResultMessage;

@end
