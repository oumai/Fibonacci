//
//  ImageTextField.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/7/13.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATImageTextField.h"

@interface BATImageTextField()

@property (nonatomic,strong) UIImageView * leftImageView;
@property (nonatomic,strong) NSString * placehold;
@property (nonatomic,strong) UIImage * image;

@end

@implementation BATImageTextField

- (instancetype)initWithFrame:(CGRect)frame Image:(UIImage *)image placehold:(NSString *)placehold {
    self = [super initWithFrame:frame];
    if (self) {

        self.layer.cornerRadius = 5.0f;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = AppColor.CGColor;

        self.image = image;
        self.placehold = placehold;

        WEAK_SELF(self);
        [self addSubview:self.leftImageView];
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(5);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(25);
        }];

        [self addSubview:self.rightTF];
        [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.leftImageView.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-5);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}

#pragma mark - 
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithImage:self.image];
        [_leftImageView sizeToFit];
    }
    return _leftImageView;
}

- (UITextField *)rightTF {
    if (!_rightTF) {
        _rightTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:17] textColor:AppColor placeholder:self.placehold BorderStyle:UITextBorderStyleNone];
        _rightTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _rightTF;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
