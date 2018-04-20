//
//  HeartRateDetectioViewController.m
//  Fibonacci
//
//  Created by shipeiyuan on 16/8/24.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "HeartRateDetectioViewController.h"
#import "HeartLive.h"
#import "HeartView.h"
#import "DetectView.h"
#import "DetectioResultViewController.h"
#import "CoreCameraDetection.h"
#import "HelpViewController.h"

@interface HeartRateDetectioViewController ()
@property (nonatomic,strong) NSTimer *heartTimer;       //心率图定时器
@property (nonatomic,strong) HeartLive *refreshMoniterView; //心率图
@property (nonatomic, strong) DetectView *detectView;
@property (nonatomic,strong) HeartView *heartView;  //心形
@end

@implementation HeartRateDetectioViewController

- (void)dealloc
{
    _refreshMoniterView = nil;
    coreCameraDetection.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"心率测量";
//    self.view.backgroundColor = [UIColor whiteColor];
    [self initHelpButton:@selector(goHelpVC)];
    coreCameraDetection = [CoreCameraDetection sharedCoreCameraDetection];
    coreCameraDetection.delegate = self;
    [self getFirstOpenValue];
    [self initViewData];
    [KMTools getAuthStatus:self];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!onceHeartRateHelp) {
        [self goHelpVC];
        [self setFisrtOpenValue];
    }
    [self getNetHeartRateRecord];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [coreCameraDetection detectionStopRunning];
    [self otherClose];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)initViewData
{
    CGFloat minX = 0;
    if (self.navigationController.navigationBar.translucent&&!self.extendedLayoutIncludesOpaqueBars) {
        minX = kStatusAndNavHeight;
    }
    CGFloat headerViewWidth = MainScreenWidth/2;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth/4, 50 + minX, headerViewWidth, headerViewWidth)];
    [self.view addSubview:headerView];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startTest:)];
    [headerView addGestureRecognizer:tapGesture];
    
    _detectView = [[DetectView alloc] initWithFrame:CGRectMake(0, 0, headerViewWidth, headerViewWidth)];
    _detectView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:_detectView];

    CGFloat sumLabelY = CGRectGetMidY(_detectView.frame)-30;
    CGFloat fontSize = 40.f;
    CGFloat sumW = 100.f;
    CGFloat sumLabelX = (headerViewWidth/2)-sumW+10;
    if (iPhone6p) {
        sumLabelX += 5;;
        fontSize = 50.f;
        sumW = 110.f;
    }
    else if (iPhone5||iPhone4||iPhone3GS)
    {
        fontSize = 30.f;
        sumW = 80.f;
        sumLabelX +=20;
    }
    sumLabel = [[UILabel alloc] initWithFrame:CGRectMake(sumLabelX, sumLabelY, sumW, 50)];
    sumLabel.textColor = RGB(99,177,249);
    sumLabel.font = [UIFont systemFontOfSize: fontSize];
    sumLabel.text = @"000";
    sumLabel.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:sumLabel];
    
    CGFloat labelW = 45.f;
    CGFloat labelfontSize = 20.f;
    CGFloat labelX = (headerViewWidth/2)+20;
    if (iPhone6p) {
        labelW = 60.f;
        labelX += 10;
    }
    else if (iPhone5||iPhone4||iPhone3GS)
    {
        labelfontSize = 17.f;
        labelW = 40.f;
        labelX -= 5;
    }
    UILabel* bmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, CGRectGetMinY(sumLabel.frame), labelW, 50)];
    bmpLabel.textColor = RGB(99,177,249);
    bmpLabel.font = [UIFont systemFontOfSize: labelfontSize];
    bmpLabel.text = @"BMP";
    bmpLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:bmpLabel];
    
    CGFloat  heartY = CGRectGetMaxY(sumLabel.frame)+5;
    if (iPhone5||iPhone4||iPhone3GS)
    {
        heartY -= 7;
    }
    _heartView = [[HeartView alloc]initWithFrame:CGRectMake((headerViewWidth-40)/2, heartY, 40, 40)];
    _heartView.lineWidth = 1;
    _heartView.strokeColor = RGB(99,177,249);
    _heartView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:_heartView];
    
    [self.view addSubview: self.refreshMoniterView];
    
    hudLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame)+40, MainScreenWidth, 40)];
    hudLabel.text = @"用手指将摄像头完全覆盖";
    hudLabel.textAlignment = NSTextAlignmentCenter;
    hudLabel.textColor = RGB(99,177,249);
    [self.view addSubview:hudLabel];
    
    CGFloat staetButtonH = 50;
    startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake(MainScreenWidth/3, CGRectGetMidY(_refreshMoniterView.frame)-staetButtonH/2, MainScreenWidth/3, staetButtonH);
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [startButton setTitle: @"开始测量" forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"btn"];
    [startButton setBackgroundImage: image forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startTestBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
}

- (void)getNetHeartRateRecord
{
    NSDictionary *dic = GET_PHYSICALRECOID;
    NSDictionary *resultDic = [dic objectForKey:@"result"];
    NSArray *array = [resultDic objectForKey:@"心率"];
    netHeartRateValue = [[array lastObject] integerValue];
}

#pragma mark -开关按钮
-(void)startTest:(UITapGestureRecognizer *)tap
{
    if ([coreCameraDetection cameraRunningStatus])
    {
        [self otherClose];
        [coreCameraDetection detectionStopRunning];
        [SVProgressHUD dismiss];
    }
}

