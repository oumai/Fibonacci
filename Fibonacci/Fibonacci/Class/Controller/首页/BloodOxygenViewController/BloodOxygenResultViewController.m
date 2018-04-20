//
//  BloodOxygenResultViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/22.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "BloodOxygenResultViewController.h"
#import "HeartView.h"
#import "DetectioResultView.h"
#import "ManuallyEnteredViewController.h"
#import "ShareCustom.h"
#import "AppDelegate+BATShare.h"

#define DetectioHeartViewHeightAndWidth 35
#define HeightHeartRate 101 //设定显示的最大值
#define LowHeartRate 90 //设定显示的最小值

@interface BloodOxygenResultViewController ()

@end

static const NSTimeInterval TIDetectioResultViewControllerHeartMoveInterval = 1.0;


@implementation BloodOxygenResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试结果";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[KMDataManager sharedDatabaseInstance] insertBloodOxygenDataModelFromNumber:[NSNumber numberWithInteger:_bloodOxygenResultValue]];
    });
    
    [self initBloodOxygenResultViewAndData];
    [self getBloodOxygenHeartMoveY];
    

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self animateForheartMove];
}

- (void)initBloodOxygenResultViewAndData
{
    CGFloat minY = 0;
    if (self.navigationController.navigationBar.translucent&&!self.extendedLayoutIncludesOpaqueBars) {
        minY = kStatusAndNavHeight;
    }
    CGFloat labelMinY = 50+minY;
    if(iPhone5)
    {
        labelMinY = 20+minY;
    }
    UILabel *bloodOxygenResultLabel = [[UILabel alloc] initWithFrame:CGRectMake((MainScreenWidth- 70)/2, labelMinY, 80, 50)];
    bloodOxygenResultLabel.textColor = RGB(223, 169, 36);
    bloodOxygenResultLabel.font = [UIFont boldSystemFontOfSize: 40];
    bloodOxygenResultLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_bloodOxygenResultValue];
    bloodOxygenResultLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bloodOxygenResultLabel];
    
    UILabel *unitLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bloodOxygenResultLabel.frame), CGRectGetMidY(bloodOxygenResultLabel.frame)-25/2, 50, 25)];
    unitLabel.textColor = AppFontColor;
    unitLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18];
    unitLabel.text = @"%";
    unitLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:unitLabel];
    
    CGFloat DetectioResultViewWidth = MainScreenWidth - 50; //色彩渐变条的宽度
    CGFloat detectioHeartViewStartX = (25-DetectioHeartViewHeightAndWidth/2); //心的起始Y
    
    bloodOxygenHeartView = [[HeartView alloc]initWithFrame:CGRectMake(detectioHeartViewStartX, CGRectGetMaxY(bloodOxygenResultLabel.frame)+(iPhone5?50:60), DetectioHeartViewHeightAndWidth, DetectioHeartViewHeightAndWidth)];
    bloodOxygenHeartView.lineWidth = 0.1;
    bloodOxygenHeartView.strokeColor = RGB(230, 101, 96);
    bloodOxygenHeartView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bloodOxygenHeartView];
    
    DetectioResultView *bloodOxygenResultView = [[DetectioResultView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(bloodOxygenHeartView.frame), DetectioResultViewWidth, 12)];
//    bloodOxygenResultView.backgroundColor = [UIColor whiteColor];
    bloodOxygenResultView.layer.cornerRadius = 7.0;
    bloodOxygenResultView.layer.masksToBounds = YES;
    [self.view addSubview:bloodOxygenResultView];

    
    CGFloat labelW = DetectioResultViewWidth/4;
    NSArray *textArray = @[@"<90",@"90-94",@"94-97",@">97"];
    for (int i = 0; i <4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelW*i+25, CGRectGetMaxY(bloodOxygenResultView.frame), labelW, 30)];
        label.text = textArray[i];
        label.font = [UIFont fontWithName:@"Avenir-Light" size:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = AppFontColor;
        [self.view addSubview:label];
    }
    
    hudLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(bloodOxygenResultView.frame)+(iPhone5?35:50), MainScreenWidth-60, 100)];
    hudLabel.textAlignment = NSTextAlignmentCenter;
    hudLabel.text = @"身体不错呦(╯▽╰)";
    hudLabel.font = [UIFont fontWithName:@"Avenir-Light" size:14];
    hudLabel.textColor = AppFontColor;
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

- (void)getBloodOxygenHeartMoveY
{
    CGFloat DetectioResultViewWidth = MainScreenWidth - 50; //色彩渐变条的宽度
    CGFloat pixelY = DetectioResultViewWidth/(HeightHeartRate-LowHeartRate);  //每个心跳需要移动的坐标
    CGFloat detectioHeartViewStartX = (25-DetectioHeartViewHeightAndWidth/2); //心的起始Y
    if (_bloodOxygenResultValue <=LowHeartRate)
    {
        _bloodOxygenResultValue = LowHeartRate;
    }
    else if (_bloodOxygenResultValue >=HeightHeartRate)
    {
        _bloodOxygenResultValue = HeightHeartRate;
    }
    bloodOxygenResultHeartViewY = (_bloodOxygenResultValue - LowHeartRate)*pixelY + detectioHeartViewStartX;
    if (bloodOxygenResultHeartViewY>(DetectioResultViewWidth+detectioHeartViewStartX))
    {
        bloodOxygenResultHeartViewY = DetectioResultViewWidth+detectioHeartViewStartX;
    }
    else if (bloodOxygenResultHeartViewY< detectioHeartViewStartX)
    {
        bloodOxygenResultHeartViewY = detectioHeartViewStartX;
    }
}

- (void)animateForheartMove
{
    [UIView animateWithDuration:TIDetectioResultViewControllerHeartMoveInterval
                     animations:^(void) {
                         CGRect heartFrame = bloodOxygenHeartView.frame;
                         heartFrame.origin.x = bloodOxygenResultHeartViewY;
                         bloodOxygenHeartView.frame = heartFrame;
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
    helpViewController.enteredType = EEnteredBloodOxygenType;
    [self.navigationController pushViewController:helpViewController animated:YES];
}

-(void)shareButton:(UIButton*)button
{
    [TalkingData trackEvent:@"210000702" label:@"测量结果页>分享"];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"logo"]];
    if (imageArray)
    {
        NSString *paramsText = [NSString stringWithFormat:@"%@!%@",hudLabel.text,SHARE_URL];
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
