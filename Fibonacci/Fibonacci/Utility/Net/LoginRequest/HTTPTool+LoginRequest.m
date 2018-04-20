//
//  HTTPTool+LoginRequest.m
//  Fibonacci
//
//  Created by woaiqiu947 on 2017/7/18.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import "HTTPTool+LoginRequest.h"
#import "AppDelegate.h"
#import "BATLoginModel.h"
#import "SFHFKeychainUtils.h"
#import "BATPerson.h"
#import "HTTPTool+HeartDataRequst.h"

@implementation HTTPTool (LoginRequest)

+ (void)LoginWithUserName:(NSString *)userName password:(NSString *)password Success:(void(^)())success failure:(void(^)(NSError * error))failure
{
    
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/Login"
                        parameters:@{
                                     @"AccountName": userName,
//                                     @"PhoneNumber":@"",
                                     @"PassWord": password,
//                                     @"LoginType":@"1"
                                     }
                        showStatus:YES
                              type:kPOST
                           success:^(id responseObject) {
                               BATLoginModel * login = [BATLoginModel mj_objectWithKeyValues:responseObject];
                               if (login.ResultCode == 0)
                               {
                                   if (login.Data.AccountType != 2)
                                   {
                                       [self successActionWithLogin:login userName:userName password:password];
                                       if (success) {
                                           success();
                                       }
                                   }
                                   else
                                   {
                                       //医生账号，暂时不能登陆
                                       NSDictionary *userInfo = [NSDictionary dictionaryWithObject: login.ResultMessage forKey:NSLocalizedDescriptionKey];
                                       NSError *error = [NSError errorWithDomain:@"LOGIN_ERROR" code:0 userInfo:userInfo];
                                       failure(error);
                                   }
                                   

                               }
                               
                               
                           }
                           failure:^(NSError *error) {
                               if (failure) {
                                   failure(error);
                               }
                           }];
}

+ (void)successActionWithLogin:(BATLoginModel *)login userName:(NSString *)userName password:(NSString *)password
{
    if (login.ResultCode == 0)
    {
        //登录成功
//        AppDelegate *delegate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserLogin.data"];
        [NSKeyedArchiver archiveRootObject:login toFile:file];
        
        [[NSUserDefaults standardUserDefaults] setValue:userName forKey:KEY_LOGIN_NAME];
        [[NSUserDefaults standardUserDefaults] setValue:login.Data.Token forKey:KEY_LOGIN_TOKEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSError *error;
        BOOL saved = [SFHFKeychainUtils storeUsername:userName andPassword:password forServiceName:ServiceName updateExisting:YES error:&error];
        if(!saved)
        {
            DDLogError(@"保存密码时出错：%@",error);
        }
        error = nil;
        
        //改变登录状态
        SET_LOGIN_STATION(YES);
        //保存登录信息
        [[KMDataManager sharedDatabaseInstance] changeDatabaseName];

        
        //获取个人信息
        [self personInfoListRequest];
    }
}

+ (void)personInfoListRequest {
    
    [HTTPTool requestWithURLString:@"/api/Patient/Info" parameters:nil showStatus:NO type:kGET success:^(id responseObject) {
        
        BATPerson * person = [BATPerson mj_objectWithKeyValues:responseObject];
        if (person.ResultCode == 0) {
            //保存登录信息
            NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"];
            [NSKeyedArchiver archiveRootObject:person toFile:file];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATA_LOGIN_STATION" object:nil];
            [HTTPTool getPhysicalRecoidCompletion:^(BOOL success,NSMutableDictionary * dict, NSError *error){
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
