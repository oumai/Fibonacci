//
//  HTTPTool+LoginRequest.h
//  KMTestHalthyManage
//
//  Created by woaiqiu947 on 2017/8/24.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import "HTTPTool.h"

@interface HTTPTool (LoginRequest)
+ (void)LoginWithUserName:(NSString *)userName
                 password:(NSString *)password
                  Success:(void(^)())success
                  failure:(void(^)(NSError * error))failure;

@end
