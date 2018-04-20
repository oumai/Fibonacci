//
//  TXHRrettyRuler.h
//  PrettyRuler
//
//  Created by GXY on 15/12/11.
//  Copyright © 2015年 Tangxianhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXHRulerScrollView.h"

@protocol TXHRrettyRulerDelegate <NSObject>

- (void)txhRrettyRuler:(TXHRulerScrollView *)rulerScrollView;

@end

@interface TXHRrettyRuler : UIView <UIScrollViewDelegate>
{
    CGFloat scrollCurrentValue;
}
@property (nonatomic, assign) id <TXHRrettyRulerDelegate> rulerDeletate;

/*
*  count * average = 刻度最大值
*  @param count        10个小刻度为一个大刻度，大刻度的数量
*  @param average      每个小刻度的值，最小精度 0.1
*  @param currentValue 直尺初始化的刻度值
*  @param mode         是否最小模式
*/
- (void)showRulerScrollViewWithCount:(NSUInteger)count
                               start:(NSUInteger)start
                             average:(NSNumber *)average
                        currentValue:(CGFloat)currentValue
                           smallMode:(BOOL)mode;

- (void)moveScrollView;
- (void)moveScrollViewToZero;
- (TXHRulerScrollView *)getRulerScrollView;
@end
