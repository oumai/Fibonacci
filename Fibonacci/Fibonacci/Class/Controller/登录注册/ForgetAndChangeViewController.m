//
//  ForgetAndChangeViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 16/10/12.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "ForgetAndChangeViewController.h"
#import "IQKeyboardManager.h"
#import "SFHFKeychainUtils.h"
//第三方
#import "SFHFKeychainUtils.h"
#import "BATLoginModel.h"
#import "BATBaseModel.h"

@interface ForgetAndChangeViewController ()

@end

@implementation ForgetAndChangeViewController

static CGFloat cellRowHeight = 50;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initPagesData];
    [self addTableFooterView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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

- (void)initPagesData
{
    switch (_type) {
        case EViewRegistType:
        {
            self.title = @"注册";
            titleArray = @[@"手机号码",@"验证码",@"登录密码",@"确认密码"];
            placeholderArray = @[@"请输入手机号码",@"请输入验证码",@"请输入登录密码(6-18位)",@"请再次输入密码"];
        }
            break;
        case EViewForgetType:
        {
            self.title = @"找回密码";
            titleArray = @[@"手机号码",@"验证码",@"登录密码",@"确认密码"];
            placeholderArray = @[@"请输入手机号码",@"请输入验证码",@"请输入登录密码(6-18位)",@"请再次输入密码"];
        }
            break;
        case EViewChangeType:
        {
            self.title = @"修改密码";
            titleArray = @[@"原密码",@"新密码",@"确认密码"];
            placeholderArray = @[@"请输入原密码",@"请输入新密码(6-18位)",@"请再次输入密码"];

        }
            break;
            
        default:
            break;
    }
    countdownButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"获取验证码" titleColor:[UIColor whiteColor] backgroundColor:AppFontColor backgroundImage:nil Font:[UIFont systemFontOfSize:14]];
    countdownButton.layer.cornerRadius = 5.f;
    countdownButton.frame = CGRectMake(MainScreenWidth - 120, 10, 100, cellRowHeight-20);
    [countdownButton addTarget:self action:@selector(sendAuthCode:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addTableFooterView
{
    myTableView.backgroundView = [[UIView alloc] init];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.rowHeight = cellRowHeight;
    myTableView.separatorColor = RGB(41, 41, 88);
    
    CGFloat viewH = 50;
    CGFloat buttonH = 40;
    if (_type == 0) {
        viewH +=35;
    }
//    else
//    {
//        buttonH = 40;
//    }
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, viewH)];
    footerView.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(MainScreenWidth/3, 0, MainScreenWidth/3, buttonH);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [button setTitle: self.title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(noneBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"btn"];
    [button setBackgroundImage: image forState:UIControlStateNormal];
    [footerView addSubview:button];
    myTableView.tableFooterView = footerView;
    if (_type==0) {
        UILabel *registLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame), MainScreenWidth, 35)];
        registLabel.text = @"如果已经拥有健康BAT账号，则可直接登录";
        registLabel.textAlignment = NSTextAlignmentCenter;
        registLabel.font = [UIFont fontWithName:@"Helvetica-Light" size: 14];
        registLabel.textColor = AppFontGrayColor;
        [footerView addSubview:registLabel];
    }
    [myTableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableView

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        UILabel *textLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 0, 70, cellRowHeight)];
        textLabel.font = [UIFont fontWithName:AppFontHelvetica size: 15];
        textLabel.tag = 100;
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.textColor = AppFontColor;
        [cell.contentView addSubview:textLabel];

        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textLabel.frame)+5, 0, MainScreenWidth-CGRectGetMaxX(textLabel.frame)-20, cellRowHeight)];
        textField.font = [UIFont fontWithName:AppFontHelvetica size: 15];
        textField.tag = 101;
        textField.textAlignment = NSTextAlignmentLeft;
        textField.placeholder = placeholderArray[indexPath.row];
        textField.textColor = AppFontGrayColor;
        [textField setValue: AppFontGrayColor forKeyPath:@"_placeholderLabel.textColor"];

        [cell.contentView addSubview:textField];
        [self setTextFieldFromType:textField indexRow:indexPath.row];
        if (_type<2&&indexPath.row == 0)
        {
            [cell.contentView addSubview:countdownButton];
        }
    }
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    label.text = titleArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {

        }
            break;
        default:
            break;
    }
}

