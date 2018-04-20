//
//  VitalCapacityResultViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/22.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "VitalCapacityResultViewController.h"
#import "DetectioResultView.h"
#import "HeartView.h"
#import "ManuallyEnteredViewController.h"
#import "ShareCustom.h"
#import "AppDelegate+BATShare.h"

@interface VitalCapacityResultViewController ()

@end

#define DetectioHeartViewHeightAndWidth 35
#define HeightHeartRate 5000 //设定显示的最大值
#define LowHeartRate 1 //设定显示的最小值

static const NSTimeInterval TIDetectioResultViewControllerHeartMoveInterval = 1.0;


@implementation VitalCapacityResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试结果";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[KMDataManager sharedDatabaseInstance] insertVitalCapacityDataModelFromNumber:[NSNumber numberWithInteger:_markValue]];
    });
    [self initResultViewAndData];
    [self getHeartMoveY];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self animateForheartMove];
}

- (void)initResultViewAndData
{
    CGFloat minY = 0;
    if (self.navigationController.navigationBar.translucent&&!self.extendedLayoutIncludesOpaqueBars) {
        minY = kStatusAndNavHeight;
    }
    UILabel* heartResultLabel = [[UILabel alloc] initWithFrame:CGRectMake((MainScreenWidth- 140)/2, 50+minY, 140, 50)];
    heartResultLabel.textColor = AppFontYellowColor;
    heartResultLabel.font = [UIFont systemFontOfSize: 50];
    heartResultLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_markValue];
    heartResultLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:heartResultLabel];
    
    UILabel* HUDLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(heartResultLabel.frame) + 10, CGRectGetMaxY(heartResultLabel.frame)-30, 50, 25)];
    HUDLabel.textColor = AppFontColor;
    HUDLabel.font = [UIFont fontWithName:@"Avenir-Light" size:15];
    HUDLabel.text = @"毫升";
    HUDLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:HUDLabel];
    
    CGFloat detectioHeartViewStartX = (25-DetectioHeartViewHeightAndWidth/2); //心的起始X
    CGFloat detectioHeartViewStartY = CGRectGetMaxY(heartResultLabel.frame)+(iPhone5?50:100);
    vitalCapacityHeartView = [[HeartView alloc]initWithFrame:CGRectMake(detectioHeartViewStartX, detectioHeartViewStartY, DetectioHeartViewHeightAndWidth, DetectioHeartViewHeightAndWidth)];
    vitalCapacityHeartView.lineWidth = 0.1;
    vitalCapacityHeartView.strokeColor = [UIColor redColor];
    vitalCapacityHeartView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:vitalCapacityHeartView];
    
    CGFloat DetectioResultViewWidth = MainScreenWidth - 50; //色彩渐变条的宽度
    DetectioResultView *detectioResultView = [[DetectioResultView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(vitalCapacityHeartView.frame), DetectioResultViewWidth, 12)];
    detectioResultView.backgroundColor = [UIColor whiteColor];
    detectioResultView.layer.cornerRadius = 7.0;
    detectioResultView.layer.masksToBounds = YES;
    [self.view addSubview:detectioResultView];
    
    CGFloat labelW = DetectioResultViewWidth/4;
    NSArray *textArray = @[@"<1500",@"1500-2000",@"2500-4000",@">4000"];
    for (int i = 0; i <4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelW*i+25, CGRectGetMaxY(detectioResultView.frame), labelW, 30)];
        label.text = textArray[i];
        label.font = [UIFont fontWithName:@"Avenir-Light" size:14];;
        label.textAlignment = i>1?NSTextAlignmentRight:NSTextAlignmentLeft;
        label.textColor = AppFontColor;
        [self.view addSubview:label];
    }
    
    UILabel *hudLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(detectioResultView.frame)+(iPhone5?35:50), MainScreenWidth-60, 100)];
    hudLabel.textAlignment = NSTextAlignmentCenter;
    hudLabel.text = _markValue>=2500?@"身体不错呦(╯▽╰)":@"确定是用嘴吹的？";
    hudLabel.font = [UIFont fontWithName:@"Avenir-Light" size:14];
    hudLabel.textColor = AppFontColor;
    shareText = hudLabel.text;
    [self.view addSubview:hudLabel];
    
    CGFloat buttonH = 50;
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(MainScreenWidth/3, CGRectGetMaxY(hudLabel.frame)+30, MainScreenWidth/3, buttonH);
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
    [self.view addSubview:accuracyButton];
    
    UILabel *resultHUDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainScreenHeight-40, MainScreenWidth, 40)];
    resultHUDLabel.font = [UIFont fontWithName:AppFontHelvetica size:13];
    resultHUDLabel.textAlignment = NSTextAlignmentCenter;
    resultHUDLabel.textColor = AppFontGrayColor;
    resultHUDLabel.numberOfLines = 2;
    resultHUDLabel.text = @"数据可能会存在一定范围的误差,测量结果仅供参考";
    [self.view addSubview:resultHUDLabel];
}

//计算坐标
- (void)getHeartMoveY
{
    CGFloat DetectioResultViewWidth = MainScreenWidth - 50; //色彩渐变条的宽度
    CGFloat pixelY = DetectioResultViewWidth/(HeightHeartRate-LowHeartRate);  //每个心跳需要移动的坐标
    CGFloat detectioHeartViewStartX = (25-DetectioHeartViewHeightAndWidth/2); //心的起始Y
    if (_markValue<=LowHeartRate)
    {
        _markValue = LowHeartRate;
    }
    else if (_markValue >=HeightHeartRate)
    {
        _markValue = HeightHeartRate;
    }
    vitalCapacityHeartViewY = (_markValue - LowHeartRate)*pixelY + detectioHeartViewStartX;
    if (vitalCapacityHeartViewY>(DetectioResultViewWidth+detectioHeartViewStartX))
    {
        vitalCapacityHeartViewY = DetectioResultViewWidth+detectioHeartViewStartX;
    }
    else if (vitalCapacityHeartViewY< detectioHeartViewStartX)
    {
        vitalCapacityHeartViewY = detectioHeartViewStartX;
    }
}

- (void)animateForheartMove
{
    [UIView animateWithDuration:TIDetectioResultViewControllerHeartMoveInterval
                     animations:^(void) {
                         CGRect heartFrame = vitalCapacityHeartView.frame;
                         heartFrame.origin.x = vitalCapacityHeartViewY;
                         vitalCapacityHeartView.frame = heartFrame;
                     } completion:^(BOOL completed) {
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)accuracyButton:(UIButton *)button
{
    UIStoryboard *sboard = [KMTools getStoryboardInstance];
    ManuallyEnteredViewController *helpViewController = [sboard instantiateViewControllerWithIdentifier:@"ManuallyEnteredViewController"];
    helpViewController.hidesBottomBarWhenPushed = YES;
    helpViewController.enteredType = EEnteredVitalCapacityType;
    [self.navigationController pushViewController:helpViewController animated:YES];
}

-(void)shareButton:(UIButton*)button
{
    [TalkingData trackEvent:@"210000602" label:@"测量结果页>分享"];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"logo"]];
    if (imageArray)
    {
        NSString *paramsText = [NSString stringWithFormat:@"%@ %@",shareText,SHARE_URL];
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
