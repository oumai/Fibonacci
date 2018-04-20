//
//  BATShowResultView.m
//  NewPagedFlowViewDemo
//
//  Created by four on 2017/9/11.
//  Copyright © 2017年 robertcell.net. All rights reserved.
//

#import "BATShowResultView.h"
//定义屏幕的宽和高
#define MainScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define MainScreenHeight ([UIScreen mainScreen].bounds.size.height)

#import "CommonMacro.h"
#import "Masonry.h"
#import "BlocksKit.h"
#import "BlocksKit+UIKit.h"
#import "WeakDefine.h"

//model
#import "BloodOxygenDataModel.h"
#import "BloodPressureDataModel.h"
//#import "VisionDataModel.h"
//#import "BloodSugarDataModel.h"
#import "HeartRateDataModel.h"
#import "VitalCapacityDataModel.h"

@implementation BATShowResultView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self creatTimer];
        
        [self layoutPages];
    }
    
    return self;
}

- (void)creatTimer{
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(shakeView) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)shakeView{
    [UIView animateWithDuration:0.1 animations:^{
        self.lineImageView.frame = CGRectMake(self.lineImageView.frame.origin.x, self.lineImageView.frame.origin.y+10, self.lineImageView.frame.size.width, self.lineImageView.frame.size.height);
        
    }];
    
    [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.lineImageView.frame = CGRectMake(self.lineImageView.frame.origin.x, self.lineImageView.frame.origin.y-10, self.lineImageView.frame.size.width, self.lineImageView.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            self.lineImageView.frame = CGRectMake(self.lineImageView.frame.origin.x, self.lineImageView.frame.origin.y+10, self.lineImageView.frame.size.width, self.lineImageView.frame.size.height);
            
        }];
        
        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
            self.lineImageView.frame = CGRectMake(self.lineImageView.frame.origin.x, self.lineImageView.frame.origin.y-10, self.lineImageView.frame.size.width, self.lineImageView.frame.size.height);
            
            
        } completion:^(BOOL finished) {
            
            
        }];
    }];
}