- (void)setTextFieldFromType:(UITextField*)textField indexRow:(NSUInteger)row
{
    if (_type < 2)
    {
        switch (row) {
            case 0:
            {
                phoneField = textField;
            }
                break;
            case 1:
            {
                antuField = textField;
            }
                break;
            case 2:
            {
                textField.secureTextEntry = YES;
                passwrodField = textField;
            }
                break;
            case 3:
            {
                textField.secureTextEntry = YES;
                confirmField = textField;
            }
                break;
            default:
                break;
        }
    }
    else
    {
        switch (row) {
            case 0:
            {
                textField.secureTextEntry = YES;
                phoneField = textField;
            }
                break;
            case 1:
            {
                textField.secureTextEntry = YES;
                passwrodField = textField;
            }
                break;
            case 2:
            {
                textField.secureTextEntry = YES;
                confirmField = textField;
            }
                break;
            default:
                break;
        }
    }

}

#pragma mark - 点击
-(void)sendAuthCode:(UIButton *)button
{
    [self.view endEditing:YES];
    //判断输入的手机号码是否符合规范
    if (![KMTools checkPhoneNumber: phoneField.text]) {
        [self showText:@"请输入正确的手机号"];
        return;
    }
    [self codeRequest];
}

-(void)noneBtn:(UIButton *)button
{
    [self.view endEditing:YES];
    if ([self authTextFieldLength])
    {
        switch (_type) {
            case EViewRegistType:
                [self registerRequest];
                break;
            case EViewForgetType:
                [self forgetPasswordRequest];
                break;
            case EViewChangeType:
                if ([confirmField.text isEqualToString:phoneField.text]) {
                    [self showText:@"新密码不可以与原密码一样，请重新输入"];
                    return;
                }
                [self changePassWordResquest];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark -验证是否输入
- (BOOL)authTextFieldLength
{
    //判断输入的手机号码是否符合规范
    if (![KMTools checkPhoneNumber: phoneField.text] && _type < 2) {
        [self showText:@"请输入正确的手机号"];
        return NO;
    }
    
    if (phoneField.text.length < 6  && _type == 2) {
        [self showText:@"请输入正确的原密码"];
        return NO;
    }
    
    if (antuField.text.length == 0 && _type < 2) {
        [self showText:@"请输入验证码"];
        return NO;
    }
    
    //判断两次输入的密码是否一致(同时为空已处理)
    if (![confirmField.text isEqualToString:passwrodField.text]) {
        [self showText:@"两次密码不一致，请重新输入"];
        return NO;
    }
    
    if ([passwrodField.text rangeOfString:@" "].location != NSNotFound) {
        [self showText:@"密码中不能包含空格"];
        return NO;
    }
    if (passwrodField.text.length<6||passwrodField.text.length>18) {
        [self showText:@"密码长度为6-18位"];
        return NO;
    }
    return  YES;
}

- (void)saveUserData
{
    NSError  *error;
    NSString *userName = phoneField.text;
    NSString *password = passwrodField.text;
    [[NSUserDefaults standardUserDefaults] setValue: userName forKey:@"LOGIN_NAME"];
    BOOL saved = [SFHFKeychainUtils storeUsername:userName andPassword:password forServiceName:ServiceName updateExisting:YES error:&error];
    if(!saved){
        DDLogError(@"保存密码时出错：%@",error);
    }
    error = nil;
}

#pragma mark - 网络
//验证码
- (void)codeRequest {
    [self showText:@"请稍后，正在发送验证码"];
    NSString *url = @"";
    NSString *valid = @"";

    if (_type == 0)
    {
        url = [NSString stringWithFormat:@"/api/Account/SendVerifyCode/%@/10",phoneField.text];
        valid = @"10";
    }
    else
    {
        url = [NSString stringWithFormat:@"/api/Account/SendVerifyCode/%@/20",phoneField.text];
        valid = @"10";
    }
    [HTTPTool requestWithURLString:url parameters:nil showStatus:YES type:kGET success:^(id responseObject) {
        NSString *code = [responseObject objectForKey:@"ResultCode"];
        if ([code integerValue] == 0) {
            //创建获取验证码的定时器
            countdownButton.userInteractionEnabled = NO;
            countdownButton.backgroundColor = [UIColor clearColor];
            [countdownButton setTitleColor:AppFontGrayColor forState:UIControlStateNormal];
            [KMTools countdownWithTime:120 End:^{
                [countdownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                [countdownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                countdownButton.userInteractionEnabled = YES;
            } going:^(NSString *time) {
                [countdownButton setTitle:time forState:UIControlStateNormal];
            }];
        }
        else
        {
            [self showText: [responseObject objectForKey:@"ResultMessage"]];
        }

    } failure:^(NSError *error) {
    }];
}

//注册
- (void)registerRequest {
    
    NSDictionary *para = @{@"VerificationCode":antuField.text,@"Password":passwrodField.text,@"PhoneNumber":phoneField.text};
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/UserRegister" parameters:para showStatus:YES type:kPOST success:^(id responseObject) {
        NSString *code = [responseObject objectForKey:@"ResultCode"];
        if ([code integerValue] == 0) {
            [self showSuccessWithText:@"注册成功"];
            //保存密码
            [self saveUserData];
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 *NSEC_PER_SEC));
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_REGIST_SUCCESS" object:nil];
                [TalkingData trackEvent:@"22000010201" label:@"注册>注册"];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            [self showText:[responseObject objectForKey:@"ResultMessage"]];

        }

    } failure:^(NSError *error) {
    }];
}

//忘记密码
- (void)forgetPasswordRequest {
    
    NSDictionary *para = @{@"VerifyCode":antuField.text,@"NewPassword":passwrodField.text,@"PhoneNumber":phoneField.text};
    [HTTPTool requestWithURLString:@"/api/account/forgetchangepassword" parameters:para showStatus:YES type:kPOST success:^(id responseObject) {
         NSString *code = [responseObject objectForKey:@"ResultCode"];
        if ([code integerValue] == 0) {
            [self showText:@"找回密码成功"];
            [self saveUserData];
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 *NSEC_PER_SEC));
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_FORGET_SUCCESS" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            [self showText:[responseObject objectForKey:@"ResultMessage"]];
        }
        
    } failure:^(NSError *error) {
    }];
}

