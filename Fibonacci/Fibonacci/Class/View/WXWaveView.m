//
//  WXWaveView.m
//
//  Created by WelkinXie on 16/4/20.
//  Copyright © 2016年 WelkinXie. All rights reserved.
//
//  Github: https://github.com/WelkinXie/WXWaveView
//

#import "WXWaveView.h"

@interface WXWaveView ()

@property (assign, nonatomic) CGFloat offsetX;
@property (assign, nonatomic) CGFloat offsetXX;
@property (assign, nonatomic) CGFloat offsetH;
@property (strong, nonatomic) CADisplayLink *waveDisplayLink;
@property (strong, nonatomic) CAShapeLayer *waveShapeLayer;
@property (strong, nonatomic) CAShapeLayer *waveMaskLayer;

@end

@implementation WXWaveView

- (void)dealloc
{
    [self.waveDisplayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self.waveDisplayLink invalidate];
    self.waveDisplayLink = nil;
    
    self.waveShapeLayer.path = nil;
    [self.waveShapeLayer removeFromSuperlayer];
    self.waveShapeLayer = nil;
    
    self.waveMaskLayer.path = nil;
    [self.waveMaskLayer removeFromSuperlayer];
    self.waveMaskLayer = nil;
}

+ (instancetype)addToView:(UIView *)view withFrame:(CGRect)frame {
    WXWaveView *waveView = [[self alloc] initWithFrame:frame];
    [view addSubview:waveView];
    return waveView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
    {
        [self basicSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder])
    {
        [self basicSetup];
    }
    return self;
}

- (void)basicSetup {
    _angularSpeed = 3.f;
    _waveSpeed = 3.f;
    _waveTime = 1.f;
    if (!_waveColor) {
        _waveColor = [UIColor whiteColor];
    }
}

- (void)setWaveColor:(UIColor *)waveColor
{
    if (waveColor) {
        _waveColor = nil;
        _waveColor = waveColor;
        self.waveMaskLayer.fillColor = self.waveColor.CGColor;
        self.waveShapeLayer.fillColor = self.waveColor.CGColor;
    }
}

- (BOOL)wave {
    [self stop];
    if (self.waveShapeLayer.path) {
        return NO;
    }
    self.waveShapeLayer = [CAShapeLayer layer];
    self.waveShapeLayer.fillColor = self.waveColor.CGColor;
    
    self.waveMaskLayer = [CAShapeLayer layer];
     self.waveMaskLayer.opacity = 0.5;
    self.waveMaskLayer.fillColor = self.waveColor.CGColor;

    [self.layer addSublayer:self.waveMaskLayer];
    [self.layer addSublayer:self.waveShapeLayer];

    switch (_viewType) {
        case 0:
        {
            self.waveDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(currentWave)];
        }
            break;
        case 1:
        {
            _offsetH = 10;
            self.waveMaskLayer.opacity = 0.7;
            self.waveShapeLayer.opacity = 0.7;
            self.waveDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(typeViewWave)];
        }
            break;
        case 2:
        {
            _offsetH = 10;
            self.waveMaskLayer.opacity = 0.1;
            self.waveDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(bloodSugarWave)];
        }
            break;
        default:
            break;
    }
    self.waveDisplayLink.frameInterval = 1;//设置为30FPS
    [self.waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    return YES;
}

- (void)currentWave {
    self.offsetX -= self.waveSpeed;
    self.offsetXX += self.waveSpeed;
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, height);
    CGFloat y = 0.f;
    for (CGFloat x = 0.f; x <= width ; x++) {
        y = height * sin(0.01 * (self.angularSpeed * x + self.offsetX));
        CGPathAddLineToPoint(path, NULL, x, y);
    }
    CGPathAddLineToPoint(path, NULL, width, height);
    CGPathAddLineToPoint(path, NULL, 0, height);
    CGPathCloseSubpath(path);
    self.waveShapeLayer.path = path;
    CGPathRelease(path);

    CGMutablePathRef pathTwo = CGPathCreateMutable();
    CGPathMoveToPoint(pathTwo, NULL, 0, height);
    CGFloat maskY = 0;
    for (CGFloat x = 0.f; x <= width ; x++) {
        maskY = height * sin(0.015 * (self.angularSpeed* x + self.offsetXX));
        CGPathAddLineToPoint(pathTwo, NULL, x, maskY);
    }
    CGPathAddLineToPoint(pathTwo, NULL, width, height);
    CGPathAddLineToPoint(pathTwo, NULL, 0, height);
    CGPathCloseSubpath(pathTwo);
    self.waveMaskLayer.path = pathTwo;
    CGPathRelease(pathTwo);
}

