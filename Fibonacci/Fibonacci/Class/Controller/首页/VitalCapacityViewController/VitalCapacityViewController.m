//
//  VitalCapacityViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/18.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "VitalCapacityViewController.h"
#import "VitalCapacityResultViewController.h"
#import "HeartLive.h"
#import "MeteorView.h"

#import "RobotView.h"

@interface VitalCapacityViewController ()
{
    CGFloat _downRect;
    CGFloat _robotTopRect;
    NSInteger demp;
    CABasicAnimation * upAni;
    CABasicAnimation * downAni;
}

//机器人
@property (nonatomic,strong) RobotView *robotview;
@property (nonatomic,assign) BOOL isStop ;//停止飞翔
@property (nonatomic,assign) BOOL isFirst ;//计时器添加一次
@property (nonatomic,strong) NSMutableArray *countArray;
@property (nonatomic,strong) UIImageView *maskView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) CGFloat moveCount;



//开始测量
@property (nonatomic,strong) UIButton *testButton;

@property (strong, nonatomic)MeteorView *meteorView;

@end

@implementation VitalCapacityViewController


- (void)dealloc
{
    [self.timer invalidate];
    liveHeart = nil;
    [audioTimer invalidate];
    audioTimer = nil;
    [listener stop];
    [listener destorySingletion];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"肺活量测量";
    
    [self initControllerViewAndData];
    self.countArray = [NSMutableArray arrayWithCapacity:0];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //重置位置
    [self reRectFrame];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    isGoResult = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [audioTimer invalidate];
    audioTimer = nil;
    [listener pause];
    [self clearLive];
}

-(void)reRectFrame{
    
    [self.countArray removeAllObjects];
    self.testButton.hidden = NO;
    self.isStop = NO;
    self.isFirst = YES;
    markValue = 0;
    lastValue = 0;
    valueLabel.text = @"深吸一口气后,对准手机下端麦克风吹气";
    
    self.moveCount = 0;
    [self.timer invalidate];
    self.scrollView.contentOffset= CGPointMake(0,MainScreenHeight * 4);
    
    [self.robotview.layer removeAnimationForKey:@"positionDown"];
    [self.robotview.layer removeAnimationForKey:@"positionUp"];
    self.robotview.frame = CGRectMake(self.view.frame.size.width/2-75/2.0, _robotTopRect, 75, 100);
    self.robotview.emitterView.alpha = 0;
    [self.robotview drawRect];
    
}

- (void)initControllerViewAndData
{
    
   
    listener = [SCListener sharedListener];
    
    self.isStop = NO;
    self.moveCount = 1;
    self.isFirst = YES;
    
    if (iPhone5) {
        _robotTopRect = 200;
        _downRect = 300;
    }else if (iPhone6){
        _robotTopRect = 300;
        _downRect = 300;
    }else{
        _robotTopRect = 300;
        _downRect = 350;
    }
    
    self.scrollView =  [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight); // frame中的size指UIScrollView的可视范围
    self.scrollView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight * 5);
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    self.scrollView.bounces = NO;
    self.scrollView.scrollsToTop = YES;
    self.scrollView.contentOffset= CGPointMake(0,MainScreenHeight * 4);
    [self.view addSubview:self.scrollView];
    
    // 2.创建背景图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"background"];
    imageView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight * 5);
    [self.scrollView addSubview:imageView];
    
    self.maskView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    self.maskView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.maskView];

    
    //下雨
    [self.view addSubview:self.meteorView];
    
    [self initRefresMoniterPoint];
    CGFloat staetButtonH = 50;
    liveHeart = [[HeartLive alloc] initWithFrame:CGRectMake(0, MainScreenHeight-200, MainScreenWidth, 50)];
    liveHeart.backgroundColor = [UIColor clearColor];
    liveHeart.hidden = YES;
    [self.view addSubview: liveHeart];
    
    
    
    valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, startButton.frame.origin.y - 90, MainScreenWidth - 60, 100)];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    valueLabel.text = @"深吸一口气后,对准手机下端麦克风吹气";
    valueLabel.font = [UIFont fontWithName:@"Avenir-Light" size:15];
    valueLabel.textColor = UIColorFromHEX(0x42b3ff, 1);
    [self.view addSubview:valueLabel];
    

    
    startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake((MainScreenWidth - 150)/2.0, CGRectGetMidY(liveHeart.frame)-staetButtonH/2, 150, staetButtonH);
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [startButton setTitle: @"开始测量" forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startVitalCapacityTestBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];

    
    //机器人
    self.robotview = [[RobotView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 75/2.0, _robotTopRect, 75, 100)];
    [self.view addSubview:self.robotview];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -动画

