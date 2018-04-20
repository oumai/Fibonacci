//
//  HeartBackgroundView.h
//  Fibonacci
//
//  Created by shipeiyuan on 16/8/25.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HeartBackgroundViewTransformStatus) {
    HeartBackgroundViewTransformStatusTop           = 0,
    HeartBackgroundViewTransformStatusLeft          = 1,
    HeartBackgroundViewTransformStatusNarrow        = 2,
};


@interface HeartBackgroundView : UIView
{
    CGFloat strokeEndValue;
    HeartBackgroundViewTransformStatus heartBackgroundViewTransformStatus;
}
//@property (nonatomic, assign) ;
@property(assign,nonatomic)CGFloat startValue;
@property(assign,nonatomic)CGFloat lineWidth;
@property(assign,nonatomic)CGFloat value;
//@property(assign,nonatomic)CGFloat strokeEndValue;
@property(strong,nonatomic)UIColor *lineColr;

- (instancetype)initWithFrame:(CGRect)frame transformType:(HeartBackgroundViewTransformStatus)status;
- (instancetype)initWithFrame:(CGRect)frame strokeEnd:(float)value;
- (instancetype)initWithFrame:(CGRect)frame strokeEnd:(float)value transformType:(HeartBackgroundViewTransformStatus)status;
-(void)closeStroke;

@end
