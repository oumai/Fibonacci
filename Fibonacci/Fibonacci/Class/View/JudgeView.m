//
//  JudgeView.m
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/21.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "JudgeView.h"

@implementation JudgeView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (instancetype)initWithFrame:(CGRect)frame status:(JudgeViewStatus)status
{
    self = [super initWithFrame:frame];
    if (self) {
        judgeViewStatus = status;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame status:(JudgeViewStatus)status removeCircle:(BOOL)circle
{
    self = [super initWithFrame:frame];
    if (self) {
        judgeViewStatus = status;
        removeCircle = circle;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {

    UIBezierPath *path;
    if (removeCircle) {
        path = [UIBezierPath bezierPath];

    }
    else
    {
        path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(1, 1, self.frame.size.width-2, self.frame.size.height-2) cornerRadius:self.frame.size.height/2];
    }
    switch (judgeViewStatus) {
        case JudgeViewStatusError:
        {
            path.lineWidth = 2.f;
            UIColor *fillColor = [UIColor clearColor];
            [fillColor set];
            [path fill];
            UIColor *strokeColor =[UIColor redColor];
            [strokeColor set];
            [path moveToPoint:CGPointMake(self.frame.size.width*0.3 , self.frame.size.height*0.3)];
            [path addLineToPoint:CGPointMake(self.frame.size.width*0.7, self.frame.size.height*0.7)];
            [path moveToPoint:CGPointMake(self.frame.size.width*0.7 , self.frame.size.height*0.3)];
            [path addLineToPoint:CGPointMake(self.frame.size.width*0.3, self.frame.size.height*0.7)];
        }
            break;
        case JudgeViewStatusRight:
        {

            path.lineWidth = 2.f;
            UIColor *fillColor = [UIColor clearColor];
            [fillColor set];
            [path fill];
            UIColor *strokeColor = RGB(143, 205, 104);
            [strokeColor set];
            [path moveToPoint:CGPointMake(self.frame.size.width*0.2 , self.frame.size.height*0.5)];
            [path addLineToPoint:CGPointMake(self.frame.size.width*0.4, self.frame.size.height*0.7)];
            
            [path addLineToPoint:CGPointMake(self.frame.size.width*0.8, self.frame.size.height*0.3)];
        }
            break;
        case JudgeViewStatusButton:
        {
            path.lineWidth = 1.f;
            UIColor *fillColor = [UIColor clearColor];
            [fillColor set];
            [path fill];
            UIColor *strokeColor =[UIColor whiteColor];
            [strokeColor set];
            [path moveToPoint:CGPointMake(self.frame.size.width*0.3 , self.frame.size.height*0.3)];
            [path addLineToPoint:CGPointMake(self.frame.size.width*0.7, self.frame.size.height*0.7)];
            [path moveToPoint:CGPointMake(self.frame.size.width*0.7 , self.frame.size.height*0.3)];
            [path addLineToPoint:CGPointMake(self.frame.size.width*0.3, self.frame.size.height*0.7)];
        }
            break;
        default:
            break;
    }

    [path stroke];

}


@end
