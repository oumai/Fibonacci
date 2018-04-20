//
//  EyeHelpCustom.h
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/10/17.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NEyeHelpViewType) {
    NEyeHelpViewTypeDefault         = 0,
    NEyeHelpViewTypeColor           = 1,
};

@interface EyeHelpCustom : NSObject

+(void)presentEyeHelpView:(NEyeHelpViewType)type;

@end
