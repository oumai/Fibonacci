//
//  HealthStepViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/8.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "HealthStepViewController.h"
#import "DetectView.h"
#import "HealthKitManage.h"

@interface HealthStepViewController ()

@end

@implementation HealthStepViewController
- (void)dealloc
{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"计步";
    [self initHealthStepVC];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[HealthKitManage shareInstance] authorizeHealthKit:^(BOOL success, NSError *error) {
        if (success)
        {
            [self getHealthStepValue];
            [self getHealthKilometresValue];
            [self getHealthCaloriesValue];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    valueTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(resultStepAnimate) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initHealthStepVC
{
    CGFloat minY = 0;
    if (self.navigationController.navigationBar.translucent&&!self.extendedLayoutIncludesOpaqueBars) {
        minY = kStatusAndNavHeight;
    }
    UILabel *datelabel = [[UILabel alloc] initWithFrame:CGRectMake((MainScreenWidth-200)/2, minY +80, 200, 50)];
    datelabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-UltraLight" size:25];
    datelabel.textColor = AppFontColor;
    datelabel.textAlignment = NSTextAlignmentCenter;
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [dateFormatter setTimeZone:zone];
    datelabel.text = [dateFormatter stringFromDate:nowDate];
    [self.view addSubview:datelabel];
    
    float heartViewWidth = (MainScreenWidth-80)/2;
    heartRoundView = [[DetectView alloc] initWithFrame:CGRectMake((MainScreenWidth-heartViewWidth)/2, CGRectGetMaxY(datelabel.frame)+50, heartViewWidth, heartViewWidth)  ];
    heartRoundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:heartRoundView];
    
    UILabel *heartHUDLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, heartViewWidth-20, 20)];
    heartHUDLabel.center = CGPointMake(heartRoundView.center.x, heartRoundView.center.y-20);
    heartHUDLabel.textColor = AppFontColor;
    heartHUDLabel.textAlignment = NSTextAlignmentCenter;
    heartHUDLabel.font = [UIFont fontWithName:@"Helvetica-Light" size: 12];
    heartHUDLabel.text = @"今日步数";
    [self.view addSubview:heartHUDLabel];
    
    valuelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, heartViewWidth-20, 50)];
    valuelabel.center = CGPointMake(heartRoundView.center.x, heartRoundView.center.y+10);
    valuelabel.font = [UIFont fontWithName:@"Helvetica-Light" size: 31];
    valuelabel.textColor = AppFontYellowColor;
    valuelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:valuelabel];
    
    UIView *otherView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(heartRoundView.frame)+80, MainScreenWidth, 60)];
    [self.view addSubview:otherView];
    
    kilometresLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth/2, 30)];
    kilometresLabel.font = [UIFont fontWithName:@"Helvetica-Light" size: 18];
    kilometresLabel.textColor = AppFontYellowColor;
    kilometresLabel.textAlignment = NSTextAlignmentCenter;
    [otherView addSubview:kilometresLabel];
    UILabel *kilometresHUDLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(kilometresLabel.frame), MainScreenWidth/2, 30)];
    kilometresHUDLabel.font = [UIFont fontWithName:@"Helvetica-Light" size: 15];
    kilometresHUDLabel.textColor = AppFontColor;
    kilometresHUDLabel.textAlignment = NSTextAlignmentCenter;
    kilometresHUDLabel.text = @"距离";
    [otherView addSubview:kilometresHUDLabel];

    
    caloriesLabel = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth/2, 0, MainScreenWidth/2, 30)];
    caloriesLabel.font = [UIFont fontWithName:@"Helvetica-Light" size: 18];
    caloriesLabel.textColor = AppFontYellowColor;
    caloriesLabel.textAlignment = NSTextAlignmentCenter;
    [otherView addSubview:caloriesLabel];
    
    UILabel *caloriesHUDLabel = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth/2, CGRectGetMaxY(kilometresLabel.frame), MainScreenWidth/2, 30)];
    caloriesHUDLabel.font = [UIFont fontWithName:@"Helvetica-Light" size: 15];
    caloriesHUDLabel.textColor = AppFontColor;
    caloriesHUDLabel.textAlignment = NSTextAlignmentCenter;
    caloriesHUDLabel.text = @"消耗";
    [otherView addSubview:caloriesHUDLabel];
}

#pragma mark -获取健康数据
- (void)hudHealthAuthorization
{
    if (healthStatus) {
        return;
    }
    healthStatus = YES;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法获取健康数据" message:@"请开启健康权限：设置->隐私->健康->康美小管家" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=privacy"]];
    }];
    [alertController addAction:sureAction];
    UIAlertAction *canleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:canleAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//获取步行数
- (void)getHealthStepValue
{
    HealthKitManage *manage = [HealthKitManage shareInstance];
    [manage getStepCountFromDate:[NSDate date] completion:^(double value, NSError *error) {
        sumValue = value;
        dispatch_async(dispatch_get_main_queue(), ^{
            valuelabel.text = [NSString stringWithFormat:@"%.0f", sumValue];
            [self healthStepAverageAndSumValue];
        });
    }];

}

//获取公里数
-(void)getHealthKilometresValue
{
    HealthKitManage *manage = [HealthKitManage shareInstance];
    [manage getDistanceFromDate:[NSDate date] completion:^(double value, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            kilometresLabel.text = [NSString stringWithFormat:@"%.2f公里", value];
        });
    }];

}

//获取卡路里
-(void)getHealthCaloriesValue
{
    __block double stepValue;
    HealthKitManage *manage = [HealthKitManage shareInstance];
    NSDate *date = [NSDate date];
    [manage getStepCountFromDate:date completion:^(double value, NSError *error) {
        stepValue = value;
        dispatch_async(dispatch_get_main_queue(), ^{
            caloriesLabel.text = [NSString stringWithFormat:@"%.1f卡", stepValue*0.04];
        });
//        [manage getCaloriesFromDate:date completion:^(double value, NSError *error){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"卡路里 3 %f",stepValue*0.04);
//                caloriesLabel.text = [NSString stringWithFormat:@"%.1f卡", stepValue*0.04];
//            });
//        }];
    }];

    
}

-(void)healthStepAverageAndSumValue
{
    CGFloat a = 1.f;
    CGFloat b = 6500.f;
    averageValue = a/b;
    sumValue = sumValue*averageValue;
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
