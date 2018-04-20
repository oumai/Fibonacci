//
//  HTTPTool+HeartDataRequst.h
//  Fibonacci
//
//  Created by woaiqiu947 on 2017/3/10.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import "HTTPTool.h"

@interface HTTPTool (HeartDataRequst)
+ (void)getPhysicalRecoidCompletion:(void(^)(BOOL success,NSMutableDictionary * dict, NSError *error))completion;
@end
