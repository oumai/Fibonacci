//
//  GFWaterView.m
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/1.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "GFWaterView.h"

@implementation GFWaterView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGFloat rabius = rect.size.height/2;
    // 开始角
    CGFloat startAngle = 0;
    // 中心点
    CGPoint point = CGPointMake(rect.size.width/2, rect.size.height/2);  // 中心店我手动写的,你看看怎么弄合适 自己在搞一下
    // 结束角
    CGFloat endAngle = 2*M_PI;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:rabius startAngle:startAngle endAngle:endAngle clockwise:YES];

    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.path = path.CGPath;       // 添加路径 下面三个同理
    
    layer.strokeColor = [UIColor colorWithRed:84.0/255.0 green:153.0/255.0 blue:253.0/255.0 alpha:1.0].CGColor;
    layer.fillColor = [UIColor colorWithRed:84.0/255.0 green:153.0/255.0 blue:253.0/255.0 alpha:1.0].CGColor;
    [self.layer addSublayer:layer];
}


@end
