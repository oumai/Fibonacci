//
//  LoginViewController.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/7/13.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATLoginViewController.h"
//第三方
#import "SFHFKeychainUtils.h"
//子视图
#import "BATImageTextField.h"
#import "BATLoginModel.h"
//model
#import "BATPerson.h"

//跳转试图
#import "ForgetAndChangeViewController.h"
#import "HTTPTool+HeartDataRequst.h"
#import "HTTPTool+LoginRequest.h"

@interface BATLoginViewController ()
{
    NSString *userId;
    NSString *userToken;
    BOOL isBack;
}
@property (nonatomic,strong) UIImageView       *topImageView;
@property (nonatomic,strong) UITextField       *userTF;
@property (nonatomic,strong) UITextField       *passwordTF;
@property (nonatomic,strong) UIButton          *loginButton;
@property (nonatomic,strong) UIButton          *backButton;
@property (nonatomic,strong) UIButton          *registerButton;
@property (nonatomic,strong) UIButton          *forgetPasswordButton;
@end

@implementation BATLoginViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getPasswordFromKeychain)
                                                name:@"USER_REGIST_SUCCESS"
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getPasswordFromKeychain)
                                                name:@"USER_FORGET_SUCCESS"
                                              object:nil];
//    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
    [self pagesLayout];
    [self getPasswordFromKeychain];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self dismissProgress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getPasswordFromKeychain
{
    self.userTF.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"LOGIN_NAME"];
    if (self.userTF.text.length == 0) {
        return;
    }
    NSError *error;
    NSString * password = [SFHFKeychainUtils getPasswordForUsername:self.userTF.text andServiceName:ServiceName error:&error];
    if(error){
        DDLogError(@"从Keychain里获取密码出错：%@",error);
        return;
    }
    self.passwordTF.text = password;
}

#pragma mark - Action
- (void)login {
    self.userTF.text = [self.userTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![KMTools checkPhoneNumber: self.userTF.text]) {
        [self showErrorWithText:@"请输入帐号或者手机号"];
        return;
    }

    if (self.passwordTF.text.length == 0) {
        [self showErrorWithText:@"请输入密码"];
        return;
    }
    if (self.passwordTF.text.length<6||self.passwordTF.text.length>18) {
        [self showText:@"密码长度为6-18位"];
        return;
    }
    [self loginRequest];
}

- (void)loginSucess{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
        [TalkingData trackEvent:@"220000101" label:@"登录/注册>登录"];
    });
}

#pragma mark - NET
- (void)loginRequest {
    [self showProgressWithText:@"正在登录"];
    // /api/Account/Login
    // /api/NetworkMedical/Login
    
    [HTTPTool LoginWithUserName:self.userTF.text
                       password:self.passwordTF.text
                        Success:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATA_LOGIN_STATION" object:nil];
                            //完成登录，退出登录界面
                            [self showSuccessWithText:@"登录成功"];
                            [self loginSucess];
                            
                        }failure:^(NSError *error) {
                            
                        }];
    
}

#pragma mark - Layout
- (void)pagesLayout {
    
    /**
     *  判断手机型号，调整整体布局
     */
    __block CGFloat lineSpa;
    __block CGFloat height;
    if(iPhone5){
        lineSpa = 20;
        height = 40;
    }else if(iPhone6){
        lineSpa = 35;
        height = 45;
    }else if(iPhone6p){
        lineSpa = 44;
        height = 50;
    }else if(([UIScreen mainScreen].currentMode.size.height) > 1334){
        lineSpa = 44;
        height = 50;
    }

    WEAK_SELF(self);
    
    [self.view addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(64+35);
        make.height.mas_equalTo(110);
        make.width.mas_equalTo(110);
    }];

    [self.view addSubview:self.userTF];
    [self.userTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.top.equalTo(self.topImageView.mas_bottom).offset(2*lineSpa);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(MainScreenWidth-50);
    }];
    
    //手机号下划线
    UIView *userTFLine = [[UIView alloc]init];
    userTFLine.backgroundColor = RGB(57, 57, 110);
    [self.view addSubview:userTFLine];
    [userTFLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.top.equalTo(self.userTF.mas_bottom).offset(1);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(MainScreenWidth-50);
    }];

    [self.view addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);

        make.top.equalTo(self.userTF.mas_bottom).offset(lineSpa);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(MainScreenWidth-50);
    }];
    
    //密码下划线
    UIView *passwordTFLine = [[UIView alloc]init];
    passwordTFLine.backgroundColor = RGB(57, 57, 110);
    [self.view addSubview:passwordTFLine];
    [passwordTFLine mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        make.top.equalTo(self.passwordTF.mas_bottom).offset(1);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(MainScreenWidth-50);
    }];
    
    [self.view addSubview:self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.view.mas_top).offset(IS_IPHONE_X?40:20);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(60);
    }];

    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.view.mas_top).offset(IS_IPHONE_X?40:20);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(60);
    }];
    
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(passwordTFLine.mas_bottom).offset(50);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(MainScreenWidth/2);
    }];

    [self.view addSubview:self.forgetPasswordButton];
    [self.forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.loginButton.mas_right);
        make.top.equalTo(self.loginButton.mas_bottom).offset(12.5);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(100);
    }];
}

