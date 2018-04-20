//
//  BloodDetectioResultViewController.m
//  Fibonacci
//
//  Created by shipeiyuan on 16/8/31.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "BloodDetectioResultViewController.h"
#import "HeartBackgroundView.h"
#import "HelpViewController.h"
#import "ManuallyEnteredViewController.h"
#import "ShareCustom.h"
#import "AppDelegate+BATShare.h"
@interface BloodDetectioResultViewController ()

@end

static CGFloat strokeEndFloat = 0.85;
static CGFloat heightFloat = 139;
static CGFloat lowFloat = 90;


@implementation BloodDetectioResultViewController
@synthesize systolicPressure = _systolicPressure;
@synthesize diatolicPressure = _diatolicPressure;

-(void)dealloc
{
    [crazyView removeFromSuperview];
    crazyView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试结果";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[KMDataManager sharedDatabaseInstance] insertBloodPressureDataModelFromSPNumber: [NSNumber numberWithInteger: _systolicPressure] andDPNumber:[NSNumber numberWithInteger: _diatolicPressure]];
    });    
    [self setControllerView];
    [self calculationAverageAndSumValue];
    animateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(resultAnimate) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [crazyView stopAnimating];
    crazyView.animationImages = nil;
}

- (void)setControllerView
{
    CGFloat minY = 0;
    if (self.navigationController.navigationBar.translucent&&!self.extendedLayoutIncludesOpaqueBars) {
        minY = kStatusAndNavHeight;
    }
    CGFloat resultCircularWidth = 200;
    CGFloat resultValueLabelWidth = 135;
    CGFloat resultCircularX = (MainScreenWidth - resultCircularWidth)/2;
    CGFloat resultCircularY = 100 + minY;
    if(iPhone5)
    {
        resultCircularY = 50;
    }
    bloodResultView=[[HeartBackgroundView alloc] initWithFrame:CGRectMake(resultCircularX, resultCircularY, resultCircularWidth, resultCircularWidth) strokeEnd:strokeEndFloat transformType: HeartBackgroundViewTransformStatusLeft];
    [bloodResultView setLineWidth:12.f];
    [bloodResultView setLineColr:RGB(107, 229, 234)];
    [self.view addSubview: bloodResultView];
    
    CGFloat resultValueLabelX = (MainScreenWidth-resultValueLabelWidth)/2;
    UILabel* valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(resultValueLabelX, CGRectGetMidY(bloodResultView.frame)-35, resultValueLabelWidth, 35)];
    valueLabel.text = [NSString stringWithFormat:@"%li/%li",(long)_systolicPressure, (long)_diatolicPressure];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    valueLabel.font = [UIFont boldSystemFontOfSize:40];
    valueLabel.textColor = AppFontYellowColor;
    [self.view addSubview:valueLabel];
    
    UILabel* mmHgHudLabel = [[UILabel alloc] initWithFrame:CGRectMake(resultCircularX, CGRectGetMaxY(valueLabel.frame)+15, resultCircularWidth, 15)];
    mmHgHudLabel.text = @"mmHg";
    mmHgHudLabel.textAlignment = NSTextAlignmentCenter;
    mmHgHudLabel.font = [UIFont systemFontOfSize:12];
    mmHgHudLabel.textColor = AppFontGrayColor;
    [self.view addSubview:mmHgHudLabel];
    
    UILabel *bloodHudLabel = [[UILabel alloc] initWithFrame:CGRectMake(resultCircularX, CGRectGetMaxY(mmHgHudLabel.frame)+15, resultCircularWidth, 35)];
    bloodHudLabel.textAlignment = NSTextAlignmentCenter;
    bloodHudLabel.font = [UIFont systemFontOfSize:16];
    bloodHudLabel.textColor = RGB(230, 96, 85);
    [self.view addSubview:bloodHudLabel];
    
    textHudLabel = [[UILabel alloc] initWithFrame:CGRectMake((MainScreenWidth-resultCircularWidth*2)/2, CGRectGetMaxY(bloodResultView.frame)+5, resultCircularWidth*2, 35)];
    textHudLabel.textAlignment = NSTextAlignmentCenter;
    textHudLabel.font = [UIFont systemFontOfSize:12];
    textHudLabel.textColor = AppFontColor;
    [self.view addSubview:textHudLabel];

    if (_systolicPressure <= 139&&_systolicPressure >=90)
    {
        bloodHudLabel.text = @"血压值正常";
        bloodHudLabel.textColor = AppFontColor;
        textHudLabel.text = @"您的血压正常，恭喜！";
    }
    else if (_systolicPressure<90)
    {
        bloodHudLabel.text = @"血压值偏低";
        textHudLabel.text = @"您的血压偏低，请注意您的生活方式！";
    }
    else
    {
        bloodHudLabel.text = @"血压值偏高";
        textHudLabel.text = @"您的血压偏高，请注意您的生活方式！";
    }

    CGFloat buttonH = 50;
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake( MainScreenWidth/3, CGRectGetMaxY(textHudLabel.frame)+50, MainScreenWidth / 3, buttonH);
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [shareButton setTitle: @"分享" forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButton:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"btn"];
    [shareButton setBackgroundImage: image forState:UIControlStateNormal];
    [self.view addSubview:shareButton];
    
    UIButton *accuracyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    accuracyButton.frame = CGRectMake(50, CGRectGetMaxY(shareButton.frame)+5, MainScreenWidth - 100, buttonH);
    [accuracyButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [accuracyButton setTitle: @"不准" forState:UIControlStateNormal];
    [accuracyButton addTarget:self action:@selector(accuracyButton:) forControlEvents:UIControlEventTouchUpInside];
    [accuracyButton setTitleColor:AppFontColor forState:UIControlStateNormal];
    [self.view addSubview:accuracyButton];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, MainScreenHeight-40, MainScreenWidth, 40)];
    label.font = [UIFont fontWithName:AppFontHelvetica size:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = AppFontGrayColor;
    label.numberOfLines = 2;
    label.text = @"数据可能会存在一定范围的误差,测量结果仅供参考";
    [self.view addSubview:label];
}

