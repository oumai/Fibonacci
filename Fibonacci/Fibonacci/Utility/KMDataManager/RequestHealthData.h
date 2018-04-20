//
//  RequestHealthData.h
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/11/30.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface RequestHealthData : NSObject

@property (nonatomic, copy ) NSString      *OBJType;
@property (nonatomic, copy ) NSString      *TimeStamp;
@property (nonatomic, copy ) NSString      *ResultValue;
@property (nonatomic, copy ) NSString      *OBJName;
@property (nonatomic, copy ) NSString      *BloodValue;

@end
