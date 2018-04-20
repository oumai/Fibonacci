//
//  BATMJExtensionConfig.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/6.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMJExtensionConfig.h"
#import "MJExtension.h"

@implementation BATMJExtensionConfig

+ (void)load
{
    [NSObject mj_setupNewValueFromOldValue:^id(id object, id oldValue, MJProperty *property) {

        if (property.type.typeClass == [NSString class]) {
            
            if (oldValue == nil) {
                return @"";
            } else if ([oldValue isKindOfClass:[NSNull class]]) {
                return @"";
            } else if ([oldValue isKindOfClass:[NSString class]]) {
                if ([oldValue isEqualToString:@"(null)"] || [oldValue isEqualToString:@"<null>"] || [oldValue isEqualToString:@"null"]) {
                    return @"";
                }
            }
        }
        return oldValue;
    }];
}

@end