- (void)startTestBtn:(id)sender
{
    if (![coreCameraDetection cameraRunningStatus]&&[KMTools getAuthStatus:self])
    {
        [TalkingData trackEvent:@"210000201" label:@"心率测量>开始测量"];
        _heartView.strokeColor = RGB(230,101, 96);
        [_heartView setNeedsDisplay];
        hudLabel.hidden = YES;
        startButton.hidden = YES;
        coreCameraDetection.timerCount = 15;
        self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(timerRefresnFun) userInfo:nil repeats:YES];
        [self.heartTimer fire];
        [_detectView begin];
        [coreCameraDetection detectionStartRunning];
    }
}

#pragma mark -
//定时执行方法
- (void)timerClose
{
    [self.heartTimer invalidate];
    self.heartTimer = nil;
}

-(void)otherClose
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _heartView.strokeColor = RGB(99,177,249);
        [_heartView setNeedsDisplay];
        [_detectView stop];
        hudLabel.hidden = NO;
        startButton.hidden = NO;
        [self clearLive];
    });
    [self timerClose];
}


#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化属性

- (HeartLive *)refreshMoniterView
{
    if (!_refreshMoniterView) {
        CGFloat heightOffset = 150;
        CGFloat yOffset = CGRectGetMaxY(headerView.frame)+(MainScreenHeight - CGRectGetMaxY(headerView.frame)-heightOffset)/2;
        _refreshMoniterView = [[HeartLive alloc] initWithFrame:CGRectMake(0, yOffset, CGRectGetWidth(self.view.frame), heightOffset)];
        _refreshMoniterView.backgroundColor = [UIColor clearColor];
    }
    return _refreshMoniterView;
}

#pragma mark - _refreshMoniterView DataSource
- (void)initRefresMoniterPoint
{
    xCoordinateInMoniter = 0;
}

- (void)clearLive
{
    [self initRefresMoniterPoint];
    [_refreshMoniterView stopDrawing];
    [points removeAllObjects];
}
//把心跳数值转换为坐标
- (CGPoint)bubbleRefreshPoint
{
    CGFloat liveHeight = CGRectGetHeight(_refreshMoniterView.frame);
    NSInteger pixelPerPoint = 2;
    if (![points count]) {
        return (CGPoint){xCoordinateInMoniter, liveHeight/2};
    }
    CGFloat pointY= [points[0]floatValue];
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
    xCoordinateInMoniter %= (int)(CGRectGetWidth(_refreshMoniterView.frame));
    return targetPointToAdd;
}

//刷新方式绘制
- (void)timerRefresnFun
{
    [[PointContainer sharedContainer] addPointAsRefreshChangeform:[self bubbleRefreshPoint]];
    [_refreshMoniterView fireDrawingWithPoints:[PointContainer sharedContainer].refreshPointContainer pointsCount:[PointContainer sharedContainer].numberOfRefreshElements];
}

#pragma mark - CoreCameraDetection Delegate
-(void)cameraDetection:(CoreCameraDetection *)cameraDetection didOutputSampleErrorCount:(NSUInteger)errorCount
{
    if (errorCount ==1) {
       [SVProgressHUD showErrorWithStatus: @"请将手指覆盖摄像头"];
    }
    else if(errorCount == 2)
    {
        [SVProgressHUD dismiss];
        [coreCameraDetection detectionStopRunning];
        [self otherClose];
    }
}

-(void)cameraDetection:(CoreCameraDetection* )cameraDetection didOutputSamplePassValue:(float)passValue
{
    if(!points)
        points = [NSMutableArray new];
    NSNumber * number = @(passValue*300);
    [points insertObject:number atIndex:0];
    while(points.count > 10)
        [points removeLastObject];

}

-(void)cameraDetection:(CoreCameraDetection* )cameraDetection didOutputSampleHeartCount:(NSUInteger)heartCount andTimerCount:(NSUInteger)timerCount
{
    NSInteger displayValue;
    if (netHeartRateValue > 5) {
        displayValue = [KMTools getRandomFrome:netHeartRateValue-5 to:netHeartRateValue+5];
    }
    else
    {
        displayValue  = heartCount;
    }
    sumLabel.text = [NSString stringWithFormat:@"%li",(long)displayValue];
    currntTimer = timerCount;
    if (timerCount >= cameraDetection.timerCount) {
        [cameraDetection closeDetectionTimer];
        [self otherClose];
        [self goResultVC:displayValue];
    }
}

- (void)goResultVC:(NSInteger)count
{
    if (coreCameraDetection.delegate == nil) {
        return;
    }
    UIStoryboard *sboard = [KMTools getStoryboardInstance];
    DetectioResultViewController *workGradeViewController = [sboard instantiateViewControllerWithIdentifier:@"DetectioResultViewController"];
    workGradeViewController.sumCount = count;
    [self.navigationController pushViewController:workGradeViewController animated:YES];
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
    NSString *firstEyeValue = [[NSUserDefaults standardUserDefaults] valueForKey:@"FirstGoHeartRate"];
    if ([firstEyeValue isEqualToString:@""])
    {
        onceHeartRateHelp = YES;
    }
}

- (void)setFisrtOpenValue
{
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"FirstGoHeartRate"];
    onceHeartRateHelp = YES;
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