- (void)layoutPages{
    WEAK_SELF(self);
    
    CGFloat bigHeight;
    if (iPhone5) {
        bigHeight = MainScreenWidth + 10;
    }else if (iPhone6){
        bigHeight = MainScreenWidth + 30;
    }else if (iPhone6p){
        bigHeight = MainScreenWidth - 40;
    }else{
        //X
        bigHeight = MainScreenWidth - 10;
    }
    
    
    [self addSubview:self.blackBGView];
    [self.blackBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.blueBGView];
    [self.blueBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.center.equalTo(self);
        make.width.mas_equalTo(MainScreenWidth - 40);
        make.height.mas_equalTo(bigHeight);
    }];
    
    [self.blueBGView addSubview:self.lineImageView];
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.blueBGView.mas_centerX).offset(0);
        make.top.equalTo(self.blueBGView.mas_top).offset(31);
        make.width.mas_equalTo(MainScreenWidth - 40 - 100);
        make.height.mas_equalTo(40);
    }];
    
    
    [self.blueBGView addSubview:self.midNumberLable];
    [self.midNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.blueBGView.mas_centerX).offset(-7.5);
        make.top.equalTo(self.lineImageView.mas_bottom).offset(20);
    }];
    
    [self.blueBGView addSubview:self.midUnitLabel];
    [self.midUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.blueBGView.mas_centerX).offset(7.5);
        make.bottom.equalTo(self.midNumberLable.mas_centerY).offset(-5);
    }];
    
    [self.blueBGView addSubview:self.midTitleLable];
    [self.midTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.blueBGView.mas_centerX).offset(7.5);
        make.top.equalTo(self.midNumberLable.mas_centerY).offset(5);
    }];
    
    [self.blueBGView addSubview:self.rightNumberLable];
    [self.rightNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.blueBGView.mas_centerX).offset(20);
        make.top.equalTo(self.lineImageView.mas_bottom).offset(20);
    }];
    
    [self.blueBGView addSubview:self.rightUnitLabel];
    [self.rightUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.rightNumberLable.mas_right).offset(15);
        make.bottom.equalTo(self.rightNumberLable.mas_centerY).offset(-5);
    }];
    
    [self.blueBGView addSubview:self.rightTitleLable];
    [self.rightTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.rightNumberLable.mas_right).offset(15);
        make.top.equalTo(self.rightNumberLable.mas_centerY).offset(5);
    }];
    
    [self.blueBGView addSubview:self.leftUnitLabel];
    [self.leftUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.blueBGView.mas_centerX).offset(-20);
        make.bottom.equalTo(self.rightUnitLabel.mas_bottom).offset(0);
        make.width.mas_equalTo(30);
    }];
    
    [self.blueBGView addSubview:self.leftTitleLable];
    [self.leftTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.blueBGView.mas_centerX).offset(-20);
        make.bottom.equalTo(self.rightTitleLable.mas_bottom).offset(0);
        make.width.mas_equalTo(30);
    }];
    
    [self.blueBGView addSubview:self.leftNumberLable];
    [self.leftNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.leftUnitLabel.mas_left).offset(-15);
        make.top.equalTo(self.rightNumberLable.mas_top).offset(0);
    }];
    
    
    [self.blueBGView addSubview:self.loveImageView];
    [self.loveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.blueBGView.mas_centerX).offset(0);
        make.top.equalTo(self.lineImageView.mas_bottom).offset(80);
        make.height.width.mas_equalTo(20);
    }];
    
    [self.blueBGView addSubview:self.greenLine];
    [self.greenLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.blueBGView.mas_left).offset(25);
        make.top.equalTo(self.loveImageView.mas_bottom).offset(1);
        make.width.mas_equalTo((MainScreenWidth - 40 - 50)/3 + 5);
        make.height.mas_offset(10);
    }];
    
    [self.blueBGView addSubview:self.readLine];
    [self.readLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.blueBGView.mas_right).offset(-25);
        make.top.equalTo(self.loveImageView.mas_bottom).offset(1);
        make.width.mas_equalTo((MainScreenWidth - 40 - 50)/3 + 5);
        make.height.mas_offset(10);
    }];
    
    [self.blueBGView addSubview:self.yellowLine];
    [self.yellowLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.blueBGView.mas_centerX).offset(0);
        make.top.equalTo(self.loveImageView.mas_bottom).offset(1);
        make.width.mas_equalTo((MainScreenWidth - 40 - 50)/3);
        make.height.mas_offset(10);
    }];
    
    
    [self.blueBGView addSubview:self.greenLabel];
    [self.greenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.greenLine.mas_centerX).offset(0);
        make.top.equalTo(self.greenLine.mas_bottom).offset(20);
    }];
    
    [self.blueBGView addSubview:self.yellowLable];
    [self.yellowLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.yellowLine.mas_centerX).offset(0);
        make.top.equalTo(self.yellowLine.mas_bottom).offset(20);
    }];
    
    [self.blueBGView addSubview:self.redLable];
    [self.redLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.readLine.mas_centerX).offset(0);
        make.top.equalTo(self.readLine.mas_bottom).offset(20);
    }];
    
    [self.blueBGView addSubview:self.testButton];
    [self.testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.blueBGView.mas_centerX).offset(0);
        make.bottom.equalTo(self.blueBGView.mas_bottom).offset(-35);
        make.width.mas_offset(150);
        make.height.mas_offset(50);
    }];
}

- (void)goTest{
    if (self.goTestBlock) {
        self.goTestBlock();
    }
}

