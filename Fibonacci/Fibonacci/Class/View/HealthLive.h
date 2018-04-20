//
//  HeartLive.h
//  HeartRateCurve
//
//  Created by IOS－001 on 14-4-23.
//  Copyright (c) 2014年 N/A. All rights reserved.
//
//现在没时间修改 有时间需要删除这个类，这个类重复了。
#import <UIKit/UIKit.h>

@interface KMPointContainer : NSObject

@property (nonatomic , readonly) NSInteger numberOfRefreshElements;
@property (nonatomic , readonly) NSInteger numberOfTranslationElements;
@property (nonatomic , readonly) CGPoint *refreshPointContainer;
@property (nonatomic , readonly) CGPoint *topPointContainer;
@property (nonatomic , readonly) CGPoint *bomPointContainer;
@property (nonatomic , readonly) CGPoint *endPointContainer;
@property (nonatomic , readonly) CGPoint *translationPointContainer;

+ (KMPointContainer *)sharedContainer;

//刷新变换
- (void)addPointAsRefreshChangeform:(CGPoint)point;
- (void)addTopPointAsRefreshChangeform:(CGPoint)point;
- (void)addBomPointAsRefreshChangeform:(CGPoint)point;
- (void)addEndPointAsRefreshChangeform:(CGPoint)point;
- (void)addPointAsRefreshChangeformStart:(CGPoint)startPoint Top:(CGPoint)topPoint bottom:(CGPoint)bottomPoint end:(CGPoint)endPoint;
//平移变换
- (void)addPointAsTranslationChangeform:(CGPoint)point;

@end



@interface HealthLive : UIView

- (void)fireDrawingWithPoints:(CGPoint *)points :(CGPoint *)toppoints :(CGPoint *)bompoints :(CGPoint *)endpoints pointsCount:(NSInteger)count;

@end
