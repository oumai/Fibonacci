//
//  BATShowResultView.h
//  NewPagedFlowViewDemo
//
//  Created by four on 2017/9/11.
//  Copyright © 2017年 robertcell.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATShowResultView : UIView

@property (nonatomic,strong) NSTimer *timer;

//黑色背景
@property (nonatomic,strong) UIView *blackBGView;

//蓝色背景
@property (nonatomic,strong) UIView *blueBGView;

@property (nonatomic,strong) UIImageView *lineImageView;

@property (nonatomic,strong) UILabel *leftNumberLable;
@property (nonatomic,strong) UILabel *leftUnitLabel;
@property (nonatomic,strong) UILabel *leftTitleLable;

@property (nonatomic,strong) UILabel *midNumberLable;
@property (nonatomic,strong) UILabel *midUnitLabel;
@property (nonatomic,strong) UILabel *midTitleLable;

@property (nonatomic,strong) UILabel *rightNumberLable;
@property (nonatomic,strong) UILabel *rightUnitLabel;
@property (nonatomic,strong) UILabel *rightTitleLable;

@property (nonatomic,strong) UIImageView *loveImageView;

@property (nonatomic,strong) UIView  *greenLine;
@property (nonatomic,strong) UIView *yellowLine;
@property (nonatomic,strong) UIView  *readLine;

@property (nonatomic,strong) UILabel *greenLabel;
@property (nonatomic,strong) UILabel *yellowLable;
@property (nonatomic,strong) UILabel *redLable;

@property (nonatomic,strong) UIButton *testButton;

@property (nonatomic,copy) void (^goTestBlock)();
@property (nonatomic,copy) void (^goResultBlock)();
@property (nonatomic,copy) void (^goHiddenSelfBlock)();


@property (nonatomic,assign) EDataType type;
@property (nonatomic,copy) NSNumber *valueNum;
@property (nonatomic,copy) NSNumber *leftNum;
@property (nonatomic,copy) NSNumber *RightNum;

- (void)reloadData;

- (void)creatTimer;

@end