- (void)reloadData{
    
    CGFloat rectFloat = 0.0;
    WEAK_SELF(self);
    
    //先变成变高的高度
    CGFloat bigHeight;
    if (iPhone5) {
        bigHeight = MainScreenWidth + 10;
    }else if (iPhone6){
        bigHeight = MainScreenWidth + 30;
    }else if (iPhone6p){
        bigHeight = MainScreenWidth - 40;
    }else{
        //X
        bigHeight = MainScreenWidth - 10;
    }
    [self.blueBGView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(bigHeight);
    }];
    
    //先全影藏
    self.midUnitLabel.hidden = YES;
    self.midTitleLable.hidden = YES;
    self.midNumberLable.hidden = YES;
    self.leftNumberLable.hidden = YES;
    self.leftUnitLabel.hidden = YES;
    self.leftTitleLable.hidden = YES;
    self.rightNumberLable.hidden = YES;
    self.rightUnitLabel.hidden = YES;
    self.rightTitleLable.hidden = YES;
    
    
    self.greenLine.hidden = YES;
    self.yellowLine.hidden = YES;
    self.readLine.hidden = YES;
    self.greenLabel.hidden = YES;
    self.yellowLable.hidden = YES;
    self.redLable.hidden = YES;
    self.loveImageView.hidden = YES;
    
    self.greenLabel.text = @"偏低";
    self.yellowLable.text = @"正常";
    self.redLable.text = @"偏高";
    
    
    switch (self.type) {
        case EDataBloodOxygenType:
        {
            //血氧====，85-95%，90%中间
            self.loveImageView.hidden = NO;
            self.greenLine.hidden = NO;
            self.yellowLine.hidden = NO;
            self.readLine.hidden = NO;
            self.greenLabel.hidden = NO;
            self.yellowLable.hidden = NO;
            self.redLable.hidden = NO;
            
            self.midUnitLabel.hidden = NO;
            self.midTitleLable.hidden = NO;
            self.midNumberLable.hidden = NO;
            self.midNumberLable.text = [NSString stringWithFormat:@"%@",self.valueNum];
            self.midUnitLabel.text = @"%";
            self.midTitleLable.text =@"血氧";
            
            CGFloat valueFloat = [self.valueNum floatValue] - 90;
            
            //爱心左右偏移5
            if(fabs(valueFloat) > 5){
                if(valueFloat > 0){
                    [self.blueBGView addSubview:self.loveImageView];
                    [self.loveImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        STRONG_SELF(self);
                        make.top.equalTo(self.lineImageView.mas_bottom).offset(80);
                        make.height.width.mas_equalTo(20);
                        make.centerX.equalTo(self.readLine.mas_centerX).offset(-20);
                    }];
                }else{
                    [self.blueBGView addSubview:self.loveImageView];
                    [self.loveImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        STRONG_SELF(self);
                        make.top.equalTo(self.lineImageView.mas_bottom).offset(80);
                        make.height.width.mas_equalTo(20);
                        make.centerX.equalTo(self.greenLine.mas_centerX).offset(20);
                    }];
                }
            }else{
                rectFloat = (MainScreenWidth - 40 - 50)/3.0/2.0/5.0*valueFloat;
                if(valueFloat > 0){
                    [self.blueBGView addSubview:self.loveImageView];
                    [self.loveImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        STRONG_SELF(self);
                        make.top.equalTo(self.lineImageView.mas_bottom).offset(80);
                        make.height.width.mas_equalTo(20);
                        make.centerX.equalTo(self.yellowLine.mas_centerX).offset(rectFloat);
                    }];
                }else{
                    [self.blueBGView addSubview:self.loveImageView];
                    [self.loveImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        STRONG_SELF(self);
                        make.top.equalTo(self.lineImageView.mas_bottom).offset(80);
                        make.height.width.mas_equalTo(20);
                        make.centerX.equalTo(self.yellowLine.mas_centerX).offset(-rectFloat);
                    }];
                }
            }
            
            //居中设置
            CGSize numSize = [self.midNumberLable.text sizeWithAttributes:@{NSFontAttributeName : self.midNumberLable.font}];
            CGSize titleSize = [self.midTitleLable.text sizeWithAttributes:@{NSFontAttributeName : self.midTitleLable.font}];
            
            CGFloat allWidth = numSize.width + 15 + titleSize.width;
            CGFloat numRect = numSize.width - allWidth/2.0;
            NSLog(@"numRect == %f",numRect);
            [self.midNumberLable mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.top.equalTo(self.lineImageView.mas_bottom).offset(20);
                make.right.equalTo(self.blueBGView.mas_centerX).offset(7.5+numRect);
            }];

            [self.midUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.left.equalTo(self.midNumberLable.mas_right).offset(15);
                make.bottom.equalTo(self.midNumberLable.mas_centerY).offset(-5);
            }];
            
            [self.midTitleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.left.equalTo(self.midNumberLable.mas_right).offset(15);
                make.top.equalTo(self.midNumberLable.mas_centerY).offset(5);
            }];

            
        }
            break;
        case EDataBloodPressureType:
        {
            //血压
            self.leftNumberLable.hidden = NO;
            self.leftUnitLabel.hidden = NO;
            self.leftTitleLable.hidden = NO;
            self.rightNumberLable.hidden = NO;
            self.rightUnitLabel.hidden = NO;
            self.rightTitleLable.hidden = NO;
            
            self.leftNumberLable.text = [NSString stringWithFormat:@"%@",self.leftNum];
            self.leftUnitLabel.text = @"bmp";
            self.leftTitleLable.text = @"低压";
            self.rightNumberLable.text = [NSString stringWithFormat:@"%@",self.RightNum];
            self.rightUnitLabel.text = @"bmp";
            self.rightTitleLable.text = @"高压";
            
            [self.blueBGView mas_updateConstraints:^(MASConstraintMaker *make) {
                if (iPhone5) {
                    make.height.mas_equalTo(MainScreenWidth + 10 - 80);
                }else if (iPhone6){
                    make.height.mas_equalTo(MainScreenWidth + 30 - 150 );
                }else{
                    make.height.mas_equalTo(MainScreenWidth - 40 - 130);
                }
            }];
        }
            break;
        case EDataHeartRateType:
        {
            //心率====60-100次.80中间
            self.loveImageView.hidden = NO;
            self.greenLine.hidden = NO;
            self.yellowLine.hidden = NO;
            self.readLine.hidden = NO;
            self.greenLabel.hidden = NO;
            self.yellowLable.hidden = NO;
            self.redLable.hidden = NO;
            
            self.midUnitLabel.hidden = NO;
            self.midTitleLable.hidden = NO;
            self.midNumberLable.hidden = NO;
            self.midNumberLable.text = [NSString stringWithFormat:@"%@",self.valueNum];
            self.midUnitLabel.text = @"次/分";
            self.midTitleLable.text =@"心率";
            
            CGFloat valueFloat = [self.valueNum floatValue] - 80;
            
            //左右偏移20
            if(fabs(valueFloat) > 20){
                if(valueFloat > 0){
                    [self.blueBGView addSubview:self.loveImageView];
                    [self.loveImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        STRONG_SELF(self);
                        make.top.equalTo(self.lineImageView.mas_bottom).offset(80);
                        make.height.width.mas_equalTo(20);
                        make.centerX.equalTo(self.readLine.mas_centerX).offset(-20);
                    }];
                }else{
                    [self.blueBGView addSubview:self.loveImageView];
                    [self.loveImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        STRONG_SELF(self);
                        make.top.equalTo(self.lineImageView.mas_bottom).offset(80);
                        make.height.width.mas_equalTo(20);
                        make.centerX.equalTo(self.greenLine.mas_centerX).offset(20);
                    }];
                }
            }else{
                rectFloat = (MainScreenWidth - 40 - 50)/3.0/2.0/20.0*valueFloat;
                if(valueFloat > 0){
                    [self.blueBGView addSubview:self.loveImageView];
                    [self.loveImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        STRONG_SELF(self);
                        make.top.equalTo(self.lineImageView.mas_bottom).offset(80);
                        make.height.width.mas_equalTo(20);
                        make.centerX.equalTo(self.yellowLine.mas_centerX).offset(rectFloat);
                    }];
                }else{
                    [self.blueBGView addSubview:self.loveImageView];
                    [self.loveImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        STRONG_SELF(self);
                        make.top.equalTo(self.lineImageView.mas_bottom).offset(80);
                        make.height.width.mas_equalTo(20);
                        make.centerX.equalTo(self.yellowLine.mas_centerX).offset(-rectFloat);
                    }];
                }
            }
            
            
            //居中设置
            CGSize numSize = [self.midNumberLable.text sizeWithAttributes:@{NSFontAttributeName : self.midNumberLable.font}];
            CGSize titleSize = [self.midTitleLable.text sizeWithAttributes:@{NSFontAttributeName : self.midTitleLable.font}];
            
            CGFloat allWidth = numSize.width + 15 + titleSize.width;
            CGFloat numRect = numSize.width - allWidth/2.0;
            NSLog(@"numRect == %f",numRect);
            [self.midNumberLable mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.top.equalTo(self.lineImageView.mas_bottom).offset(20);
                make.right.equalTo(self.blueBGView.mas_centerX).offset(7.5+numRect);
            }];
            
            [self.midUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.left.equalTo(self.midNumberLable.mas_right).offset(15);
                make.bottom.equalTo(self.midNumberLable.mas_centerY).offset(-5);
            }];
            
            [self.midTitleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.left.equalTo(self.midNumberLable.mas_right).offset(15);
                make.top.equalTo(self.midNumberLable.mas_centerY).offset(5);
            }];
        }
            break;
        case EDataVitalCapacityType:
        {
            //肺活量====2000-4000正常 中间3000ml
            self.loveImageView.hidden = NO;
            self.greenLine.hidden = NO;
            self.yellowLine.hidden = NO;
            self.readLine.hidden = NO;
            self.greenLabel.hidden = NO;
            self.yellowLable.hidden = NO;
            self.redLable.hidden = NO;
            
            self.midUnitLabel.hidden = NO;
            self.midTitleLable.hidden = NO;
            self.midNumberLable.hidden = NO;
            self.midNumberLable.text = [NSString stringWithFormat:@"%@",self.valueNum];
            self.midUnitLabel.text = @"ml/次";
            self.midTitleLable.text =@"肺活量";
            
            CGFloat valueFloat = [self.valueNum floatValue] - 3000;
            
            //左右偏移20
            if(fabs(valueFloat) > 1000){
                if(valueFloat > 0){
                    [self.blueBGView addSubview:self.loveImageView];
                    [self.loveImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        STRONG_SELF(self);
                        make.top.equalTo(self.lineImageView.mas_bottom).offset(80);
                        make.height.width.mas_equalTo(20);
                        make.centerX.equalTo(self.readLine.mas_centerX).offset(-20);
                    }];
                }else{
                    [self.blueBGView addSubview:self.loveImageView];
                    [self.loveImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        STRONG_SELF(self);
                        make.top.equalTo(self.lineImageView.mas_bottom).offset(80);
                        make.height.width.mas_equalTo(20);
                        make.centerX.equalTo(self.greenLine.mas_centerX).offset(20);
                    }];
                }
            }else{
                rectFloat = (MainScreenWidth - 40 - 50)/3.0/2.0/1000*valueFloat;
                if(valueFloat > 0){
                    [self.blueBGView addSubview:self.loveImageView];
                    [self.loveImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        STRONG_SELF(self);
                        make.top.equalTo(self.lineImageView.mas_bottom).offset(80);
                        make.height.width.mas_equalTo(20);
                        make.centerX.equalTo(self.yellowLine.mas_centerX).offset(rectFloat);
                    }];
                }else{
                    [self.blueBGView addSubview:self.loveImageView];
                    [self.loveImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        STRONG_SELF(self);
                        make.top.equalTo(self.lineImageView.mas_bottom).offset(80);                        make.height.width.mas_equalTo(20);
                        make.centerX.equalTo(self.yellowLine.mas_centerX).offset(-rectFloat);
                    }];
                }
            }
            
            
            //居中设置
            CGSize numSize = [self.midNumberLable.text sizeWithAttributes:@{NSFontAttributeName : self.midNumberLable.font}];
            CGSize titleSize = [self.midTitleLable.text sizeWithAttributes:@{NSFontAttributeName : self.midTitleLable.font}];
            
            CGFloat allWidth = numSize.width + 15 + titleSize.width;
            CGFloat numRect = numSize.width - allWidth/2.0;
            NSLog(@"numRect == %f",numRect);
            [self.midNumberLable mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.top.equalTo(self.lineImageView.mas_bottom).offset(20);
                make.right.equalTo(self.blueBGView.mas_centerX).offset(7.5+numRect);
            }];
            
            [self.midUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.left.equalTo(self.midNumberLable.mas_right).offset(15);
                make.bottom.equalTo(self.midNumberLable.mas_centerY).offset(-5);
            }];
            
            [self.midTitleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self);
                make.left.equalTo(self.midNumberLable.mas_right).offset(15);
                make.top.equalTo(self.midNumberLable.mas_centerY).offset(5);
            }];
        }
            break;
        default:
            break;
    }
}


