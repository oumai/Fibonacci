//
//  SexAndAgeInputView.m
//  Fibonacci
//
//  Created by woaiqiu947 on 2017/2/14.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import "SexAndAgeInputView.h"
#define SexAndAge_Width     MainScreenWidth - 100
#define SexAndAge_Height    MainScreenWidth
#define SexAndAgeButtonW    ((SexAndAge_Width)/2)
#define AnimateFinishedViewMinY        (MainScreenHeight-SexAndAge_Height)/2

#ifdef iPhone5
#define buttonH  40
#else
#define buttonH  50
#endif

@implementation SexAndAgeInputView

-(void)dealloc
{
    agePickerView.delegate = nil;
    agePickerView.dataSource = nil;
    self.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSexView];
    }
    return self;
}

- (void)initSexView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    blackView.backgroundColor = UIColorFromHEX(00000, 0);
    blackView.tag = 20001;
    blackView.hidden = YES;
    [window addSubview:blackView];
    
    UIView *sexView = [[UIView alloc] initWithFrame:CGRectMake(50, MainScreenHeight, SexAndAge_Width, SexAndAge_Height)];
    sexView.layer.cornerRadius = 5;
    sexView.backgroundColor = [UIColor whiteColor];
    sexView.tag = 20002;
    sexView.userInteractionEnabled = YES;
    [blackView addSubview:sexView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SexAndAge_Width, 45)];
    titleLabel.text = @"选择性别";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [sexView addSubview:titleLabel];
    
    NSArray *sexArray = @[@"男", @"女"];
    NSArray *sexImageArray = @[@"male_normal_icon",@"female_normal_icon"];
    NSArray *sexSelectedImageArray = @[@"male_selected_icon",@"female_selected_icon"];
    CGFloat hudLabelY = 0.f;
    CGFloat buttonW = 90.f;
    CGFloat intervalY = iPhone5?5:30;
    for (int i = 0; i < [sexArray count]; i++) {
        UIButton *manButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat buttonY = CGRectGetMaxY(titleLabel.frame);
        manButton.frame = CGRectMake((SexAndAge_Width-buttonW)/2, buttonY + i*buttonW +i *intervalY, buttonW, buttonW);
        [manButton setTitle:sexArray[i] forState:UIControlStateNormal];
        [manButton setImage:[UIImage imageNamed: sexImageArray[i] ] forState:UIControlStateNormal];
        [manButton setImage:[UIImage imageNamed: sexSelectedImageArray[i] ] forState:UIControlStateSelected];
        [manButton setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 25, 0)];
        [manButton setTitleEdgeInsets:UIEdgeInsetsMake(50, -40, 0, 0)];
        manButton.tag = 1000+i;
        if (i==0) {
            manButton.selected = YES;
        }
        [manButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [manButton addTarget:self action:@selector(seletedSex:) forControlEvents:UIControlEventTouchUpInside];
        [sexView addSubview:manButton];
        hudLabelY = CGRectGetMaxY(manButton.frame);
    }
    
    UILabel * hudLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, hudLabelY + (iPhone5?0:20), SexAndAge_Width, (iPhone5?30:45))];
    hudLabel.text = @"选择后不可更改";
    hudLabel.textAlignment = NSTextAlignmentCenter;
    hudLabel.textColor = AppColor;
    hudLabel.font = [UIFont fontWithName:AppFontHelvetica size:15.0];
    [sexView addSubview:hudLabel];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.backgroundColor = RGB(99, 177, 249);
    shareButton.tag = 1003;
    shareButton.frame = CGRectMake(SexAndAgeButtonW/2, SexAndAge_Height- 10 - buttonH, SexAndAgeButtonW, buttonH);;
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [shareButton setTitle: @"确定" forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(saveSexButton:) forControlEvents:UIControlEventTouchUpInside];
    shareButton.layer.cornerRadius = 3;
    [sexView addSubview:shareButton];
}

