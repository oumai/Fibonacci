//
//  BloodOxygenViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/18.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "BloodOxygenViewController.h"
#import "HelpViewController.h"
#import "BloodOxygenResultViewController.h"
#import "HeartLive.h"
#import "DetectView.h"

@interface BloodOxygenViewController ()

@end

@implementation BloodOxygenViewController

- (void)dealloc
{
    liveSPO2HView = nil;
    coreCameraDetection.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"血氧测量";
    [self initHelpButton:@selector(goHelpVC)];
    coreCameraDetection = [CoreCameraDetection sharedCoreCameraDetection];
    coreCameraDetection.delegate = self;
    [self getFirstOpenValue];
    [self initControllerView];
    [KMTools getAuthStatus:self];
    self.extendedLayoutIncludesOpaqueBars = NO;
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [coreCameraDetection detectionStopRunning];
    [self otherSPO2HClose];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!onceHelpPages) {
        [self goHelpVC];
        [self setFisrtOpenValue];
    }
    [self getNetDataRecord];
}

- (void)initControllerView
{
    CGFloat minY = 0;
    if (self.navigationController.navigationBar.translucent&&!self.extendedLayoutIncludesOpaqueBars) {
        minY = kStatusAndNavHeight;
    }
    CGFloat headerViewWidth = MainScreenWidth/2;
    headerSPO2HView = [[UIView alloc] initWithFrame:CGRectMake((MainScreenWidth-headerViewWidth)/2, 50 + minY, headerViewWidth, headerViewWidth) ];
    headerSPO2HView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerSPO2HView];
    
    SPO2HView = [[DetectView alloc] initWithFrame:CGRectMake(0, 0, headerViewWidth, headerViewWidth) withLineWidth:15 innerLineWidth:3];
    SPO2HView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startSPO2HTest:)];
    [headerSPO2HView addGestureRecognizer:tapGesture];
    [headerSPO2HView addSubview:SPO2HView];
    
    CGFloat sumLabelY = CGRectGetMidY(SPO2HView.frame)-25;
    sumSPO2HLable = [[UILabel alloc] initWithFrame:CGRectMake((headerViewWidth-150)/2, sumLabelY, 150, 50)];
    sumSPO2HLable.textColor = AppFontColor;
    sumSPO2HLable.font = [UIFont boldSystemFontOfSize: 40];
    sumSPO2HLable.text = @"00 %";
    sumSPO2HLable.textAlignment = NSTextAlignmentCenter;
    [headerSPO2HView addSubview:sumSPO2HLable];
    
    CGFloat heightOffset = 150;
    CGFloat yOffset = CGRectGetMaxY(headerSPO2HView.frame)+(MainScreenHeight - CGRectGetMaxY(headerSPO2HView.frame)-heightOffset)/2;
    liveSPO2HView = [[HeartLive alloc] initWithFrame:CGRectMake(0, yOffset, CGRectGetWidth(self.view.frame), heightOffset)];
    liveSPO2HView.backgroundColor = [UIColor clearColor];
    [self.view addSubview: liveSPO2HView];
    
    hudSPO2HLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerSPO2HView.frame)+40, MainScreenWidth, 40)];
    hudSPO2HLabel.text = @"用手指将摄像头完全覆盖";
    hudSPO2HLabel.textAlignment = NSTextAlignmentCenter;
    hudSPO2HLabel.textColor = AppFontColor;
    [self.view addSubview:hudSPO2HLabel];
    
    CGFloat staetButtonH = 50;
    startSPO2HButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startSPO2HButton.frame = CGRectMake( MainScreenWidth/3, CGRectGetMidY(liveSPO2HView.frame)-staetButtonH/2, MainScreenWidth/3, staetButtonH);
    [startSPO2HButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startSPO2HButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [startSPO2HButton setTitle: @"开始测量" forState:UIControlStateNormal];
    [startSPO2HButton addTarget:self action:@selector(startSPO2HTestBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"btn"];
    [startSPO2HButton setBackgroundImage: image forState:UIControlStateNormal];
    [self.view addSubview:startSPO2HButton];
}

- (void)getNetDataRecord
{
    NSDictionary *dic = GET_PHYSICALRECOID;
    NSDictionary *resultDic = [dic objectForKey:@"result"];
    NSArray *array = [resultDic objectForKey:@"血氧"];
    netRecordValue = [[array lastObject] integerValue];
}

#pragma mark - 开关按钮
-(void)startSPO2HTest:(UITapGestureRecognizer *)tap
{
    if ([coreCameraDetection cameraRunningStatus])
    {
        [self otherSPO2HClose];
        [coreCameraDetection detectionStopRunning];
    }
}

- (void)startSPO2HTestBtn:(id)sender
{
    if (![coreCameraDetection cameraRunningStatus]&&[KMTools getAuthStatus:self])
    {
        [TalkingData trackEvent:@"210000701" label:@"血氧测试>开始测量"];
        hudSPO2HLabel.text = @"正在采集数据......";
        startSPO2HButton.hidden = YES;
        coreCameraDetection.timerCount = 15;
        NSNumber *number = [NSNumber numberWithInteger:coreCameraDetection.timerCount];
        CGFloat timerValue = [number floatValue];
        augendValue = 1/timerValue/10;
        SPO2HTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerRefresnFun) userInfo:nil repeats:YES];
        [SPO2HView begin];
        [coreCameraDetection detectionStartRunning];
    }
}

