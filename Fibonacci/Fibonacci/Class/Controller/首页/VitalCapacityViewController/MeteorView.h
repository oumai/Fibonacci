//
//  MeteorView.h
//  Emitter
//
//  Created by woaiqiu947 on 2017/9/13.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeteorView : UIView
@property(nonatomic,strong) CAEmitterLayer *rainDropEmitterLayer;
- (void)addRainningEffect;
- (void)speed:(CGFloat)value;
- (void)stop;

@end
