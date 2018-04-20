
//
//  BodyHudView.m
//  Fibonacci
//
//  Created by shipeiyuan on 2017/2/20.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import "BodyHudView.h"

@implementation BodyHudView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(void)presentBodyHudView:(float)y
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    blackView.backgroundColor = UIColorFromHEX(00000, 0);
    blackView.tag = 30001;
    [window addSubview:blackView];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [blackView addGestureRecognizer:tapGesture];
    
    UIView *hudView = [[UIView alloc] initWithFrame:CGRectMake(50, y, 200, 120)];
//    hudView.backgroundColor = [UIColor whiteColor];
    hudView.tag = 30002;
    hudView.alpha = 0;
    [blackView addSubview:hudView];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapRound;
    [path moveToPoint:CGPointMake(0, 10)];
    [path addLineToPoint:CGPointMake(10, 0)];
    [path addLineToPoint:CGPointMake(20, 10)];
    [path closePath];
    path.lineWidth = 1.0;
    UIColor *fillColor = [UIColor whiteColor];
    [fillColor set];
    [path fill];
    UIColor *strokeColor = [UIColor whiteColor];
    [strokeColor set];
    [path stroke];
    CAShapeLayer* maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    UIView *hehe = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 20, 10)];
//    hehe.backgroundColor = [UIColor whiteColor];
    [hehe.layer addSublayer:maskLayer];
    [hudView addSubview:hehe];

    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 10, 200, 110)];
    textView.text = @"体脂率反映人体内脂肪含量的多少，了解你的身体脂肪率也能帮助你决定你的减肥目标是否实际。请记得，减肥不等于减少体重。";
    textView.editable = NO;
    textView.font = [UIFont fontWithName:AppFontHelvetica size:13];
    [hudView addSubview:textView];
    
    [UIView animateWithDuration:0.35f animations:^{
        hudView.alpha = 1.0f;
        blackView.backgroundColor = UIColorFromHEX(00000, 0.35);
    } completion:^(BOOL finished) {
    }];
}

+(void)dismiss
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:30001];
    UIView *helpView = [window viewWithTag:30002];
    
    //为了弹窗不那么生硬，这里加了个简单的动画
    [UIView animateWithDuration:0.15f animations:^{
        helpView.alpha = 0;
        blackView.alpha = 0;
    } completion:^(BOOL finished) {
        for (UIView *elem in helpView.subviews) {
            if ([elem isKindOfClass:[UIImageView class]])
            {
                UIImageView *view = (UIImageView *)elem;
                view.image = nil;
            }
            [elem removeFromSuperview];
        }
        [helpView removeFromSuperview];
        [blackView removeFromSuperview];
    }];
    
}
@end
