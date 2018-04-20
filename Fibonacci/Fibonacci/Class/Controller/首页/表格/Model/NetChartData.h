//
//  NetChartData.h
//  Fibonacci
//
//  Created by woaiqiu947 on 2017/3/8.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface NetChartDataModel : NSObject

@property (nonatomic, copy  ) NSString     *CodeName;

@property (nonatomic, copy  ) NSString     *CreateDate;

@property (nonatomic, copy  ) NSString     *PersonNo;

@property (nonatomic, copy  ) NSString     *Result;


@end

@interface NetChartData : NSObject

@property (nonatomic, assign) NSInteger    RecordsCount;

@property (nonatomic, copy  ) NSString     *ResultMessage;

@property (nonatomic, strong) NSArray <NetChartDataModel*> *Data;

@end
