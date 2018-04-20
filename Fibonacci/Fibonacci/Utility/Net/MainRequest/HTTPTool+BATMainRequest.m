//
//  HTTPTool+BATMainRequest.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/232016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool+BATMainRequest.h"
#import "BATBaseModel.h"
#import "SVProgressHUD.h"

@implementation HTTPTool (BATMainRequest)

+ (BOOL)isExistenceBaseNetwork {
    BOOL isExistenceNetwork;
    NSString *mainDomain = BASE_URL;
    DDLogError(@"base_url---%@",[mainDomain substringFromIndex:7]);
    Reachability *reachability = [Reachability reachabilityWithHostName:[mainDomain substringFromIndex:7]];
    switch([reachability currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = FALSE;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = TRUE;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = TRUE;
            break;
    }
    return  isExistenceNetwork;
}

#pragma mark -- POST/GET网络请求 --
+ (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                  showStatus:(BOOL)show
                        type:(HttpRequestType)type
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError * error))failure {

    AFHTTPSessionManager *manager = [HTTPTool managerWithBaseURL:nil sessionConfiguration:NO];
//    NSString * URL = @"";
//    if ([URLString isEqualToString:@"/api/Patient/Info"]) {
//        URL = [[NSString stringWithFormat:@"%@%@",BASE_NOTAPI_URL,URLString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    }
//    else
//    {
//        URL = [[NSString stringWithFormat:@"%@%@",BASE_URL,URLString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    }
    NSString *errorText = @"网络消化不良\n请检查您的网络哦";
    NSString *URL = [[NSString stringWithFormat:@"%@%@",BASE_URL,URLString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (LOGIN_STATION == YES) {
        NSString * token = [[NSUserDefaults standardUserDefaults] valueForKey:@"Token"];
        if (token) {

            [manager.requestSerializer setValue:token forHTTPHeaderField:@"Token"];
        }
    }

    switch (type) {
        case kGET:
        {
            [manager GET:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                id dic = [HTTPTool responseConfiguration:responseObject];
                BATBaseModel *baseModel = [BATBaseModel mj_objectWithKeyValues:dic];
                if (baseModel.ResultCode == -2) {

                    if (failure) {
                        NSError * error = nil;
                        failure(error);
                    }

                    //需要登录
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN_FAILURE" object:nil];
                    return ;
                }

                if (baseModel.ResultCode != 0) {
                    //失败
                    [SVProgressHUD showImage:nil status:baseModel.ResultMessage];
                    if (failure) {
                        NSError * error = nil;
                        failure(error);
                    }
                    return ;
                }
                if (baseModel.ResultCode == 0) {
                    //成功
                    if (success) {
                        success(dic);
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (show) {
                    [SVProgressHUD showImage:nil status:errorText];
                }
                else
                {
                    [SVProgressHUD dismiss];
                }
                DDLogError(@"\nURL---\n%@\n请求失败 error---\n%@", URLString, error.description);
                NSLog(@"error.description = %@",error.description);
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        case kPOST:
        {
            [manager POST:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                id dic = [HTTPTool responseConfiguration:responseObject];
                BATBaseModel *baseModel = [BATBaseModel mj_objectWithKeyValues:dic];
                if (baseModel.ResultCode == -2)
                {
                    //需要登录
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN_FAILURE" object:nil];
                    if (failure) {
                        NSError * error = nil;
                        failure(error);
                    }
                    return ;
                }

                if (baseModel.ResultCode != 0) {
                    [SVProgressHUD showErrorWithStatus:baseModel.ResultMessage];

                    if (failure) {
                        NSError * error = nil;
                        failure(error);
                    }
                    return ;
                }
                if (baseModel.ResultCode == 0) {
                    if (success) {
                        success(dic);
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (show) {
                    [SVProgressHUD showImage:nil status:errorText];
                }
                else
                {
                    [SVProgressHUD dismiss];
                }                NSLog(@"error.description = %@",error.description);
                DDLogError(@"\nURL---\n%@\n请求失败 error---\n%@", URLString, error.description);
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        case kDELETE:
        {
            [manager DELETE:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                id dic = [HTTPTool responseConfiguration:responseObject];
                BATBaseModel *baseModel = [BATBaseModel mj_objectWithKeyValues:dic];
                if (baseModel.ResultCode == -2) {
                    //需要登录
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN_FAILURE" object:nil];
                    if (failure) {
                        NSError * error = nil;
                        failure(error);
                    }

                    return ;
                }
                if (baseModel.ResultCode != 0) {
                    //失败
                    [SVProgressHUD showImage:nil status:baseModel.ResultMessage];
                    if (failure) {
                        NSError * error = nil;
                        failure(error);
                    }
                    return ;
                }
                if (baseModel.ResultCode == 0) {
                    //成功
                    if (success) {
                        success(dic);
                    }
                }

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (show) {
                    [SVProgressHUD showImage:nil status:errorText];
                }
                else
                {
                    [SVProgressHUD dismiss];
                }                DDLogError(@"\nURL---\n%@\n请求失败 error---\n%@", URLString, error.description);
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        case kPUT:
        {
            [manager PUT:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                id dic = [HTTPTool responseConfiguration:responseObject];
                BATBaseModel *baseModel = [BATBaseModel mj_objectWithKeyValues:dic];
                if (baseModel.ResultCode == -2) {
                    //需要登录
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN_FAILURE" object:nil];
                    if (failure) {
                        NSError * error = nil;
                        failure(error);
                    }
                    
                    return ;
                }
                
                if (baseModel.ResultCode != 0) {
                    //失败
                    [SVProgressHUD showImage:nil status:baseModel.ResultMessage];
                    if (failure) {
                        NSError * error = nil;
                        failure(error);
                    }
                    return ;
                }
                if (baseModel.ResultCode == 0) {
                    //成功
                    if (success) {
                        success(dic);
                    }
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (show) {
                    [SVProgressHUD showImage:nil status:errorText];
                }
                else
                {
                    [SVProgressHUD dismiss];
                }
                DDLogError(@"\nURL---\n%@\n请求失败 error---\n%@", URLString, error.description);
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
//            case kWEATHER:
//        {
//            
//        }
//            break;
    }
}

#pragma mark - POST传FormData

+ (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
   constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                    progress:(void (^)(NSProgress * _Nonnull uploadProgress))progress
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError * error))failure {

    AFHTTPSessionManager *manager = [HTTPTool managerWithBaseURL:nil sessionConfiguration:NO];
    NSString * URL = [NSString stringWithFormat:@"%@%@",BASE_URL,URLString];
    if (LOGIN_STATION == YES) {
        NSString * token = [[NSUserDefaults standardUserDefaults] valueForKey:@"Token"];
        if (token) {
            [manager.requestSerializer setValue:token forHTTPHeaderField:@"Token"];
        }
    }


    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (block) {
            block(formData);
        }
    } error:nil];


    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      if (progress) {
                          progress(uploadProgress);
                      }
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          DDLogError(@"\nURL---\n%@\n请求失败 error---\n%@", URLString, error.description);
                          if (failure) {
                              [SVProgressHUD showImage:nil status:@"网络异常"];
                              failure(error);
                          }
                      }
                      else {
                          //                          DDLogVerbose(@"\nPOSTFormdata返回值---\n%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                          id dic = [HTTPTool responseConfiguration:responseObject];
                          //                          DDLogDebug(@"\nPOSTFormdata返回值---\n%@", dic);

                          BATBaseModel *baseModel = [BATBaseModel mj_objectWithKeyValues:dic];
                          if (baseModel.ResultCode == -2) {
                              //重新登录
                              [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN_FAILURE" object:nil];
                              return ;
                          }

                          if (baseModel.ResultCode != 0) {
                              //失败
                              [SVProgressHUD showImage:nil status:baseModel.ResultMessage];
                              return ;
                          }
                          if (baseModel.ResultCode == 0) {
                              //成功
                              if (success) {
                                  success(dic);
                              }
                          }
                      }
                  }];
    
    [uploadTask resume];
}

@end
