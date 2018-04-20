//
//  MeteorView.m
//  Emitter
//
//  Created by woaiqiu947 on 2017/9/13.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import "MeteorView.h"

@interface MeteorView()

//@property(nonatomic,strong) CAEmitterLayer *sunshineEmitterLayer;

@property(nonatomic,strong) UIImageView *backgroundView;
@property(nonatomic, strong)CAEmitterCell *emitterCell;
@end


@implementation MeteorView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self addSubview:self.backgroundView];
    }
    return self;
}

-(void)addRainningEffect{
    
    
       // _rainDropEmitterLayer.transform=CATransform3DMakeRotation(-M_PI/4, 0, 0, 1);
    self.rainDropEmitterLayer.emitterCells=@[self.emitterCell];
    [self.layer addSublayer:_rainDropEmitterLayer];
}

#pragma mark -
- (CAEmitterLayer *)rainDropEmitterLayer
{
    if (!_rainDropEmitterLayer) {
        _rainDropEmitterLayer = [CAEmitterLayer layer];
        _rainDropEmitterLayer.emitterPosition=CGPointMake(100, 0);
        _rainDropEmitterLayer.emitterSize=CGSizeMake(MainScreenWidth*3, 0);
        //发射模式
        _rainDropEmitterLayer.emitterMode=kCAEmitterLayerOutline;
        //粒子模式
        _rainDropEmitterLayer.emitterShape=kCAEmitterLayerLine;
        
        //设置粒子旋转角速度
        
        _rainDropEmitterLayer.shadowOpacity=1.0;
        _rainDropEmitterLayer.shadowRadius=2;
        _rainDropEmitterLayer.shadowOffset=CGSizeMake(1, 1);
        _rainDropEmitterLayer.shadowColor=[UIColor whiteColor].CGColor
        ;

    }
    return _rainDropEmitterLayer;
}

- (CAEmitterCell *)emitterCell
{
    if (!_emitterCell) {
        _emitterCell = [CAEmitterCell emitterCell];
        _emitterCell.contents=(__bridge id)([UIImage imageNamed:@"meteor"].CGImage);
        _emitterCell.scale = 0.04;
        _emitterCell.scaleRange = 0.1;
        //每秒粒子产生数量
        _emitterCell.birthRate = 30;
        _emitterCell.lifetime = 60;
        _emitterCell.lifetimeRange = 100;
        _emitterCell.alphaSpeed = -0.1;
        _emitterCell.velocity= 10;
        _emitterCell.velocityRange = 30;
         //_emitterCell.xAcceleration = -2;
        _emitterCell.yAcceleration = 5;
        //_emitterCell.spin=M_PI_4;
        //设置发射角度
        _emitterCell.emissionLongitude= 5*M_PI/4;

    }
    return _emitterCell;
}

//- (UIImageView *)backgroundView
//{
//    if (!_backgroundView) {
//        _backgroundView = [[UIImageView alloc]initWithFrame:self.bounds];
//        _backgroundView.image = [UIImage imageNamed:@"background"];
//    }
//    return _backgroundView;
//}

#pragma mark - 
- (void)speed:(CGFloat)value
{
    CGFloat velocity = 10+value*300;
    CGFloat yAcceleration = 5+value*40;
//    NSLog(@"=== %f",value);
//    NSLog(@"=== %f",velocity);
//    NSLog(@"=== %f",yAcceleration);

    _emitterCell.yAcceleration = yAcceleration;
    _emitterCell.velocity = velocity;
//    _rainDropEmitterLayer.velocity = 1+value*10;
    _rainDropEmitterLayer.emitterCells = nil;
    _rainDropEmitterLayer.emitterCells=@[self.emitterCell];
}

- (void)stop
{
    _emitterCell.birthRate = 0;
    _emitterCell = nil;
    for (CALayer *elem in self.layer.sublayers) {
        if ([elem isKindOfClass:[CAEmitterLayer class]]) {
            [elem removeFromSuperlayer];
        }
    }
    _rainDropEmitterLayer.emitterCells = nil;
    _rainDropEmitterLayer = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
