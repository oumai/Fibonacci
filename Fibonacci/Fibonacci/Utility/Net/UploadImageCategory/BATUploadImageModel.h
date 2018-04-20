//
//  BATUploadImageModel.h
//  HealthBAT_Pro
//
//  Created by KM on 16/9/132016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class BATImage;

@interface BATUploadImageModel : NSObject

@property (nonatomic, strong) NSArray<BATImage *> *BATImageArray;

@end

@interface BATImage : NSObject

@property (nonatomic, copy) NSString *path;

@property (nonatomic, copy) NSString *filename;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *physicalPath;

@property (nonatomic, copy) NSString *attachment;

@end

