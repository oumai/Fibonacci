//
//  BATMenuView.h
//  NewPagedFlowViewDemo
//
//  Created by four on 2017/9/11.
//  Copyright © 2017年 robertcell.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATMenuView : UIView

//黑色背景
@property (nonatomic,strong) UIView *blackBGView;

//蓝色背景
@property (nonatomic,strong) UIView *blueBGView;
//三角形
@property (nonatomic,strong) UIImageView *triangleView;

@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIButton *setBtn;
@property (nonatomic,strong) UIButton *phoneBtn;

@property (nonatomic,copy) void (^goLoginBlock)();
@property (nonatomic,copy) void (^goSetBlock)();
@property (nonatomic,copy) void (^goHiddenSelfBlock)();
@property (nonatomic,copy) void (^goTellPhoneBlock)();

@end