//修改密码
-(void)changePassWordResquest {
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserLogin.data"];
    BATLoginModel * login = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    
    NSDictionary * para = @{
                            @"AccountID":@(login.Data.ID),
                            @"OldPassword":phoneField.text,
                            @"NewPassword":passwrodField.text,
                            @"ConfirmPassword":confirmField.text
                            };
    
    [HTTPTool requestWithURLString:@"/api/Account/ChangePassword" parameters:para showStatus:YES type:kPOST success:^(id responseObject) {
        BATBaseModel * success = [BATBaseModel mj_objectWithKeyValues:responseObject];
        if (success.ResultCode == 0) {
            //执行推出登录的操作
            [self showText:@"修改密码成功"];
            SET_LOGIN_STATION(NO);
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:@"" forKey: KEY_LOGIN_TOKEN];
            [userDefaults removeObjectForKey: KEY_INSULINNAME_TARRAY];
            [userDefaults removeObjectForKey: KEY_REMINDER_ARRAY];
            [userDefaults removeObjectForKey: KEY_PHYSICALRECORD_DIC];
            [userDefaults synchronize];
            [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserLogin.data"] error:nil];
            [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"] error:nil];

            [[KMDataManager sharedDatabaseInstance] changeDatabaseName];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATA_LOGIN_STATION" object:nil];
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 *NSEC_PER_SEC));
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
        else
        {
            [self showText:success.ResultMessage];
        }
    } failure:^(NSError *error) {
    }];
    
}
@end
