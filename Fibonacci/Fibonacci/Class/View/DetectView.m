//
//  DetectView.m
//  testApp
//
//  Created by shipeiyuan on 2017/9/9.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import "DetectView.h"
@interface DetectView ()
@property (strong, nonatomic) UIBezierPath *path;
@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (strong, nonatomic) CAShapeLayer *bgLayer;
@property (strong, nonatomic) UIView *innerCircleView;
@property (assign, nonatomic) CGFloat lineWidth;
@property (assign, nonatomic) CGFloat innerWidth;
@end

#define degreesToRadian(x) (M_PI * (x) / 180.0)
@implementation DetectView


- (instancetype)initWithFrame:(CGRect)frame withLineWidth:(CGFloat)width innerLineWidth:(CGFloat)innerWidth
{

    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = width;
        _innerWidth = innerWidth;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    self.bgLayer.path = self.path.CGPath;
    self.shapeLayer.path = self.path.CGPath;
    [self.layer addSublayer:_bgLayer];
    [self.layer addSublayer:_shapeLayer];
    [self addSubview:self.innerCircleView];
}

#pragma mark - @property
- (CAShapeLayer *)bgLayer
{
    if (!_bgLayer) {
        _bgLayer = [CAShapeLayer layer];
        _bgLayer.frame = self.bounds;
        _bgLayer.fillColor = [UIColor clearColor].CGColor;
        _bgLayer.lineWidth = _lineWidth?_lineWidth:20.f;
        _bgLayer.strokeColor = RGB(20,21,112).CGColor; //
        _bgLayer.strokeStart = 0.f;
        _bgLayer.strokeEnd = 1.f;
    }
    return _bgLayer;
}

- (CAShapeLayer *)shapeLayer
{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.lineWidth = _bgLayer.lineWidth;
        _shapeLayer.lineCap = kCALineCapButt;
        _shapeLayer.strokeColor =  RGB(99,177,249).CGColor; //
        _shapeLayer.strokeStart = 0.75f;
        _shapeLayer.strokeEnd = 0.99;
        _shapeLayer.hidden = YES;
    }
    return _shapeLayer;
}

- (UIBezierPath *)path
{
    if (!_path) {
        _path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    }
    return _path;
}

- (UIView *)innerCircleView
{
    if (!_innerCircleView) {
        CGFloat lineWidth = _shapeLayer.lineWidth;
        CGFloat viewWidth = self.bounds.size.height - lineWidth*2;
        _innerCircleView = [[UIView alloc] initWithFrame:CGRectMake(_shapeLayer.lineWidth, _shapeLayer.lineWidth, viewWidth, viewWidth)];
        _innerCircleView.backgroundColor = [UIColor clearColor];
        CGPoint viewCenter = CGPointMake(_innerCircleView.frame.size.width / 2.0, _innerCircleView.frame.size.height / 2.0); // 画弧的中心点，相对于view
        CGFloat pathRadius = 0;
        CGFloat startAngle = 0.f;
        CGFloat endAngle = 0.f;
        CGFloat pathLineWidth = 0.f;
        for (int i = 0; i<6; i++) {
            if (i%2 == 0)
            {
                endAngle = 120 + i/2*120;
                startAngle = endAngle - 100;
                pathLineWidth = 2;
                pathRadius = (viewWidth-7)/2;
            }
            else
            {
                pathLineWidth = _innerWidth?_innerWidth:5.f;
                startAngle += 40;
                endAngle -= 40;
                pathRadius = (viewWidth-7-pathLineWidth)/2;
            }
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:viewCenter radius: pathRadius startAngle:degreesToRadian(startAngle) endAngle: degreesToRadian(endAngle) clockwise:YES];
            
            CAShapeLayer *pathLayer = [CAShapeLayer layer];
            pathLayer.lineWidth = pathLineWidth;
            pathLayer.strokeColor = RGB(99,177,249).CGColor;
            pathLayer.fillColor = nil;
            pathLayer.path = path.CGPath;
            [_innerCircleView.layer addSublayer:pathLayer];

        }
    }
    return _innerCircleView;
}

#pragma mark -
-(void)begin{
    
    _shapeLayer.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @0;
    animation.toValue = @(4*M_PI);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = HUGE_VALF;
    animation.duration = 5.0f;
    [_shapeLayer addAnimation:animation forKey:@"rotation"];
    
    int direction = -1;  //-1为逆时针
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation2.fromValue = @0;
    animation2.toValue = @(4*M_PI*direction);
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation2.repeatCount = HUGE_VALF;
    animation2.duration = 5.0f;
    [_innerCircleView.layer addAnimation:animation2 forKey:@"rotation"];
}

- (void)stop
{
    [_shapeLayer removeAnimationForKey: @"rotation"];
    _shapeLayer.hidden = YES;
    [_innerCircleView.layer removeAnimationForKey: @"rotation"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
