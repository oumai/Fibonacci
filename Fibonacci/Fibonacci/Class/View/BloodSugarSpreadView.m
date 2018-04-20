//
//  BloodSugarSpreadView.m
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/12/13.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "BloodSugarSpreadView.h"

@implementation BloodSugarSpreadView
@synthesize type = _type;

- (void)dealloc
{
    [_maskView removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame status:(BloodSugarSpreadType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGFloat rabius = rect.size.height/2;
    // 开始角
    CGFloat startAngle = 0;
    // 中心点
    CGPoint point = CGPointMake(rect.size.width/2, rect.size.height/2);
    // 结束角
    CGFloat endAngle = 2*M_PI;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:rabius-1 startAngle:startAngle endAngle:endAngle clockwise:YES];
    [path closePath];

    _maskView =[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_maskView];
    
    masklayer = [[CAShapeLayer alloc]init];
    masklayer.path = path.CGPath;       // 添加路径 下面三个同理
    [_maskView.layer addSublayer:masklayer];
    
    gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.startPoint = CGPointMake(1, 1);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    gradientLayer.cornerRadius = rabius;
    [self setType:_type];
    [self.layer addSublayer: gradientLayer];
    
    UIBezierPath *addPath = [UIBezierPath bezierPath];
    addPath.lineCapStyle = kCGLineCapRound;
    [addPath moveToPoint:CGPointMake(self.frame.size.width*0.5 , self.frame.size.height*0.35)];
    [addPath addLineToPoint:CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.65)];
    [addPath moveToPoint:CGPointMake(self.frame.size.width*0.35 , self.frame.size.height*0.5)];
    [addPath addLineToPoint:CGPointMake(self.frame.size.width*0.65, self.frame.size.height*0.5)];
    [addPath closePath];

    [addPath stroke];
    CAShapeLayer *addLayer = [[CAShapeLayer alloc]init];
    addLayer.lineWidth = 3.0;
    addLayer.path = addPath.CGPath;       // 添加路径 下面三个同理
    addLayer.strokeColor = [UIColor whiteColor].CGColor;
    addLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:addLayer];
}

- (void)setType:(BloodSugarSpreadType)type
{
    _type = type;
    switch (_type) {
        case BloodSugarSpreadTypeDefault:
        {
            gradientLayer.colors =  @[(__bridge id)RGB(38, 208, 254).CGColor,(__bridge id)RGB(33, 168, 255).CGColor];
            masklayer.strokeColor = RGB(38, 208, 254).CGColor;
            masklayer.fillColor = RGB(38, 208, 254).CGColor;
        }
            break;
        case BloodSugarSpreadTypeLow:
        {
            gradientLayer.colors = @[(__bridge id)RGB(254, 112, 167).CGColor,(__bridge id)RGB(253, 80, 137).CGColor];
            masklayer.strokeColor = RGB(226, 210, 216).CGColor;
            masklayer.fillColor = RGB(226, 210, 216).CGColor;
        }
            break;
        case BloodSugarSpreadTypeHeight:
        {
            gradientLayer.colors = @[(__bridge id)RGB(253, 175, 83).CGColor,(__bridge id)RGB(252, 147, 51).CGColor];
            masklayer.strokeColor = RGB(232, 224, 211).CGColor;
            masklayer.fillColor = RGB(232, 224, 211).CGColor;
        }
            break;
            
        default:
            break;
    }
}
@end
