//
//  BATMenuView.m
//  NewPagedFlowViewDemo
//
//  Created by four on 2017/9/11.
//  Copyright © 2017年 robertcell.net. All rights reserved.
//

#import "BATMenuView.h"

//定义屏幕的宽和高
#define MainScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define MainScreenHeight ([UIScreen mainScreen].bounds.size.height)

#import "CommonMacro.h"
#import "Masonry.h"
#import "BlocksKit.h"
#import "BlocksKit+UIKit.h"
#import "WeakDefine.h"

@implementation BATMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self layoutPages];
    }
    
    return self;
}

- (void)layoutPages{
    WEAK_SELF(self);
    
    CGFloat btnHeight = 35;
    CGFloat btnWidtn = 100;
    
    [self addSubview:self.blackBGView];
    [self.blackBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.triangleView];
    [self.triangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(60);
        make.width.mas_offset(btnWidtn);
        make.height.mas_offset(btnHeight);
    }];
    
    [self addSubview:self.blueBGView];
    [self.blueBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(70);
        make.width.mas_offset(btnWidtn);
        make.height.mas_offset(btnHeight*3);
    }];
    
    UIView *Topline = [[UIView alloc]initWithFrame:CGRectZero];
    Topline.backgroundColor = UIColorFromHEX(0x76c8ff, 1);
    [self addSubview:Topline];
    [Topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blueBGView.mas_top).offset(btnHeight);
        make.left.equalTo(self.blueBGView.mas_left).offset(5);
        make.right.equalTo(self.blueBGView.mas_right).offset(-5);
        make.height.mas_offset(0.5);
    }];
    
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectZero];
    bottomLine.backgroundColor = UIColorFromHEX(0x76c8ff, 1);
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blueBGView.mas_top).offset(btnHeight*2);
        make.left.equalTo(self.blueBGView.mas_left).offset(5);
        make.right.equalTo(self.blueBGView.mas_right).offset(-5);
        make.height.mas_offset(0.5);
    }];
    
    
    [self.blueBGView addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.blueBGView.mas_centerX).offset(0);
        make.top.equalTo(self.blueBGView.mas_top).offset(0);
        make.width.mas_offset(btnWidtn);
        make.height.mas_offset(btnHeight);
    }];
    
    [self.blueBGView addSubview:self.phoneBtn];
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.blueBGView.mas_centerX).offset(0);
        make.top.equalTo(self.blueBGView.mas_top).offset(btnHeight);
        make.width.mas_offset(btnWidtn);
        make.height.mas_offset(btnHeight);
    }];
    
    [self.blueBGView addSubview:self.setBtn];
    [self.setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.blueBGView.mas_centerX).offset(0);
        make.top.equalTo(self.blueBGView.mas_top).offset(btnHeight*2);
        make.width.mas_offset(btnWidtn);
        make.height.mas_offset(btnHeight);
    }];
}

- (void)loginClick{
    if (self.goLoginBlock) {
        self.goLoginBlock();
    }
}

- (void)setBlock{
    if (self.goSetBlock) {
        self.goSetBlock();
    }
}

- (void)tellPhoneClick{
    if (self.goTellPhoneBlock) {
        self.goTellPhoneBlock();
    }
}


-(UIView *)blackBGView{
    if (!_blackBGView) {
        _blackBGView = [[UIView alloc] initWithFrame:CGRectZero];
        _blackBGView.backgroundColor = [UIColor clearColor];
        _blackBGView.userInteractionEnabled = YES;
        WEAK_SELF(self);
        [_blackBGView bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.goHiddenSelfBlock) {
                self.goHiddenSelfBlock();
            }
        }];
    }
    return  _blackBGView;
}

-(UIView *)blueBGView{
    if (!_blueBGView) {
        _blueBGView = [[UIView alloc] initWithFrame:CGRectZero];
        _blueBGView.backgroundColor = UIColorFromHEX(0x2a64b6, 1);
        _blueBGView.clipsToBounds = YES;
        _blueBGView.layer.cornerRadius = 5;
    }
    return  _blueBGView;
}

-(UIImageView *)triangleView{
    if (!_triangleView) {
        _triangleView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _triangleView.image = [UIImage imageNamed:@"Drop-down"];
    }
    return _triangleView;
}

-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:UIColorFromHEX(0x76c8ff, 1) forState:UIControlStateNormal];
        _loginBtn.titleLabel.font=[UIFont systemFontOfSize:14];
//        _loginBtn.backgroundColor = UIColorFromHEX(0x76c8ff, 1);
        [_loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

-(UIButton *)setBtn{
    if (!_setBtn) {
        _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setBtn setTitle:@"设置" forState:UIControlStateNormal];
        [_setBtn setTitleColor:UIColorFromHEX(0x76c8ff, 1) forState:UIControlStateNormal];
//        _setBtn.backgroundColor = UIColorFromHEX(0x76c8ff, 1);
        _setBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [_setBtn addTarget:self action:@selector(setBlock) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setBtn;
}

-(UIButton *)phoneBtn{
    if (!_phoneBtn) {
        _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneBtn setTitle:@"客服电话" forState:UIControlStateNormal];
        [_phoneBtn setTitleColor:UIColorFromHEX(0x76c8ff, 1) forState:UIControlStateNormal];
        _phoneBtn.titleLabel.font=[UIFont systemFontOfSize:14];
//        _phoneBtn.backgroundColor = UIColorFromHEX(0x76c8ff, 1);
        [_phoneBtn addTarget:self action:@selector(tellPhoneClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBtn;
}
@end