- (void)judgeVitalCapacity:(CGFloat)average
{
    
    if (average > 0.08){
        NSLog(@">>>>>>%f ",average);
    }else{
        NSLog(@"=====%f ",average);
    }
    
    NSNumber *num = [NSNumber numberWithFloat:average];
    if(self.countArray.count < 10){
        //没有10个大于0.05的不起飞
        [self.countArray addObject:num];
    }else{
        for (int i=0; i<10; i++) {
            if ([self.countArray[i] floatValue] > 0.08 ) {
                //有效值
                demp = demp + 1;
                NSLog(@"==========%ld==========",(long)demp);
            }
            
            if (i == 9) {
                [self.countArray removeObjectAtIndex:0];
                [self .countArray addObject:num];
            }
        }
        
        if(demp > 8){
            //连续7个大于0.05算吹气
            [self prepareRobotFly];
            
            markValue +=average*40;
            
            self.isStop = NO;
            
            NSLog(@"self.countArray==========%@",self.countArray);
        }
        
        if (self.isStop == NO) {
            if (demp < 5) {
                self.isStop = YES;
                [self downRobot];
            }
        }
        demp = 0;
    }
    
    //保存每次的值，用于比较
    lastValue = average;
    
    if (markValue >= 800 && lastValue<0.08)
    {
        
        UIStoryboard *sboard = [KMTools getStoryboardInstance];
        VitalCapacityResultViewController *vitalCapacityResultViewController = [sboard instantiateViewControllerWithIdentifier:@"VitalCapacityResultViewController"];
        vitalCapacityResultViewController.markValue = markValue;
        [self.navigationController pushViewController:vitalCapacityResultViewController animated:YES];
        
        [self startVitalCapacityTestBtn:nil];
        isGoResult = YES;
        return;
    }
    
}

#pragma mark -
-(void)startVitalCapacityTestBtn:(UIButton *)button
{
    startButton.hidden = YES;
//    [self downRobot];
    
    if (![listener isListening]) {
        [_meteorView addRainningEffect];
         [listener listen];
        audioTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(valueTimer:) userInfo:nil repeats:YES];
        [audioTimer fire];
        liveHeart.hidden = NO;
        [TalkingData trackEvent:@"210000601" label:@"肺活量测量>开始测量"];
    }
    else
    {
        
        [_meteorView stop];
        [listener pause];
        [audioTimer invalidate];
        audioTimer = nil;
        [self clearLive];
        liveHeart.hidden = YES;
        startButton.hidden = NO;
    }
}

//背景移动
- (void)bgImageViewMove{
    self.timer = [NSTimer timerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [UIView animateWithDuration:0 animations:^{
            self.scrollView.contentOffset= CGPointMake(0,MainScreenHeight * 4 - self.moveCount);
        }completion:^(BOOL finished) {
            self.moveCount = self.moveCount + 1.5;
        }];
        
    }];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

//下降机器人
- (void)downRobot{

    //影藏按钮、火焰、下降机器人
    [UIView animateWithDuration:0.25 animations:^{
        
        self.robotview.emitterView.alpha = 0;
        [self downAniation];
//        self.robotview.frame = CGRectMake(self.robotview.frame.origin.x, _robotTopRect + _downRect, self.robotview.frame.size.width, self.robotview.frame.size.height);
        
        if(!self.isFirst){
            self.moveCount = 1;
            [self.timer invalidate];
            self.scrollView.contentOffset= CGPointMake(0,MainScreenHeight * 4);
            self.isFirst = YES;
            valueLabel.text = @"不要停，继续吹 (๑•ㅂ•)و✧";
        }
    } completion:^(BOOL finished) {
        
    }];
}

