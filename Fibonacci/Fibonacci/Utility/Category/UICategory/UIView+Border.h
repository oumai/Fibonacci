//
//  UIView+Border.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/132016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Border)
/**
 *  设置底部边框
 *
 *  @param color  颜色
 *  @param width  宽度，传0默认为width
 *  @param height 高度，传0默认为0.5
 */
- (void)setBottomBorderWithColor:(UIColor *)color width:(float)width height:(float)height;

/**
 *  设置顶部边框
 *
 *  @param color  颜色
 *  @param width  宽度，传0默认为width
 *  @param height 高度，传0默认为0.5
 */
- (void)setTopBorderWithColor:(UIColor *)color width:(float)width height:(float)height;

/**
 *  设置左边边框
 *
 *  @param color  颜色
 *  @param width  宽度，传0默认为0.5
 *  @param height 高度，传0默认为height
 */
- (void)setLeftBorderWithColor:(UIColor *)color width:(float)width height:(float)height;

/**
 *  设置右边边框
 *
 *  @param color  颜色
 *  @param width  宽度，传0默认为0.5
 *  @param height 高度，传0默认为height
 */
- (void)setRightBorderWithColor:(UIColor *)color width:(float)width height:(float)height;

@end
