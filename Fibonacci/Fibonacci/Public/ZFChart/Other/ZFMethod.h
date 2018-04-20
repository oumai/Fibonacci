//
//  ZFMethod.h
//  ZFChartView
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFMethod : NSObject

+ (instancetype)shareInstance;

/**
*  存储随机颜色
*
*  @param array 传入valueArray
*
*  @return 返回存储UIColor的数组
*/
- (NSMutableArray *)cachedColor:(NSArray *)array;

/**
 *  存储默认kChartValuePosition枚举类型(全部为kChartValuePositionDefalut)
 *
 *  @param array 传入valueArray
 *
 *  @return 返回存储kChartValuePosition枚举类型的数组
 */
- (NSMutableArray *)cachedValuePositionInLineChart:(NSArray *)array;

/**
 *  存储雷达图半径延伸长度，默认为25.f
 *
 *  @param array 传入itemArray
 *
 *  @return 返回存储NSNumber(CGFloat)的数组
 */
- (NSMutableArray *)cachedRadiusExtendLengthInRadarChart:(NSArray *)array;

/**
 *  获取数据源最大值，并赋值给y轴最大上限
 */
- (CGFloat)cachedYLineMaxValue:(NSMutableArray *)array;

/**
 *  获取数据源最小值，并赋值给y轴显示的最小值
 */
- (CGFloat)cachedYLineMinValue:(NSMutableArray *)array;

@end