-(UIView *)blackBGView{
    if (!_blackBGView) {
        _blackBGView = [[UIView alloc] initWithFrame:CGRectZero];
        _blackBGView.backgroundColor = [UIColor blackColor];
        _blackBGView.alpha = 0.5;
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
        _blueBGView.backgroundColor = UIColorFromHEX(0x0c1458, 1);
    }
    return  _blueBGView;
}

-(UIImageView *)lineImageView{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _lineImageView.backgroundColor = UIColorFromHEX(0x0c1458, 1);
        _lineImageView.image = [UIImage imageNamed:@"xian"];
        _lineImageView.userInteractionEnabled = YES;
        WEAK_SELF(self);
        [_lineImageView bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.goResultBlock) {
                self.goResultBlock();
            }
        }];
    }
    return _lineImageView;
}

-(UILabel *)leftNumberLable{
    if (!_leftNumberLable) {
        _leftNumberLable = [[UILabel alloc]initWithFrame:CGRectZero];
        _leftNumberLable.font = [UIFont systemFontOfSize:40];
        _leftNumberLable.textAlignment = NSTextAlignmentLeft;
        _leftNumberLable.textColor = UIColorFromHEX(0x42b3ff, 1);
        _leftNumberLable.backgroundColor = UIColorFromHEX(0x0c1458, 1);
        _leftNumberLable.hidden = YES;
        [_leftNumberLable sizeToFit];
    }
    return _leftNumberLable;
}

