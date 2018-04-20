//
//  DetectioResultView.h
//  Fibonacci
//
//  Created by shipeiyuan on 16/8/29.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, EShadeType) {
    EShadeTypeDefault               = 0,
    EShadeTypeDeBeforeExercise      = 1,
    EShadeTypeDeAforeExercise       = 2,
    EShadeTypeMAX                   = 3,
    EShadeTypeFood                   = 4,
};
@interface DetectioResultView : UIView
@property(nonatomic, assign)EShadeType shadeType;
@end
