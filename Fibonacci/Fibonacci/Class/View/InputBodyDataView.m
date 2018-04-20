//
//  InputBodyDataView.m
//  Fibonacci
//
//  Created by woaiqiu947 on 2017/2/13.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import "InputBodyDataView.h"

@implementation InputBodyDataView

-(void)dealloc
{
    self.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initInputView];
    }
    return self;
}

-(void)initInputView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [[UIView alloc] init];
    blackView.backgroundColor = UIColorFromHEX(00000, 0);
    blackView.tag = 10001;
    blackView.hidden = YES;
    [window addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(window.mas_top);
        make.left.equalTo(window.mas_left);
        make.right.equalTo(window.mas_right);
        make.bottom.equalTo(window.mas_bottom);
    }];
    
    CGFloat viewWidth = MainScreenWidth/1.5;
    CGFloat viewHeight = 180.f;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5.f;
    view.layer.masksToBounds = YES;
    view.tag = 10002;
    [blackView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blackView.mas_top).offset(-viewHeight);
        make.width.mas_equalTo(viewWidth);
        make.height.mas_equalTo(viewHeight);
        make.centerX.equalTo(blackView.mas_centerX);
    }];
    
    UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    dismissButton.frame = CGRectMake(10, 5, 30, 30);
    [dismissButton setImage:[UIImage imageNamed:@"close_gray"] forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismissInputView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:dismissButton];
    [dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).offset(5);
        make.left.equalTo(view.mas_left).offset(10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"";
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).offset(20.f);
        make.left.equalTo(view.mas_left).offset(0);
        make.width.mas_equalTo(viewWidth);
        make.height.mas_equalTo(30.f);
    }];
    
    CGFloat inputFieldH = 45.f;
    inputField = [[UITextField alloc] init];
    inputField.font = [UIFont fontWithName:AppFontHelvetica size: 15];
    inputField.keyboardType = UIKeyboardTypeDecimalPad;
    inputField.textAlignment = NSTextAlignmentCenter;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(inputFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:inputField];
    [view addSubview:inputField];
    [inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10.f);
        make.left.equalTo(view.mas_left).offset(viewWidth/4);
        make.width.mas_equalTo(viewWidth/2);
        make.height.mas_equalTo(inputFieldH);
    }];
    
    unitLabel = [[UILabel alloc] init];
    unitLabel.text = @"";
    unitLabel.textColor = [UIColor grayColor];
    [view addSubview:unitLabel];
    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputField.mas_top).offset(0);
        make.left.equalTo(inputField.mas_right).offset(5);
        make.width.mas_equalTo(inputFieldH);
        make.height.mas_equalTo(inputFieldH);
    }];
    
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.backgroundColor =  RGB(135,206,250);
    [saveButton addTarget:self action:@selector(saveValueDismissInputView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:saveButton];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_bottom).offset(- 10);
        make.left.equalTo(view.mas_left).offset(10);
        make.right.equalTo(view.mas_right).offset(-10);
        make.height.mas_equalTo(inputFieldH);
    }];
}

-(void)presentInputView:(EInputViewType)type
{
    NSString *titleStr = @"";
    NSString *unitStr = @"";
    inputField.text = @"";
    inputType = type;
    switch (type) {
        case EInputViewTypeWeight:
        {
            titleStr = @"请输入当前体重";
            unitStr = @"kg";
        }
            break;
        case EInputViewTypeHeight:
        {
            titleStr = @"请输入当前身高";
            unitStr = @"cm";
            
        }
            break;
        case EInputViewTypeBust:
        {
            titleStr = @"请输入当前腰围";
            unitStr = @"cm";
        }
            break;
        default:
            break;
    }
    titleLabel.text = titleStr;
    unitLabel.text = unitStr;
    saveButton.enabled = NO;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:10001];
    UIView *inputView = [window viewWithTag:10002];
    blackView.hidden = NO;
    [inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(MainScreenHeight*0.3);
    }];
    [blackView setNeedsUpdateConstraints];
    [blackView updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [blackView layoutIfNeeded];
        blackView.backgroundColor = UIColorFromHEX(00000, 0.55);
    }completion:^(BOOL finished) {
        [inputField becomeFirstResponder];
    }];
}

- (void)saveValueDismissInputView
{
    double value = [inputField.text doubleValue];
    if (value > 300 || value < 10)
    {
        [SVProgressHUD showErrorWithStatus: @"您输入的数值异常，请重新输入!"];
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewType:inputViewType:saveValue:)]) {
            [self.delegate inputViewType:self  inputViewType:inputType saveValue:inputField.text];
        }
        [self dismissInputView];
    }
}

- (void)dismissInputView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:10001];
    UIView *inputView = [window viewWithTag:10002];
    [inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(MainScreenHeight);
    }];
    [blackView setNeedsUpdateConstraints];
    [blackView updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        [blackView layoutIfNeeded];
        blackView.backgroundColor = UIColorFromHEX(00000, 0);
    }completion:^(BOOL finished) {
        [inputField resignFirstResponder];
        
        [inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(blackView.mas_top).offset(-180.f);
            make.width.mas_equalTo(MainScreenWidth/1.5);
            make.height.mas_equalTo(180.f);
            make.centerX.equalTo(blackView.mas_centerX);
        }];
        [blackView updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.2 animations:^{
            [blackView layoutIfNeeded];
            blackView.hidden = YES;
        }completion:^(BOOL completed) {
        }];
    }];
}


- (void)removeAllSubview
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:10001];
    UIView *inputView = [window viewWithTag:10002];
    for (UIView *elem in inputView.subviews) {
        [elem removeFromSuperview];
    }
    [inputView removeFromSuperview];
    [blackView removeFromSuperview];
}

#pragma mark - 
-(void)inputFieldEditChanged:(NSNotification *)obj
{
    UITextField *textView = (UITextField *)obj.object;

    if (textView.text.length > 0)
    {
        if ([textView.text containsString:@"."])
        {
            NSRange range;
            range = [textView.text rangeOfString:@"."];
            NSUInteger textLength = range.location+range.length+1;
            if (textView.text.length>textLength) {
                saveButton.enabled = NO;
                saveButton.backgroundColor = RGB(135,206,250);
            }
            else
            {
                saveButton.enabled = YES;
                saveButton.backgroundColor = RGB(99, 177, 249);
            }
        }
        else
        {
            if (textView.text.length < 4) {
                saveButton.enabled = YES;
                saveButton.backgroundColor = RGB(99, 177, 249);
            }
            else
            {
                saveButton.enabled = NO;
                saveButton.backgroundColor = RGB(135,206,250);
            }
        }
    }
    else
    {
        saveButton.enabled = NO;
        saveButton.backgroundColor = RGB(135,206,250);
    }
}

@end