-(UILabel *)leftUnitLabel{
    if (!_leftUnitLabel) {
        _leftUnitLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _leftUnitLabel.font = [UIFont systemFontOfSize:12];
        _leftUnitLabel.textAlignment = NSTextAlignmentLeft;
        _leftUnitLabel.textColor = UIColorFromHEX(0x42b3ff, 1);
        _leftUnitLabel.backgroundColor = UIColorFromHEX(0x0c1458, 1);
        _leftUnitLabel.hidden = YES;
    }
    return _leftUnitLabel;
}

-(UILabel *)leftTitleLable{
    if (!_leftTitleLable) {
        _leftTitleLable = [[UILabel alloc]initWithFrame:CGRectZero];
        _leftTitleLable.font = [UIFont systemFontOfSize:12];
        _leftTitleLable.textAlignment = NSTextAlignmentLeft;
        _leftTitleLable.textColor = UIColorFromHEX(0x42b3ff, 1);
        _leftTitleLable.backgroundColor = UIColorFromHEX(0x0c1458, 1);
        _leftTitleLable.hidden = YES;
    }
    return _leftTitleLable;
}

-(UILabel *)midNumberLable{
    if (!_midNumberLable) {
        _midNumberLable = [[UILabel alloc]initWithFrame:CGRectZero];
        _midNumberLable.font = [UIFont systemFontOfSize:40];
        _midNumberLable.textAlignment = NSTextAlignmentRight;
        _midNumberLable.textColor = UIColorFromHEX(0x42b3ff, 1);
        _midNumberLable.backgroundColor = UIColorFromHEX(0x0c1458, 1);
        _midNumberLable.hidden = YES;
        [_midNumberLable sizeToFit];
    }
    return _midNumberLable;
}

