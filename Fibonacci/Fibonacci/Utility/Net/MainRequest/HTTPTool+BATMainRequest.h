//
//  HTTPTool+BATMainRequest.h
//  HealthBAT_Pro
//
//  Created by KM on 16/9/232016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool.h"

@interface HTTPTool (BATMainRequest)

/**
 *  测试.net接口连接
 *
 *  @return .net网络是否可用
 */
+ (BOOL)isExistenceBaseNetwork;

/**
 *  AFNetworking3.0 封装
 *
 *  @param URLString  URL
 *  @param parameters 参数
 *  @param type       请求类型
 *  @param success    请求成功
 *  @param failure    请求失败
 */
+ (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                  showStatus:(BOOL)show
                        type:(HttpRequestType)type
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;



/**
 *  AFNetWorking3.0 post传formData
 *
 *  @param URLString  URL
 *  @param parameters 参数
 *  @param block      formData
 *  @param progress   进度
 *  @param success    成功
 *  @param failure    失败
 */
+ (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
   constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                    progress:(void (^)(NSProgress *uploadProgress))progress
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;



@end
