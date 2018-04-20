//
//  DetectioResultView.m
//  Fibonacci
//
//  Created by shipeiyuan on 16/8/29.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "DetectioResultView.h"

@implementation DetectioResultView

@synthesize shadeType = _shadeType;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)setShadeType:(EShadeType)type
{
    _shadeType = type;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    for (CALayer * elem in self.layer.sublayers) {
        if ([elem isKindOfClass:[CAGradientLayer class]])
        {
            [elem removeFromSuperlayer];
        }
    }
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    switch (_shadeType) {
        case 0:
        {
            gradientLayer.colors = @[(__bridge id)RGB(139, 195, 73).CGColor,(__bridge id)RGB(139, 195, 73).CGColor,(__bridge id)RGB(241, 196, 19).CGColor, (__bridge id)RGB(241, 196, 19).CGColor, (__bridge id)RGB(247, 90, 90).CGColor, (__bridge id)RGB(247, 90, 90).CGColor];

            gradientLayer.locations = @[@(0.16), @(0.31), @(0.37), @(0.66), @(0.70), @(1.0)];
        }
            break;
        case 1:
        {
            gradientLayer.colors = @[(__bridge id)RGB(139, 195, 73).CGColor,(__bridge id)RGB(139, 195, 73).CGColor,(__bridge id)RGB(241, 196, 19).CGColor, (__bridge id)RGB(241, 196, 19).CGColor, (__bridge id)RGB(247, 90, 90).CGColor, (__bridge id)RGB(247, 90, 90).CGColor];

            gradientLayer.locations = @[@(0.16), @(0.35), @(0.40),  @(0.7), @(0.75), @(1.0)];
        }
            break;
        case 2:
        {
            gradientLayer.colors = @[(__bridge id)RGB(139, 195, 73).CGColor,(__bridge id)RGB(139, 195, 73).CGColor,(__bridge id)RGB(241, 196, 19).CGColor, (__bridge id)RGB(241, 196, 19).CGColor, (__bridge id)RGB(247, 90, 90).CGColor, (__bridge id)RGB(247, 90, 90).CGColor];

            gradientLayer.locations = @[@(0.16), @(0.38), @(0.42),  @(0.76), @(0.83), @(1.0)];
        }
            break;
        case 3:
        {
            gradientLayer.colors = @[(__bridge id)RGB(139, 195, 73).CGColor,(__bridge id)RGB(139, 195, 73).CGColor,(__bridge id)RGB(241, 196, 19).CGColor, (__bridge id)RGB(241, 196, 19).CGColor, (__bridge id)RGB(247, 90, 90).CGColor, (__bridge id)RGB(247, 90, 90).CGColor];
            gradientLayer.locations = @[@(0.16), @(0.42), @(0.46), @(0.83), @(0.88), @(1.0)];
        }
            break;
        case 4:
        {
            gradientLayer.colors = @[(__bridge id)RGB(139, 195, 73).CGColor,(__bridge id)RGB(139, 195, 73).CGColor,(__bridge id)RGB(241, 196, 19).CGColor, (__bridge id)RGB(241, 196, 19).CGColor,(__bridge id)RGB(90, 179, 248).CGColor, (__bridge id)RGB(90, 179, 248).CGColor, (__bridge id)RGB(248, 90, 90).CGColor, (__bridge id)RGB(248, 90, 90).CGColor];

            gradientLayer.locations = @[@(0), @(0.20), @(0.25), @(0.45), @(0.50), @(0.70), @(0.75), @(1.0)];
        }
            break;
            
        default:
            break;
    }
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer addSublayer: gradientLayer];
}


@end
