//
//  WXWaveView.h
//
//  Created by WelkinXie on 16/4/20.
//  Copyright © 2016年 WelkinXie. All rights reserved.
//
//  Github: https://github.com/WelkinXie/WXWaveView
//

#import <UIKit/UIKit.h>

@interface WXWaveView : UIView
{
    NSInteger linkCount;
    NSInteger linkSchedule;
    BOOL scgedule;
}
@property (assign, nonatomic) CGFloat angularSpeed;
@property (assign, nonatomic) CGFloat waveSpeed;
@property (assign, nonatomic) NSTimeInterval waveTime;
@property (strong, nonatomic) UIColor *waveColor;
@property (assign, nonatomic) NSInteger viewType;

+ (instancetype)addToView:(UIView *)view withFrame:(CGRect)frame;


- (BOOL)wave;
- (void)stop;

@end



