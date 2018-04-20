//
//  robotView.m
//  ParticleButton
//
//  Created by four on 2017/9/15.
//  Copyright © 2017年 HaiHu Liang. All rights reserved.
//

#import "RobotView.h"

@implementation RobotView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.emitterView = [[EmitterView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.emitterView];
        
        self.fireView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.fireView.image = [UIImage imageNamed:@"wen"];
        [self addSubview:self.fireView];
        
        [self drawRect];
    }
    return self;
}

-(void)drawRect
{
    //绘制路径
    CGMutablePathRef path = CGPathCreateMutable();

    CGPathAddRect(path, NULL, CGRectMake(20, self.frame.size.height - 20, 0, 0));

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.duration = 3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    animation.repeatCount = MAXFLOAT;
    animation.path = path;
    [self.emitterView.layer addAnimation:animation forKey:@"test"];
}

@end
