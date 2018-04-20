//
//  robotView.h
//  ParticleButton
//
//  Created by four on 2017/9/15.
//  Copyright © 2017年 HaiHu Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EmitterView.h"

@interface RobotView : UIView

@property (nonatomic,strong) UIImageView *fireView;

@property (nonatomic,strong) EmitterView *emitterView;

- (void)drawRect;

@end