-(UILabel *)midUnitLabel{
    if (!_midUnitLabel) {
        _midUnitLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _midUnitLabel.font = [UIFont systemFontOfSize:12];
        _midUnitLabel.textAlignment = NSTextAlignmentLeft;
        _midUnitLabel.textColor = UIColorFromHEX(0x42b3ff, 1);
        _midUnitLabel.backgroundColor = UIColorFromHEX(0x0c1458, 1);
        _midUnitLabel.hidden = YES;
        [_midUnitLabel sizeToFit];
    }
    return _midUnitLabel;
}

-(UILabel *)midTitleLable{
    if (!_midTitleLable) {
        _midTitleLable = [[UILabel alloc]initWithFrame:CGRectZero];
        _midTitleLable.font = [UIFont systemFontOfSize:12];
        _midTitleLable.textAlignment = NSTextAlignmentLeft;
        _midTitleLable.textColor = UIColorFromHEX(0x42b3ff, 1);
        _midTitleLable.backgroundColor = UIColorFromHEX(0x0c1458, 1);
        _midTitleLable.hidden = YES;
        [_midTitleLable sizeToFit];
    }
    return _midTitleLable;
}

-(UILabel *)rightNumberLable{
    if (!_rightNumberLable) {
        _rightNumberLable = [[UILabel alloc]initWithFrame:CGRectZero];
        _rightNumberLable.font = [UIFont systemFontOfSize:40];
        _rightNumberLable.textAlignment = NSTextAlignmentLeft;
        _rightNumberLable.textColor = UIColorFromHEX(0x42b3ff, 1);
        _rightNumberLable.backgroundColor = UIColorFromHEX(0x0c1458, 1);
        _rightNumberLable.hidden = YES;
        [_rightNumberLable sizeToFit];
    }
    return _rightNumberLable;
}

