//
//  HTTPAssistant.h
//  XMPP
//
//  Created by KM on 16/3/292016.
//  Copyright © 2016年 skybrim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Reachability.h"

typedef NS_ENUM(NSUInteger,HttpRequestType) {
    /**
     *  get请求
     */
    kGET = 0,
    /**
     *  post请求
     */
    kPOST,
    /**
     *  delete请求
     */
    kDELETE,
    /**
     *  put请求
     */
    kPUT,
};

typedef NS_ENUM(NSUInteger,SerializerType) {
    /**
     *  http解析
     */
    kHTTP = 0,
    /**
     *  json解析
     */
    kJSON,
};

@interface HTTPTool : NSObject

/**
 *  检测网络状态
 *
 *  @return 网络是否可用
 */

+ (BOOL)isExistenceNetwork;

/**
 *  一般状态请求
 *
 *  @param URLString       url
 *  @param parameters      参数
 *  @param serializerType  解析类型
 *  @param type            请求类型
 *  @param success         成功
 *  @param failure         失败
 */
+ (void)requestNormalWithURLString:(NSString *)URLString
                        parameters:(id)parameters
                    serializerType:(SerializerType)serializerType
                              type:(HttpRequestType)type
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError * error))failure;

/**
 *  一般传formdata
 *
 *  @param URLString  url
 *  @param parameters 参数
 *  @param block      formaData
 *  @param progress   进度
 *  @param success    成功
 *  @param failure    失败
 */
+ (void)requestNormalWithURLString:(NSString *)URLString
                        parameters:(id)parameters
         constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                          progress:(void (^)(NSProgress * uploadProgress))progress
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
/**
 *  创建AFManager
 *
 *  @param baseURL         baseURL
 *  @param isconfiguration
 *
 *  @return AFHTTPSessionManager
 */
+ (AFHTTPSessionManager *)managerWithBaseURL:(NSString *)baseURL  sessionConfiguration:(BOOL)isconfiguration;

/**
 *  解析
 *
 *  @param responseObject 请求返回值
 *
 *  @return 解析后的请求返回值
 */
+ (id)responseConfiguration:(id)responseObject;
@end
