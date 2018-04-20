//
//  HeartLive.h
//  HeartRateCurve
//
//  Created by IOS－001 on 14-4-23.
//  Copyright (c) 2014年 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointContainer : NSObject
{
    NSInteger currentPointsCount;
    NSInteger currentTranslaPointsCounts;
    NSInteger kMaxTranslationContainerCapacity;
    NSInteger kMaxContainerCapacity;
}
@property (nonatomic , readonly) NSInteger numberOfRefreshElements;
@property (nonatomic , readonly) NSInteger numberOfTranslationElements;
@property (nonatomic , readonly) CGPoint *refreshPointContainer;
@property (nonatomic , readonly) CGPoint *translationPointContainer;

+ (PointContainer *)sharedContainer;
+ (id)hideAlloc;
- (void)clearValue;

//刷新变换
- (void)addPointAsRefreshChangeform:(CGPoint)point;
//平移变换
- (void)addPointAsTranslationChangeform:(CGPoint)point;

@end



@interface HeartLive : UIView
{
    CGContextRef context;
    BOOL clear;
}
@property(nonatomic,assign)BOOL gridType;
@property(nonatomic,assign)BOOL drawType;

- (void)fireDrawingWithPoints:(CGPoint *)points pointsCount:(NSInteger)count;
-(void)clearDrawing;
-(void)stopDrawing;
@end

