//
//  TXHRrettyRuler.m
//  PrettyRuler
//
//  Created by GXY on 15/12/11.
//  Copyright © 2015年 Tangxianhai. All rights reserved.
//  withCount:(NSUInteger)count average:(NSUInteger)average

#import "TXHRrettyRuler.h"

#define SHEIGHT 8 // 中间指示器顶部闭合三角形高度
#define INDICATORCOLOR [UIColor redColor].CGColor // 中间指示器颜色

@implementation TXHRrettyRuler {
    TXHRulerScrollView * rulerScrollView;
}

- (void)dealloc
{
    rulerScrollView.delegate = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        rulerScrollView = [self rulerScrollView];
        rulerScrollView.rulerHeight = frame.size.height;
        rulerScrollView.rulerWidth = frame.size.width;
    }
    return self;
}

- (void)showRulerScrollViewWithCount:(NSUInteger)count
                               start:(NSUInteger)start
                             average:(NSNumber *)average
                        currentValue:(CGFloat)currentValue
                           smallMode:(BOOL)mode {
    NSAssert(rulerScrollView != nil, @"***** 调用此方法前，请先调用 initWithFrame:(CGRect)frame 方法初始化对象 rulerScrollView\n");
    NSAssert(currentValue < [average floatValue] * count, @"***** currentValue 不能大于直尺最大值（count * average）\n");
    rulerScrollView.rulerAverage = average;
    rulerScrollView.rulerCount = count;
    rulerScrollView.rulerStart = start;
    rulerScrollView.rulerValue = currentValue;
    rulerScrollView.bounces = NO;
    scrollCurrentValue = currentValue;
    rulerScrollView.mode = mode;
    [rulerScrollView drawRuler];
    [self addSubview:rulerScrollView];
    [self drawRacAndLine];
}

- (TXHRulerScrollView *)rulerScrollView {
    TXHRulerScrollView * rScrollView = [TXHRulerScrollView new];
    rScrollView.delegate = self;
    rScrollView.showsHorizontalScrollIndicator = NO;
    return rScrollView;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(TXHRulerScrollView *)scrollView {
//    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2 - DISTANCELEFTANDRIGHT;
//    CGFloat ruleValue = (offSetX / DISTANCEVALUE) * [scrollView.rulerAverage floatValue];
//    if (ruleValue < 0.f) {
//        return;
//    } else if (ruleValue > (scrollView.rulerCount-scrollView.rulerStart) * [scrollView.rulerAverage floatValue]) {
//        return;
//    }
//    if (self.rulerDeletate) {
//        if (!scrollView.mode) {
//            scrollView.rulerValue = ruleValue + scrollCurrentValue;
//        }
//        scrollView.mode = NO;
//        [self.rulerDeletate txhRrettyRuler:scrollView];
//    }
//    NSLog(@"%f",scrollView.contentOffset.x);
}

- (void)scrollViewDidEndDecelerating:(TXHRulerScrollView *)scrollView {
    [self animationRebound:scrollView];
}

- (void)scrollViewDidEndDragging:(TXHRulerScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self animationRebound:scrollView];
    if (!decelerate) {

    }
}

- (void)animationRebound:(TXHRulerScrollView *)scrollView {
    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2 - DISTANCELEFTANDRIGHT;
    CGFloat oX = (offSetX / DISTANCEVALUE) * [scrollView.rulerAverage floatValue];
#ifdef DEBUG
    NSLog(@"ago*****************ago:oX:%f",oX);
#endif
    if ([self valueIsInteger:scrollView.rulerAverage]) {
        oX = [self notRounding:oX afterPoint:0];
    }
    else {
        oX = [self notRounding:oX afterPoint:1];
    }
#ifdef DEBUG
    NSLog(@"after*****************after:oX:%.1f",oX);
#endif
    CGFloat offX = (oX / ([scrollView.rulerAverage floatValue])) * DISTANCEVALUE + DISTANCELEFTANDRIGHT - self.frame.size.width / 2;
    [UIView animateWithDuration:.15f animations:^{
        scrollView.contentOffset = CGPointMake(offX, 0);
    }completion:^(BOOL finished) {
        if (self.rulerDeletate) {
            scrollView.rulerValue = oX + scrollCurrentValue;
            scrollView.mode = NO;
            [self.rulerDeletate txhRrettyRuler:scrollView];
        }
    }];
}