//定时执行方法
- (void)timerSPO2HClose
{
    [SPO2HTimer invalidate];
    SPO2HTimer = nil;
}

-(void)otherSPO2HClose
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SPO2HView stop];
        hudSPO2HLabel.text = @"用手指将摄像头完全覆盖";
        startSPO2HButton.hidden = NO;
        [self clearLive];
    });
    [self timerSPO2HClose];
}

#pragma mark - _refreshMoniterView DataSource
- (void)initRefresMoniterPoint
{
    xCoordinateInMoniter = 0;
}

- (void)clearLive
{
    [self initRefresMoniterPoint];
    [liveSPO2HView stopDrawing];
    [SPO2HArray removeAllObjects];
}

//把心跳数值转换为坐标
- (CGPoint)bubbleRefreshPoint
{
    CGFloat liveHeight = CGRectGetHeight(liveSPO2HView.frame);
    NSInteger pixelPerPoint = 2;
    if (![SPO2HArray count]) {
        return (CGPoint){xCoordinateInMoniter, liveHeight/2};
    }
    CGFloat pointY= [SPO2HArray[0]floatValue];
    if (-10<pointY&&pointY<10) {
        pointY = 0;
    }
    pointY = (liveHeight/2 - pointY);
    if (pointY<0)
    {
        pointY = 1;
    }
    else if (pointY > liveHeight)
    {
        pointY = liveHeight-1;
    }
    CGPoint targetPointToAdd = (CGPoint){xCoordinateInMoniter,pointY};
    xCoordinateInMoniter += pixelPerPoint;
    xCoordinateInMoniter %= (int)(CGRectGetWidth(liveSPO2HView.frame));
    return targetPointToAdd;
}

//刷新方式绘制
- (void)timerRefresnFun
{
    [[PointContainer sharedContainer] addPointAsRefreshChangeform:[self bubbleRefreshPoint]];
    [liveSPO2HView fireDrawingWithPoints:[PointContainer sharedContainer].refreshPointContainer pointsCount:[PointContainer sharedContainer].numberOfRefreshElements];
}

#pragma mark - CoreCameraDetection Delegate

-(void)cameraDetection:(CoreCameraDetection *)cameraDetection didOutputSampleErrorCount:(NSUInteger)errorCount
{
    if (errorCount ==1) {
        [SVProgressHUD showErrorWithStatus: @"请将手指覆盖摄像头"];
    }
    else if(errorCount == 2)
    {
        [coreCameraDetection detectionStopRunning];
        [SVProgressHUD dismiss];
        [self otherSPO2HClose];
    }
}

-(void)cameraDetection:(CoreCameraDetection* )cameraDetection didOutputSamplePassValue:(float)passValue
{
    if(!SPO2HArray)
        SPO2HArray = [NSMutableArray new];
    NSNumber * number = @(passValue*300);
    [SPO2HArray insertObject:number atIndex:0];
    while(SPO2HArray.count > 10)
        [SPO2HArray removeLastObject];
}

-(void)cameraDetection:(CoreCameraDetection* )cameraDetection didOutputSampleHeartCount:(NSUInteger)heartCount andTimerCount:(NSUInteger)timerCount
{
    NSInteger count = 0;
    if (netRecordValue > 5) {
        count = [KMTools getRandomFrome: netRecordValue-5 to: netRecordValue+5];
        if (count>99) {
            count = 99;
        }
    }
    else
    {
         count = [self heartCountTransformationSPO2H:heartCount];
    }
    sumSPO2HLable.text = [NSString stringWithFormat:@"%li %%",(long)count];
    currntTimer = timerCount;
    if (timerCount >= coreCameraDetection.timerCount)
    {
        [cameraDetection closeDetectionTimer];
        [self otherSPO2HClose];
        [self goResultVC:count];
    }
}

-(NSInteger )heartCountTransformationSPO2H:(NSInteger)count
{
    if (count<60)
    {
        count = 100;
    }
    else if (count < 70)
    {
        count = 90;
    }
    else if (count < 80)
    {
        count = 80;
    }
    else if (count < 90)
    {
        count = 70;
    }
    else if (count > 90)
    {
        count = 60;
    }
    count = 94 + 5-(count-55)/10;
    return count;
}

#pragma mark -
- (void)goResultVC:(NSInteger)count
{
    if (coreCameraDetection.delegate == nil) {
        return;
    }
    UIStoryboard *sboard = [KMTools getStoryboardInstance];
    BloodOxygenResultViewController *viewController = [sboard instantiateViewControllerWithIdentifier:@"BloodOxygenResultViewController"];
    viewController.bloodOxygenResultValue = count;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - 帮助页面
-(void)goHelpVC
{
    UIStoryboard *sboard = [KMTools getStoryboardInstance];
    HelpViewController *helpViewController = [sboard instantiateViewControllerWithIdentifier:@"HelpViewController"];
    helpViewController.helpType = EPageHelpTypeNone;
    helpViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:helpViewController animated:YES];
}

- (void)getFirstOpenValue
{
    NSString *firstEyeValue = [[NSUserDefaults standardUserDefaults] valueForKey:@"FirstGoBloodOxygen"];
    if ([firstEyeValue isEqualToString:@""])
    {
        onceHelpPages = YES;
    }
}

- (void)setFisrtOpenValue
{
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"FirstGoBloodOxygen"];
    onceHelpPages = YES;
}

#pragma mark - didReceiveMemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
