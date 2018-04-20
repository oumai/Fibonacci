//
//  RootViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/10/14.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "RootViewController.h"
//#import "KMWeatherManage.h"
#import "HealthKitManage.h"
#import "SFHFKeychainUtils.h"
#import "AppDelegate.h"
#import "AppDelegate+BATShare.h"
#import "HTTPTool+LoginRequest.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHelpPagesCount];
//    [KMWeatherManage sharedWeatherManage];
    
#if TARGET_OS_IPHONE//真机
        [[HealthKitManage shareInstance] authorizeHealthKit:^(BOOL success, NSError *error) {
        }];
        [KMTools getAuthStatus:self];
#endif
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
-(void)automaticLogin
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
    NSString *userName = [userDefaults valueForKey: KEY_LOGIN_NAME];
    if (userName.length >1) {
        
        NSError *error;
        NSString * password = [SFHFKeychainUtils getPasswordForUsername: userName andServiceName:ServiceName error:&error];
        if(error){
            DDLogError(@"从Keychain里获取密码出错：%@",error);
            return;
        }
        [HTTPTool LoginWithUserName: userName
                           password: password
                            Success:^{
                            }failure:^(NSError *error) {
                            }];
    }
}

-(void)setHelpPagesCount
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *allKeys = [[NSUserDefaults standardUserDefaults].dictionaryRepresentation allKeys];
    NSArray *firstArray = @[@"FirstGoEye", @"FirstGoColor", @"FirstGoHeartRate", @"FirstGoBloodOxygen", @"FirstGoBloodPressure", @"FirstGoMedicallyExamined"];
    for (NSString *elem in firstArray)
    {
        if (![allKeys containsObject: elem])
        {
            [userDefaults setValue:elem forKey: elem];
        }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
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