- (void)drawRacAndLine {
    // 圆弧
    CAShapeLayer *shapeLayerArc = [CAShapeLayer layer];
    shapeLayerArc.strokeColor = [UIColor lightGrayColor].CGColor;
    shapeLayerArc.fillColor = [UIColor clearColor].CGColor;
    shapeLayerArc.lineWidth = 1.f;
    shapeLayerArc.lineCap = kCALineCapButt;
    shapeLayerArc.frame = self.bounds;

#warning CAGradientLayer
//    // 渐变
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = self.bounds;
//    
//    gradient.colors = @[(id)[RGB(37, 36, 99) colorWithAlphaComponent:1.f].CGColor,
//                        (id)[RGB(37, 36, 99) colorWithAlphaComponent:0.0f].CGColor,
//                        (id)[RGB(37, 36, 99) colorWithAlphaComponent:1.f].CGColor];
//    
//    gradient.locations = @[[NSNumber numberWithFloat:0.0f],
//                           [NSNumber numberWithFloat:0.5f]];
//    
//    gradient.startPoint = CGPointMake(0, .5);
//    gradient.endPoint = CGPointMake(1, .5);
//    
//    CGMutablePathRef pathArc = CGPathCreateMutable();
//    
//    CGPathMoveToPoint(pathArc, NULL, 0, DISTANCETOPANDBOTTOM);
//    CGPathAddQuadCurveToPoint(pathArc, NULL, self.frame.size.width / 2, - 20, self.frame.size.width, DISTANCETOPANDBOTTOM);
//    
//    shapeLayerArc.path = pathArc;
////    [self.layer addSublayer:shapeLayerArc];
//    [self.layer addSublayer:gradient];
    
    // 红色指示器
    CAShapeLayer *shapeLayerLine = [CAShapeLayer layer];
    shapeLayerLine.strokeColor = [UIColor redColor].CGColor;
    shapeLayerLine.fillColor = INDICATORCOLOR;
    shapeLayerLine.lineWidth = 1.f;
    shapeLayerLine.lineCap = kCALineCapSquare;
    
    NSUInteger ruleHeight = 20; // 文字高度
    CGMutablePathRef pathLine = CGPathCreateMutable();
    CGPathMoveToPoint(pathLine, NULL, self.frame.size.width / 2, self.frame.size.height - DISTANCETOPANDBOTTOM - ruleHeight);
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2, DISTANCETOPANDBOTTOM + SHEIGHT);
    
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2 - SHEIGHT / 2, DISTANCETOPANDBOTTOM);
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2 + SHEIGHT / 2, DISTANCETOPANDBOTTOM);
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2, DISTANCETOPANDBOTTOM + SHEIGHT);
    
    shapeLayerLine.path = pathLine;
    [self.layer addSublayer:shapeLayerLine];
}

#pragma mark - tool method

- (CGFloat)notRounding:(CGFloat)price afterPoint:(NSInteger)position
{
    NSDecimalNumberHandler*roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber*ouncesDecimal;
    NSDecimalNumber*roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc]initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [roundedOunces floatValue];
}

- (BOOL)valueIsInteger:(NSNumber *)number {
    NSString *value = [NSString stringWithFormat:@"%f",[number floatValue]];
    if (value != nil) {
        NSString *valueEnd = [[value componentsSeparatedByString:@"."] objectAtIndex:1];
        NSString *temp = nil;
        for(int i =0; i < [valueEnd length]; i++)
        {
            temp = [valueEnd substringWithRange:NSMakeRange(i, 1)];
            if (![temp isEqualToString:@"0"]) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)moveScrollView
{
    CGFloat offSetX = rulerScrollView.contentOffset.x + self.frame.size.width / 2 - DISTANCELEFTANDRIGHT;
    CGFloat oX = (offSetX / DISTANCEVALUE) * [rulerScrollView.rulerAverage floatValue];
    CGFloat offX = (oX / ([rulerScrollView.rulerAverage floatValue])) * DISTANCEVALUE + DISTANCELEFTANDRIGHT - self.frame.size.width / 2;
    NSNumber *count = [NSNumber numberWithInteger:rulerScrollView.rulerCount];
    CGFloat countFloat = [count floatValue]/100;
    if (countFloat > (oX+scrollCurrentValue))
    {
        [UIView animateWithDuration:.15f animations:^{
            rulerScrollView.contentOffset = CGPointMake(offX + DISTANCEVALUE*10, 0);
        }];
    }
}

- (void)moveScrollViewToZero
{
    rulerScrollView.contentOffset = CGPointMake(-(self.frame.size.width / 2.f + DISTANCELEFTANDRIGHT), 0);
}

- (TXHRulerScrollView *)getRulerScrollView
{
    CGFloat offSetX = rulerScrollView.contentOffset.x + self.frame.size.width / 2 - DISTANCELEFTANDRIGHT;
    CGFloat oX = (offSetX / DISTANCEVALUE) * [rulerScrollView.rulerAverage floatValue];

    if ([self valueIsInteger:rulerScrollView.rulerAverage]) {
        oX = [self notRounding:oX afterPoint:0];
    }
    else {
        oX = [self notRounding:oX afterPoint:1];
    }
    rulerScrollView.rulerValue = oX + scrollCurrentValue;
    return rulerScrollView;
}
@end
