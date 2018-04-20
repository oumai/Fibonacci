//
//  BloodSugarSlider.m
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/12/14.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "BloodSugarSlider.h"

@implementation BloodSugarSlider

- (void)dealloc
{
    _textField.delegate = nil;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIView *_maskView = [[UIView alloc] initWithFrame:self.bounds];
    _maskView.backgroundColor = RGBA(153,50,204, 0.1);
    _maskView.layer.cornerRadius = self.bounds.size.width/2;
    [self addSubview:_maskView];
    
    gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.colors = @[(__bridge id)RGB(31, 222, 255).CGColor,(__bridge id)RGB(33, 134, 245).CGColor];
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1, 0);
    CGFloat minX =15.f;
    CGFloat gradientW = (self.frame.size.height- minX*2);
    gradientLayer.frame = CGRectMake( minX, minX, gradientW, gradientW);
    gradientLayer.cornerRadius = gradientW/2;
    [_maskView.layer insertSublayer:gradientLayer atIndex:0];

    
    slider = [[JXCircleSlider alloc] initWithFrame:gradientLayer.frame];
    [slider addTarget:self action:@selector(newValue:) forControlEvents:UIControlEventValueChanged];
    [slider changeAngle:_angle*14.4];
    CGAffineTransform transform = CGAffineTransformIdentity;
    slider.transform = CGAffineTransformRotate(transform, M_PI*1.5);
    [self addSubview:slider];
    
    CGFloat textFieldW = (self.frame.size.width-minX)/1.75;
    CGFloat textFieldX = (self.frame.size.width - textFieldW)/2;

    _textField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, textFieldX, textFieldW, 60)];
    CGFloat fontSize = 70;
    if (iPhone5) {
        fontSize = 50;
        CGRect frame = _textField.frame;
        frame.origin.y = frame.origin.y-10;
        _textField.frame = frame;
    }
    _textField.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    _textField.text = [NSString stringWithFormat:@"%.1f",_angle];
    _textField.center = slider.center;
    _textField.textColor = [UIColor whiteColor];
    _textField.delegate = self;
    _textField.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_textField];
    
    CGFloat mmolY = CGRectGetMaxY(_textField.frame);
    CGFloat mmolH = 30;
    if (iPhone5) {
        mmolH = 20;
        mmolY = mmolY-10;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(textFieldX, mmolY, textFieldW, mmolH)];
    label.text = @"mmol/L";
    label.font = [UIFont fontWithName:@"Helvetica" size:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    if (_angle> 0) {
        UIView * maskView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:maskView];
        [self bringSubviewToFront:maskView];
    }
    
}

-(void)newValue:(JXCircleSlider*)view
{
    CGFloat value = view.angle;
    _angle = value/14.4;
    _textField.text = [NSString stringWithFormat:@"%.1f",_angle];
    [self setGradientColorValue:_angle type: _colorType];
}

- (void)setAngle:(CGFloat)angle
{
    _angle = angle;
    _textField.text = [NSString stringWithFormat:@"%.1f",_angle];
    [self setGradientColorValue:_angle type: _colorType];
}

- (void)setColorType:(EBloodSugarSliderColorType)colorType
{
    _colorType = colorType;
    [self setGradientColorValue:_angle type: colorType];
}

- (void)setGradientColorValue:(CGFloat)angle type:(EBloodSugarSliderColorType)type
{
    if (type == EBloodSugarSliderColorTypeDefault)
    {
        if (_angle >= 7.0)
        {
            gradientLayer.colors = @[(__bridge id)RGB(253, 175, 83).CGColor,(__bridge id)RGB(252, 147, 51).CGColor];
            return;
            
        }
    }
    else
    {
        if (_angle >= 10.0)
        {
            gradientLayer.colors = @[(__bridge id)RGB(253, 175, 83).CGColor,(__bridge id)RGB(252, 147, 51).CGColor];
            return;
        }
    }
    if (_angle > 4.5)
    {
        gradientLayer.colors = @[(__bridge id)RGB(38, 208, 254).CGColor,(__bridge id)RGB(33, 168, 255).CGColor];
    }
    else
    {
        gradientLayer.colors = @[(__bridge id)RGB(254, 112, 167).CGColor,(__bridge id)RGB(253, 80, 137).CGColor];
    }

}

#pragma mark -
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HidePickerView" object:nil];
    textField.text = @"";
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGFloat value = [textField.text floatValue];
    if (value>25) {
        value = 25.0;
    }
    _angle = value;
    slider.angle = _angle*14.4;
    _textField.text = [NSString stringWithFormat:@"%.1f",value];
    [self setGradientColorValue:_angle type: _colorType];
}

@end