-(UILabel *)rightUnitLabel{
    if (!_rightUnitLabel) {
        _rightUnitLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _rightUnitLabel.font = [UIFont systemFontOfSize:12];
        _rightUnitLabel.textAlignment = NSTextAlignmentLeft;
        _rightUnitLabel.textColor = UIColorFromHEX(0x42b3ff, 1);
        _rightUnitLabel.backgroundColor = UIColorFromHEX(0x0c1458, 1);
        _rightTitleLable.hidden = YES;
        [_rightUnitLabel sizeToFit];
    }
    return _rightUnitLabel;
}

-(UILabel *)rightTitleLable{
    if (!_rightTitleLable) {
        _rightTitleLable = [[UILabel alloc]initWithFrame:CGRectZero];
        _rightTitleLable.font = [UIFont systemFontOfSize:12];
        _rightTitleLable.textAlignment = NSTextAlignmentLeft;
        _rightTitleLable.textColor = UIColorFromHEX(0x42b3ff, 1);
        _rightTitleLable.backgroundColor = UIColorFromHEX(0x0c1458, 1);
        _rightTitleLable.hidden = YES;
        [_rightTitleLable sizeToFit];
        
    }
    return _rightTitleLable;
}

-(UIImageView *)loveImageView{
    if (!_loveImageView) {
        _loveImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _loveImageView.image = [UIImage imageNamed:@"Result_heart"];
    }
    return _loveImageView;
}

-(UIView *)greenLine{
    if (!_greenLine) {
        _greenLine = [[UIView alloc] initWithFrame:CGRectZero];
        _greenLine.backgroundColor = UIColorFromHEX(0x96e343, 1);
        _greenLine.layer.cornerRadius = 5;
    }
    return  _greenLine;
}

-(UIView *)yellowLine{
    if (!_yellowLine) {
        _yellowLine = [[UIView alloc] initWithFrame:CGRectZero];
        _yellowLine.backgroundColor = UIColorFromHEX(0xfdb211, 1);
        
    }
    return  _yellowLine;
}

-(UIView *)readLine{
    if (!_readLine) {
        _readLine = [[UIView alloc] initWithFrame:CGRectZero];
        _readLine.backgroundColor = UIColorFromHEX(0xff6565, 1);
        _readLine.clipsToBounds = YES;
        _readLine.layer.cornerRadius = 5;
    }
    return  _readLine;
}

-(UILabel *)greenLabel{
    if (!_greenLabel) {
        _greenLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _greenLabel.font = [UIFont systemFontOfSize:15];
        _greenLabel.textAlignment = NSTextAlignmentRight;
        _greenLabel.textColor = UIColorFromHEX(0x42b3ff, 1);
        _greenLabel.backgroundColor = UIColorFromHEX(0x0c1458, 1);
        [_greenLabel sizeToFit];
    }
    return _greenLabel;
}

-(UILabel *)yellowLable{
    if (!_yellowLable) {
        _yellowLable = [[UILabel alloc]initWithFrame:CGRectZero];
        _yellowLable.font = [UIFont systemFontOfSize:15];
        _yellowLable.textAlignment = NSTextAlignmentRight;
        _yellowLable.textColor = UIColorFromHEX(0x42b3ff, 1);
        _yellowLable.backgroundColor = UIColorFromHEX(0x0c1458, 1);
        [_yellowLable sizeToFit];
    }
    return _yellowLable;
}

-(UILabel *)redLable{
    if (!_redLable) {
        _redLable = [[UILabel alloc]initWithFrame:CGRectZero];
        _redLable.font = [UIFont systemFontOfSize:15];
        _redLable.textAlignment = NSTextAlignmentRight;
        _redLable.textColor = UIColorFromHEX(0x42b3ff, 1);
        _redLable.backgroundColor = UIColorFromHEX(0x0c1458, 1);
        [_readLine sizeToFit];
    }
    return _redLable;
}

- (UIButton *)testButton{
    
    if (!_testButton) {
        _testButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_testButton addTarget:self action:@selector(goTest) forControlEvents:UIControlEventTouchUpInside];
        [_testButton setTitle:@"进入测量" forState:UIControlStateNormal];
        [_testButton setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    }
    return _testButton;
}

@end
