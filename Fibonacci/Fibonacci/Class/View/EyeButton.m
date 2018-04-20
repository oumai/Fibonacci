//
//  EyeButton.m
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/21.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "EyeButton.h"

@implementation EyeButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapRound;
    CGFloat rectW = self.frame.size.width / 3;
    CGFloat rectH = self.frame.size.height / 3;

    switch (eyeButtonTransformStatus)
    {
        case EyeButtonTransformStatusTop:
        {
            [path moveToPoint:CGPointMake(self.frame.size.width / 2, rectH)];
            [path addLineToPoint:CGPointMake(self.frame.size.width - rectW, self.frame.size.height - rectH)];
            [path addLineToPoint:CGPointMake(rectW, self.frame.size.height - rectH)];
        }
            break;
        case EyeButtonTransformStatusLeft:
        {
            [path moveToPoint:CGPointMake(self.frame.size.width/2-rectH/2, rectH)];
            [path addLineToPoint:CGPointMake(self.frame.size.width/2-rectH/2, self.frame.size.height - rectH)];
            [path addLineToPoint:CGPointMake(self.frame.size.width - rectW, self.frame.size.height / 2)];

        }
            break;
        case EyeButtonTransformStatusRight:
        {
            [path moveToPoint:CGPointMake(rectW, rectH)];
            [path addLineToPoint:CGPointMake(self.frame.size.width - rectW, rectH)];
            [path addLineToPoint:CGPointMake(self.frame.size.width / 2, self.frame.size.height - rectH)];

        }
            break;
        case EyeButtonTransformStatusBottom:
        {
            [path moveToPoint:CGPointMake(self.frame.size.width/2+rectH/2, rectW/2)];
            [path addLineToPoint:CGPointMake(self.frame.size.width/2+rectH/2, self.frame.size.height - rectH)];
            [path addLineToPoint:CGPointMake(rectW, self.frame.size.height/2)];
        }
            break;
        default:
            break;
    }
    // 最后的闭合线是可以通过调用closePath方法来自动生成的，也可以调用-addLineToPoint:方法来添加
    //  [path addLineToPoint:CGPointMake(20, 20)];
    [path closePath];
    // 设置线宽
    path.lineWidth = 1.0;
    // 设置填充颜色
    UIColor *fillColor = [UIColor whiteColor];
    [fillColor set];
    [path fill];
    // 设置画笔颜色
    UIColor *strokeColor = [UIColor whiteColor];
    [strokeColor set];
    // 根据我们设置的各个点连线
    [path stroke];
}

-(void)eyeButtonTransform:(EyeButtonTransformStatus)status
{
    eyeButtonTransformStatus = status;
    [self setNeedsDisplay];
}

@end
