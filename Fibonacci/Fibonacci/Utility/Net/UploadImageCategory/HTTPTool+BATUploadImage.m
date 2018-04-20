//
//  HTTPTool+BATUploadImage.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/132016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "HTTPTool+BATUploadImage.h"
#import "SVProgressHUD.h"
#import "BATUploadImageModel.h"

@implementation HTTPTool (BATUploadImage)

+ (void)requestUploadImageConstructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                           progress:(void (^)(NSProgress * _Nonnull uploadProgress))progress
                                            success:(void (^)(NSArray *imageArray))success
                                            failure:(void (^)(NSError * error))failure {

    AFHTTPSessionManager *manager = [HTTPTool managerWithBaseURL:nil sessionConfiguration:NO];
    NSString * URL = @"http://upload.jkbat.com";


    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
                          DDLogError(@"\nURL---\n%@\n请求失败 error---\n%@", URL, error.description);
                          if (failure) {
                              [SVProgressHUD showImage:nil status:ErrorText];
                              failure(error);
                          }
                      }
                      else {
//                          DDLogVerbose(@"\nPOSTFormdata返回值---\n%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                          NSArray *imageArray = [HTTPTool responseConfiguration:responseObject];
//                          DDLogDebug(@"\nPOSTFormdata返回值---\n%@", dic);

                          if (success) {
                              success(imageArray);
                          }

                      }
                  }];
    
    [uploadTask resume];
}

@end