#pragma mark - setter && getter

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    }
    return _topImageView;
}


- (UITextField *)userTF {
    if (!_userTF) {
        _userTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:17] textColor:AppFontGrayColor placeholder:@"请输入手机号" BorderStyle:UITextBorderStyleNone];
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"User name"]];
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [leftIcon addSubview:searchIcon];
        [_userTF setValue: AppFontGrayColor forKeyPath:@"_placeholderLabel.textColor"];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftIcon);
        }];
        _userTF.leftView = leftIcon;
        _userTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _userTF;
}

- (UITextField *)passwordTF {

    if (!_passwordTF) {
        
        _passwordTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:17] textColor:AppFontGrayColor placeholder:@"请输入密码(6-18位)" BorderStyle:UITextBorderStyleNone];
        [_passwordTF setValue: AppFontGrayColor forKeyPath:@"_placeholderLabel.textColor"];
        _passwordTF.secureTextEntry = YES;
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Password"]];
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [leftIcon addSubview:searchIcon];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftIcon);
        }];
        _passwordTF.leftView = leftIcon;
        _passwordTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _passwordTF;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"登录" titleColor:[UIColor whiteColor] backgroundColor:nil backgroundImage:[UIImage imageNamed:@"btn"]  Font:[UIFont systemFontOfSize:17]];
        
        WEAK_SELF(self);
        [_loginButton bk_whenTapped:^{
            STRONG_SELF(self);
            [self login];
        }];
    }
    return _loginButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"nav_back_bg"] forState:UIControlStateNormal];
        [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
        
        WEAK_SELF(self);
        [_backButton bk_whenTapped:^{
            STRONG_SELF(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _backButton;
}

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"注册" titleColor: AppFontColor  backgroundColor:[UIColor clearColor] backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
        WEAK_SELF(self);
        [_registerButton bk_whenTapped:^{
            STRONG_SELF(self);
            //注册
            [TalkingData trackEvent:@"220000102" label:@"登录/注册>注册"];
            UIStoryboard *sboard = [KMTools getStoryboardInstance];
            ForgetAndChangeViewController *forgetAndChangeViewController = [sboard instantiateViewControllerWithIdentifier:@"ForgetAndChangeViewController"];
            forgetAndChangeViewController.type = EViewRegistType;
            [self.navigationController pushViewController:forgetAndChangeViewController animated:YES];
        }];
    }
    return _registerButton;
}

- (UIButton *)forgetPasswordButton {
    if (!_forgetPasswordButton) {
        _forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"忘记密码?" titleColor:AppFontColor  backgroundColor:[UIColor clearColor] backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
        _forgetPasswordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _forgetPasswordButton.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 5);
        WEAK_SELF(self);
        [_forgetPasswordButton bk_whenTapped:^{
            STRONG_SELF(self);
            UIStoryboard *sboard = [KMTools getStoryboardInstance];
            ForgetAndChangeViewController *forgetAndChangeViewController = [sboard instantiateViewControllerWithIdentifier:@"ForgetAndChangeViewController"];
            forgetAndChangeViewController.type = EViewForgetType;
            [self.navigationController pushViewController:forgetAndChangeViewController animated:YES];

        }];
    }
    return _forgetPasswordButton;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