- (void)initAgeView
{
    UIView *ageView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth, AnimateFinishedViewMinY, SexAndAge_Width, SexAndAge_Height)];
    ageView.layer.cornerRadius = 5;
    ageView.backgroundColor = [UIColor whiteColor];
    ageView.tag = 20003;
    [blackView addSubview:ageView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SexAndAge_Width, 45)];
    titleLabel.text = @"选择年龄";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [ageView addSubview:titleLabel];
    
    agePickerView = [[UIPickerView alloc] init];
    agePickerView.delegate = self;
    agePickerView.dataSource = self;
    agePickerView.showsSelectionIndicator = YES;
    agePickerView.frame = CGRectMake(10, CGRectGetMaxY(titleLabel.frame)+(iPhone5?0:10), SexAndAge_Width - 20, 230);
    [ageView addSubview:agePickerView];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.backgroundColor = RGB(99, 177, 249);
    shareButton.tag = 2003;
    shareButton.frame = CGRectMake(SexAndAgeButtonW/2, SexAndAge_Height- 10 - buttonH, SexAndAgeButtonW, buttonH);
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [shareButton setTitle: @"确定" forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(saveAgeButton:) forControlEvents:UIControlEventTouchUpInside];
    shareButton.layer.cornerRadius = 3;
    [ageView addSubview:shareButton];
}

#pragma mark - Action
- (void)seletedSex:(UIButton *)button
{
    UIView *sexView = [blackView viewWithTag:20002];
    UIView *elem = nil;
    button.selected = YES;
    if (button.tag == 1000) {
        elem = [sexView viewWithTag:1001];
    }
    else
    {
        elem = [sexView viewWithTag:1000];
    }
    UIButton *otherButton = (UIButton *)elem;
    otherButton.selected = NO;
}

- (void)saveSexButton:(UIButton *)button
{
    UIView *sexView = [blackView viewWithTag:20002];
    UIView *ageView = [blackView viewWithTag:20003];
    [UIView animateWithDuration:0.35f animations:^{
        CGRect rect = sexView.frame;
        rect.origin.x = -MainScreenWidth;
        sexView.frame = rect;
        CGRect ageRect = ageView.frame;
        ageRect.origin.x = 50;
        ageView.frame = ageRect;
    } completion:^(BOOL finished) {
        CGRect rect = sexView.frame;
        rect.origin.x = 50;
        rect.origin.y = MainScreenHeight;
        sexView.frame = rect;
    }];
}

- (void)saveAgeButton:(UIButton *)button
{
    NSInteger row = [agePickerView selectedRowInComponent: 0];
    NSString *ageStr = [NSString stringWithFormat:@"%li",row+1];
    UIView *sexView = [blackView viewWithTag:20002];
    UIView *ageView = [blackView viewWithTag:20003];
    UIButton *manButton = [sexView viewWithTag:1000];
    NSString *sexStr = @"0";
    if (manButton.selected)
    {
        sexStr = @"1";
    }
    
    [UIView animateWithDuration:0.35f animations:^{
        CGRect ageRect = ageView.frame;
        ageRect.origin.y = MainScreenHeight;
        ageView.frame = ageRect;
        blackView.backgroundColor = UIColorFromHEX(00000, 0);
    } completion:^(BOOL finished) {
        blackView.hidden = YES;
        CGRect rect = ageView.frame;
        rect.origin.x = MainScreenWidth;
        rect.origin.y = AnimateFinishedViewMinY;
        ageView.frame = rect;
        if (self.delegate && [self.delegate respondsToSelector:@selector(sexAndAgeInputView:sexValue:ageValue:)]) {
            [self.delegate sexAndAgeInputView:self sexValue:sexStr ageValue:ageStr];
        }
    }];
}

#pragma mark - present
-(void)presentSexAndAgeInputView
{
    UIView *sextView = [blackView viewWithTag:20002];
    blackView.hidden = NO;
    [UIView animateWithDuration:0.35f animations:^{
        blackView.backgroundColor = UIColorFromHEX(00000, 0.55);
        CGRect rect = sextView.frame;
        rect.origin.y = AnimateFinishedViewMinY;
        sextView.frame = rect;
    } completion:^(BOOL finished) {
        if (!agePickerView) {
            [self initAgeView];
        }
        [agePickerView selectRow:20 inComponent:0 animated:NO];
    }];
}

- (void)removeAllSubview
{
    UIView *sexView = [blackView viewWithTag:20002];
    UIView *ageView = [blackView viewWithTag:20002];
    for (UIView *elem in sexView.subviews) {
        [elem removeFromSuperview];
    }
    for (UIView *elem in ageView.subviews) {
        [elem removeFromSuperview];
    }
    [blackView removeFromSuperview];
    [sexView removeFromSuperview];
    [ageView removeFromSuperview];
}

#pragma mark - 
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 99;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%li",row+1];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = RGBA(33,131,245, 0.2);
        }
    }
    UILabel *genderLabel = [UILabel new];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.text = [NSString stringWithFormat:@"%li",row+1];
//    genderLabel.textColor = AppColor;
    return genderLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