//上升机器人
- (void)prepareRobotFly{
    
    if(self.isFirst){
        //只添加一次
        [self bgImageViewMove];
        [self upAniation];
        [UIView animateWithDuration:0.25 animations:^{
            valueLabel.text = @"不要停，继续吹 (๑•ㅂ•)و✧";
            self.robotview.emitterView.alpha = 1;
            //        self.robotview.frame = CGRectMake(self.robotview.frame.origin.x, _robotTopRect, self.robotview.frame.size.width, self.robotview.frame.size.height);
            //          [self upAniation];
        } completion:^(BOOL finished) {
            
        }];
        self.isFirst = NO;
    }
}

//上升
- (void)upAniation{
    [self.robotview.layer removeAnimationForKey:@"positionDown"];
    upAni = [CABasicAnimation animationWithKeyPath:@"position"];
    upAni.toValue = [NSValue valueWithCGPoint:CGPointMake(MainScreenWidth/2.0,_robotTopRect)];
    upAni.fromValue = [NSValue valueWithCGPoint:CGPointMake(MainScreenWidth/2.0,_robotTopRect + _downRect)];
    upAni.removedOnCompletion = NO;
    upAni.duration = 1;
    upAni.fillMode = kCAFillModeForwards;
    upAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.robotview.layer addAnimation:upAni forKey:@"positionUp"];
}

//下降
- (void)downAniation{
    [self.robotview.layer removeAnimationForKey:@"positionUp"];
    downAni = [CABasicAnimation animationWithKeyPath:@"position"];
    downAni.toValue = [NSValue valueWithCGPoint:CGPointMake(MainScreenWidth/2.0,_robotTopRect + _downRect)];
    downAni.duration= 1;
    downAni.removedOnCompletion = NO;
    downAni.fillMode = kCAFillModeForwards;
    downAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.robotview.layer addAnimation:downAni forKey:@"positionDown"];
}

#pragma mark - 定时器
- (void)valueTimer:(NSTimer *)timer
{
    if (![listener isListening]) // If listener has paused or stopped…
    {
        [listener listen];
    }
    AudioQueueLevelMeterState *levels = [listener levels];
    Float32 average = levels[0].mAveragePower;

    [self timerTranslationFun];
    if(!vitalCapacityArray)
        vitalCapacityArray = [NSMutableArray new];
    NSNumber * number = @(average*35);
    [vitalCapacityArray insertObject:number atIndex:0];
    while(vitalCapacityArray.count >2)
        [vitalCapacityArray removeLastObject];
    [_meteorView speed:average];
    [self judgeVitalCapacity:average];
}

#pragma mark -
- (void)clearLive
{
    [self initRefresMoniterPoint];
    [liveHeart stopDrawing];
    [vitalCapacityArray removeAllObjects];
}

- (void)initRefresMoniterPoint
{
    xCoordinateInMoniter = 0;
}

- (void)timerTranslationFun
{
    [[PointContainer sharedContainer] addPointAsTranslationChangeform:[self bubbleRefreshPoint:YES]];
    [[PointContainer sharedContainer] addPointAsTranslationChangeform:[self bubbleRefreshPoint:NO]];
    [liveHeart fireDrawingWithPoints:[PointContainer sharedContainer].translationPointContainer pointsCount:[PointContainer sharedContainer].numberOfTranslationElements];
}

- (CGPoint)bubbleRefreshPoint:(BOOL)yesOrNo
{
    if ([vitalCapacityArray count] == 0) {
        return  (CGPoint){xCoordinateInMoniter,50};
    }
    NSInteger pixelPerPoint = 1;
    NSInteger yCoordinateInMoniter = 50-[vitalCapacityArray[0] integerValue];
    yCoordinateInMoniter = yCoordinateInMoniter>50?20:yCoordinateInMoniter;
    CGPoint targetPointToAdd = (CGPoint){xCoordinateInMoniter,yesOrNo?yCoordinateInMoniter:50};
    xCoordinateInMoniter += pixelPerPoint;
    xCoordinateInMoniter %= (int)(CGRectGetWidth(liveHeart.frame));
    return targetPointToAdd;
}

#pragma mark -
- (MeteorView *)meteorView
{
    if (!_meteorView) {
        _meteorView = [[MeteorView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight*0.7)];
        _meteorView.layer.masksToBounds = YES;
    }
    return _meteorView;
}
@end