//
- (void)typeViewWave
{
    self.offsetX -= self.waveSpeed;
    self.offsetXX += self.waveSpeed;
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat baseH = CGRectGetHeight(self.frame);
    CGFloat height = _offsetH;
    if (linkCount%200 == 0)
    {
        if (_offsetH<15 && !scgedule)
        {
            _offsetH = _offsetH +0.2;
        }
        else
        {
            scgedule = YES;
            if (_offsetH >10)
            {
                _offsetH = _offsetH -0.2;
            }
            else
            {
                _offsetH = 10;
                linkCount = 1;
                scgedule = NO;
            }
        }
    }
    else
    {
        linkCount ++;
    }

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, baseH);
    CGFloat y = 0.f;
    for (CGFloat x = 0.f; x <= width ; x++) {
        y = height * sin(0.01 * ((self.angularSpeed+1) * x - self.offsetX));
        CGPathAddLineToPoint(path, NULL, x, y);
    }
    CGPathAddLineToPoint(path, NULL, width, baseH);
    CGPathAddLineToPoint(path, NULL, 0, baseH);
    CGPathCloseSubpath(path);
    self.waveShapeLayer.path = path;
    CGPathRelease(path);
    
    CGMutablePathRef pathTwo = CGPathCreateMutable();
    CGPathMoveToPoint(pathTwo, NULL, 0, baseH);
    CGFloat maskY = 0;
    for (CGFloat x = 0; x <= width ; x++) {
        maskY = height * cos(0.01 * ((self.angularSpeed+1)* x + self.offsetXX));
        CGPathAddLineToPoint(pathTwo, NULL, x, maskY);
    }
    CGPathAddLineToPoint(pathTwo, NULL, width, baseH);
    CGPathAddLineToPoint(pathTwo, NULL, 0, baseH);
    CGPathCloseSubpath(pathTwo);
    self.waveMaskLayer.path = pathTwo;
    CGPathRelease(pathTwo);
}

- (void)bloodSugarWave
{
    self.offsetX -= self.waveSpeed;
    self.offsetXX += self.waveSpeed;
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat baseH = CGRectGetHeight(self.frame);
    CGFloat height = _offsetH;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, baseH);
    CGFloat y = 0.f;
    for (CGFloat x = 0.f; x <= width ; x++) {
        y = height * sin(0.01 * (self.angularSpeed * x + self.offsetX));
        CGPathAddLineToPoint(path, NULL, x, y);
    }
    CGPathAddLineToPoint(path, NULL, width, baseH);
    CGPathAddLineToPoint(path, NULL, 0, baseH);
    CGPathCloseSubpath(path);
    self.waveShapeLayer.path = path;
    CGPathRelease(path);
    
    CGMutablePathRef pathTwo = CGPathCreateMutable();
    CGPathMoveToPoint(pathTwo, NULL, 0, baseH);
    CGFloat maskY = 0;
    for (CGFloat x = 0.f; x <= width ; x++) {
        maskY = height * sin(0.015 * (self.angularSpeed* x + self.offsetXX));
        CGPathAddLineToPoint(pathTwo, NULL, x, maskY);
    }
    CGPathAddLineToPoint(pathTwo, NULL, width, baseH);
    CGPathAddLineToPoint(pathTwo, NULL, 0, baseH);
    CGPathCloseSubpath(pathTwo);
    self.waveMaskLayer.path = pathTwo;
    CGPathRelease(pathTwo);
}

- (void)stop
{
    [self.waveDisplayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self.waveDisplayLink invalidate];
    self.waveDisplayLink = nil;
    
    self.waveShapeLayer.path = nil;
    [self.waveShapeLayer removeFromSuperlayer];
    self.waveShapeLayer = nil;
    
    self.waveMaskLayer.path = nil;
    [self.waveMaskLayer removeFromSuperlayer];
    self.waveMaskLayer = nil;
}

@end
