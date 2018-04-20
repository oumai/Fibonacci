//
//  StepCountProgress.m
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/11/21.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "StepCountProgress.h"

@implementation StepCountProgress


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:CGPointMake(0, self.frame.size.height/2)];
    [bezier addLineToPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
//    // 将path绘制出来
//    [bezier stroke];
    
    CAShapeLayer *_shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = self.bounds;
    _shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    _shapeLayer.strokeColor = AppColor.CGColor;
    _shapeLayer.lineWidth = 10;
    _shapeLayer.lineCap = kCALineCapRound;
    _shapeLayer.path = bezier.CGPath;
    [self.layer addSublayer:_shapeLayer];
}


@end
