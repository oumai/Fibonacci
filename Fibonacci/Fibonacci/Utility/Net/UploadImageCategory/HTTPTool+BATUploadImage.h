//
//  HTTPTool+BATUploadImage.h
//  HealthBAT_Pro
//
//  Created by KM on 16/9/132016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool.h"

@interface HTTPTool (BATUploadImage)

/**
 *  上传图片
 *
 *  @param block    formData
 *  @param progress 进度
 *  @param success  成功
 *  @param failure  失败
 */
+ (void)requestUploadImageConstructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                           progress:(void (^)(NSProgress *uploadProgress))progress
                                            success:(void (^)(NSArray *imageArray))success
                                            failure:(void (^)(NSError *error))failure;

@end
