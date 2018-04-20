//
//  HeartBackgroundView.m
//  Fibonacci
//
//  Created by shipeiyuan on 16/8/25.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "HeartBackgroundView.h"

@interface HeartBackgroundView()
@property(strong,nonatomic)UIBezierPath *path;
@property(strong,nonatomic)CAShapeLayer *shapeLayer;
@property(strong,nonatomic)CAShapeLayer *bgLayer;

@end

@implementation HeartBackgroundView
@synthesize lineWidth = _lineWidth;
@synthesize lineColr = _lineColr;
@synthesize value = _value;
//@synthesize heartBackgroundViewTransformStatus = _heartBackgroundViewTransformStatus;
//@synthesize strokeEndValue = _strokeEndValue;
- (void)dealloc
{
    _path = nil;
    _bgLayer = nil;
    _shapeLayer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame transformType:(HeartBackgroundViewTransformStatus)status
{
    heartBackgroundViewTransformStatus = status;
    return [self initWithFrame:frame ];
}

- (instancetype)initWithFrame:(CGRect)frame strokeEnd:(float)value
{
    strokeEndValue = value;
    return [self initWithFrame:frame ];
}

- (instancetype)initWithFrame:(CGRect)frame strokeEnd:(float)value transformType:(HeartBackgroundViewTransformStatus)status
{
    strokeEndValue = value;
    heartBackgroundViewTransformStatus = status;
    return [self initWithFrame:frame ];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bgLayer = [CAShapeLayer layer];
        _bgLayer.frame = self.bounds;
        _bgLayer.fillColor = [UIColor clearColor].CGColor;
        _bgLayer.lineWidth = 1.f;
        _bgLayer.strokeColor = RGB(212, 214, 224).CGColor;
        _bgLayer.strokeStart = 0.f;
        _bgLayer.strokeEnd = strokeEndValue>0?strokeEndValue:1;
        
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.lineWidth = 1.f;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.strokeColor = _lineColr.CGColor;
        _shapeLayer.strokeStart = 0.f;
        _shapeLayer.strokeEnd = 0.f;
    
        if (heartBackgroundViewTransformStatus == HeartBackgroundViewTransformStatusNarrow) {
            _path = [UIBezierPath bezierPath];
            [_path moveToPoint:CGPointMake(0, (self.frame.size.height-5)/2)];
            [_path addLineToPoint:CGPointMake(self.frame.size.width, (self.frame.size.height-5)/2)];
            _shapeLayer.lineWidth = 9;
            _bgLayer.lineWidth = 9;
        }
        else
        {
            _path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
        }
        _shapeLayer.path = _path.CGPath;
        _bgLayer.path = _path.CGPath;
        [self.layer addSublayer:_bgLayer];
        [self.layer addSublayer:_shapeLayer];
        [self heartBackgroundViewTransform:heartBackgroundViewTransformStatus];
        
    }
    return self;
}

-(void)closeStroke
{
    _shapeLayer.strokeColor = RGB(212, 214, 224).CGColor;
    _value = 0.f;
    _shapeLayer.strokeEnd = 0.f;
}

//-(void)setstrokeEndValue:(CGFloat)value{
//    if (value >0) {
//        _strokeEndValue = value;
//        _bgLayer.strokeEnd = value;
//    }
//    else
//    {
//        _strokeEndValue = 1.0f;
//        _bgLayer.strokeEnd = 1.0f;
//    }
//}
//
//-(CGFloat)strokeEndValue{
//    return _strokeEndValue;
//}

-(void)setValue:(CGFloat)value{
    _value = value;
    _shapeLayer.strokeColor = _lineColr.CGColor;
//    _shapeLayer.strokeEnd = value;
    if (heartBackgroundViewTransformStatus == HeartBackgroundViewTransformStatusNarrow) {
        CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnima.duration = 1.0f;
        pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnima.toValue = [NSNumber numberWithFloat:value];
        pathAnima.fillMode = kCAFillModeForwards;
        pathAnima.removedOnCompletion = NO;
        [_shapeLayer addAnimation:pathAnima forKey:@"strokeEndAnimation"];
    }
    else
    {
        _shapeLayer.strokeEnd = value;
    }
}

-(CGFloat)value{
    return _value;
}

-(void)setLineColr:(UIColor *)lineColr{
    _lineColr = lineColr;
    _shapeLayer.strokeColor = lineColr.CGColor;
}
-(UIColor*)lineColr{
    return _lineColr;
}

-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    _shapeLayer.lineWidth = lineWidth;
    _bgLayer.lineWidth = lineWidth;
}
-(CGFloat)lineWidth{
    return _lineWidth;
}

-(void)heartBackgroundViewTransform:(HeartBackgroundViewTransformStatus)status
{
    switch (status)
    {
        case HeartBackgroundViewTransformStatusTop:
        {
            CGAffineTransform transform = CGAffineTransformIdentity;
            self.transform = CGAffineTransformRotate(transform, -M_PI/2);
        }
            break;
        case HeartBackgroundViewTransformStatusLeft:
        {
            CGAffineTransform transform = CGAffineTransformIdentity;
            self.transform = CGAffineTransformRotate(transform, -M_PI*1.35);
            _bgLayer.lineCap = kCALineCapRound;
            _bgLayer.strokeColor = RGB(73, 140, 203).CGColor;
        }
            break;
        case HeartBackgroundViewTransformStatusNarrow:
        {
            _bgLayer.lineCap = kCALineCapRound;
        }
            break;
        default:
            break;
    }
}

@end
