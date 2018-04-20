//
//  HTTPAssistant.m
//  XMPP
//
//  Created by KM on 16/3/292016.
//  Copyright © 2016年 skybrim. All rights reserved.
//

#import "HTTPTool.h"

@implementation HTTPTool
#pragma mark - 检查网络
+ (BOOL)isExistenceNetwork {
     BOOL isExistenceNetwork;

    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];  //T_WARINING 测试网络状态

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
+ (void)requestNormalWithURLString:(NSString *)URLString
                        parameters:(id)parameters
                    serializerType:(SerializerType)serializerType
                              type:(HttpRequestType)type
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError * error))failure {

    AFHTTPSessionManager *manager = [HTTPTool managerWithBaseURL:nil sessionConfiguration:NO];

    switch (serializerType) {
        case kHTTP:
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];

            break;
        case kJSON:
            manager.requestSerializer = [AFJSONRequestSerializer serializer];

            break;

        default:
            break;
    }
    switch (type) {
        case kGET:
        {
            [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                id dic = [HTTPTool responseConfiguration:responseObject];
                if (success) {
                    success(dic);
                }

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        case kPOST:
        {
            [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                id dic = [HTTPTool responseConfiguration:responseObject];

                if (success) {
                    success(dic);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        case kDELETE:
        {
            [manager DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                id dic = [HTTPTool responseConfiguration:responseObject];
                //成功
                if (success) {
                    success(dic);
                }

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        case kPUT:
        {

        }
            break;
    }
}

#pragma mark - POST传FormData

+ (void)requestNormalWithURLString:(NSString *)URLString
                        parameters:(id)parameters
         constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                          progress:(void (^)(NSProgress * _Nonnull uploadProgress))progress
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError * error))failure {

    AFHTTPSessionManager *manager = [HTTPTool managerWithBaseURL:nil sessionConfiguration:NO];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
                          if (failure) {
                              failure(error);
                          }
                      }
                      else {
                          id dic = [HTTPTool responseConfiguration:responseObject];
                          if (success) {
                              success(dic);
                          }
                      }
                  }];
    
    [uploadTask resume];
}


#pragma mark - public

+ (AFHTTPSessionManager *)managerWithBaseURL:(NSString *)baseURL  sessionConfiguration:(BOOL)isconfiguration{

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager =nil;

    NSURL *url = [NSURL URLWithString:baseURL];

    if (isconfiguration) {

        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:configuration];
    }else{
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }

    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    return manager;
}

+ (id)responseConfiguration:(id)responseObject{

    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return dic;
}

@end