-(void)calculationAverageAndSumValue
{
    averageValue = strokeEndFloat/(heightFloat-lowFloat);
    if (_systolicPressure >lowFloat&&_systolicPressure <heightFloat)
    {
        sumValue = (_systolicPressure - lowFloat);
    }
    else if (_systolicPressure <lowFloat)
    {
        sumValue = 0;
    }
    else if (_systolicPressure>heightFloat)
    {
        sumValue = heightFloat-lowFloat;
    }
    sumValue = sumValue*averageValue;
}

-(void)resultAnimate
{
    CGFloat value = averageValue;
    bloodResultView.value += value;
    if (bloodResultView.value >=sumValue) {
        bloodResultView.value = sumValue;
        [animateTimer invalidate];
        animateTimer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonAction
-(void)accuracyButton:(UIButton *)button
{
    UIStoryboard *sboard = [KMTools getStoryboardInstance];
    ManuallyEnteredViewController *helpViewController = [sboard instantiateViewControllerWithIdentifier:@"ManuallyEnteredViewController"];
    helpViewController.hidesBottomBarWhenPushed = YES;
    helpViewController.enteredType = EEnteredBloodPressureType;
    [self.navigationController pushViewController:helpViewController animated:YES];
}

-(void)shareButton:(UIButton*)button
{
    [TalkingData trackEvent:@"210000302" label:@"测量结果页>分享"];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"logo"]];
    if (imageArray)
    {
        NSString *paramsText = [NSString stringWithFormat:@"%@!%@", textHudLabel.text, SHARE_URL];
        [shareParams SSDKSetupShareParamsByText:paramsText
                                         images:imageArray
                                            url:[NSURL URLWithString:SHARE_URL]
                                          title:@"康美小管家"
                                           type:SSDKContentTypeAuto];
    }
    [ShareCustom shareWithContent:shareParams];
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
