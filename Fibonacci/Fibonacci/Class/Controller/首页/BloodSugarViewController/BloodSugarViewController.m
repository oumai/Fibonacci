//
//  BloodSugarViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/12/13.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "BloodSugarViewController.h"
#import "BloodSugarSpreadView.h"
#import "AddBloodSugarViewController.h"
#import "AddInsulinViewController.h"
#import "InsulinRecordViewController.h"
#import "WXWaveView.h"
#import "BloodSugarDataModel.h"
#import "TimedReminderViewController.h"

@interface BloodSugarViewController ()
@property(nonatomic,strong)UILabel *hudLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *valueLabel;
@property(nonatomic,strong)UILabel *unitLabel;
@property(nonatomic,strong)UIButton *recordButton;
@property(nonatomic,strong)UIButton *insulinButton;
@property(nonatomic,assign)BOOL todayHaveData;
@property(nonatomic,assign)BloodSugarDataModel * model;
@end

@implementation BloodSugarViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [animationTimer invalidate];
    animationTimer = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [animationTimer invalidate];
    animationTimer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"血糖录入";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataViewAndData:)
                                                 name:@"AddBloodSugar"
                                               object:nil];
    [self addRightButton:@selector(remindAciton) image:[UIImage imageNamed:@"remind"]];


    [self getTodayData];
    [self pagesLayout];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    animationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(spreadAnimation) userInfo:nil repeats:YES];
    NSString *FirstGoBloodSugarValue = [[NSUserDefaults standardUserDefaults] valueForKey:@"FirstGoBloodSugar"];
    if (FirstGoBloodSugarValue.length == 0)
    {
        [self fristOpenVC];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pagesLayout
{
    CGFloat minY = 0;
    if (self.navigationController.navigationBar.translucent&&!self.extendedLayoutIncludesOpaqueBars) {
        minY = kStatusAndNavHeight;
    }
    WEAK_SELF(self);
    CGFloat waterW = MainScreenWidth/3;
    BloodSugarSpreadView *waterView = [[BloodSugarSpreadView alloc]initWithFrame:CGRectMake(0, 0, waterW, waterW) status:colorType];
    waterView.backgroundColor = [UIColor clearColor];
    waterView.tag = 1001;
    [self.view addSubview:waterView];
    [waterView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(80+minY);
        make.height.mas_equalTo(waterW);
        make.width.mas_equalTo(waterW);
    }];
    
    [self.view addSubview:self.hudLabel];
    [self.hudLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(waterView.mas_bottom).offset(20);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(MainScreenWidth);
    }];
    
    CGFloat waveY = 80+minY+waterW+20+35+15; //上面两个view的总和
    WXWaveView *topWaveView = [WXWaveView addToView:self.view withFrame:CGRectMake(0, waveY, MainScreenWidth,  MainScreenHeight-waveY)];
    topWaveView.tag = 10086;

    self.timeLabel.frame = CGRectMake((MainScreenWidth-80)/2, CGRectGetMinY(topWaveView.frame)+20, 80, 23);
    [self.view addSubview:self.timeLabel];
    
    self.valueLabel.frame = CGRectMake((MainScreenWidth-150)/2, CGRectGetMaxY(self.timeLabel.frame), 150, 45);
    [self.view addSubview:self.valueLabel];

    self.unitLabel.frame = CGRectMake((MainScreenWidth-60)/2, CGRectGetMaxY(self.valueLabel.frame), 60, 18);
    [self.view addSubview:self.unitLabel];
    
    __block CGFloat insulinBottomOffset = -130.0;
    __block CGFloat recordBottomOffset = -50.0;
    if (iPhone5) {
        insulinBottomOffset = -60.0;
        recordBottomOffset = -10.0;
    }
    [self.view addSubview:self.insulinButton];
    [self.insulinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(insulinBottomOffset);
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(80);
    }];
    
    [self.view addSubview:self.recordButton];
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(recordBottomOffset);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(80);
    }];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake((MainScreenWidth-waterW)/2, 80+minY, waterW, waterW)];
    view.alpha = 1;
    view.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *maskGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goAddBloodSugar)];
    [view addGestureRecognizer:maskGesture];
    [self.view addSubview:view];
    
    if (_todayHaveData)
    {
        topWaveView.waveColor = mainColor;
        topWaveView.viewType = 2;
        [topWaveView wave];
    }
    else
    {
        topWaveView.viewType = 2;
    }
//    [self.view sendSubviewToBack:topWaveView];
    for (UIImageView *elem in self.view.subviews) {
        if (elem.tag == 2018007) {
            [self.view insertSubview:topWaveView aboveSubview:elem];
        }
    }
}

#pragma mark - setter && getter
- (UILabel *)hudLabel {
    if (!_hudLabel) {
        _hudLabel = [[UILabel alloc] init];
        _hudLabel.text = _todayHaveData?@"":@"请添加您的血糖记录";
        _hudLabel.font = [UIFont fontWithName:AppFontHelvetica size:15];
        _hudLabel.textColor = AppFontColor;
        _hudLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _hudLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont fontWithName:AppFontHelvetica size:15];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.text = _todayHaveData?@"":@"";
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = [UIFont fontWithName:AppFontHelvetica size:45];
        _valueLabel.textColor = [UIColor whiteColor];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _valueLabel;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.text = _todayHaveData? @"mmol/L":@"";
        _unitLabel.font = [UIFont fontWithName:AppFontHelvetica size:15];
        _unitLabel.textColor = [UIColor whiteColor];
        _unitLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _unitLabel;
}

- (UIButton *)recordButton
{
    if (!_recordButton) {
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordButton setTitle:@"历史记录" forState:UIControlStateNormal];
//        [_recordButton setTitleColor:_todayHaveData?[UIColor whiteColor]:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_recordButton setTitleEdgeInsets:UIEdgeInsetsMake(10, -15, 0, 0)];
        [_recordButton setImage:[UIImage imageNamed:@"arrows_white"] forState:UIControlStateNormal];
        [_recordButton setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 25, 0)];
        _recordButton.titleLabel.font = [UIFont fontWithName:AppFontHelvetica size:16];
        [_recordButton addTarget:self action:@selector(goRecord) forControlEvents:UIControlEventTouchUpInside];
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [_recordButton addGestureRecognizer:recognizer];
        [_recordButton sizeToFit];
    }
    return _recordButton;
}

- (UIButton *)insulinButton
{
    if (!_insulinButton) {
        _insulinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_insulinButton setImage:[UIImage imageNamed:_todayHaveData?@"insulin_white":@"insulin_blue"] forState:UIControlStateNormal];
        [_insulinButton setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 25, 0)];
        [_insulinButton setTitleColor:_todayHaveData?[UIColor whiteColor]:AppFontColor forState:UIControlStateNormal];
        [_insulinButton setTitle:@"胰岛素" forState:UIControlStateNormal];
        [_insulinButton setTitleEdgeInsets:UIEdgeInsetsMake(60, -50, 0, 0)];
        _insulinButton.titleLabel.font = [UIFont fontWithName:AppFontHelvetica size:16];
        [_insulinButton addTarget:self action:@selector(goInsulin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _insulinButton;
}

- (void)switchWaveColor
{
    WXWaveView *topWaveView = [(WXWaveView *)self.view viewWithTag:10086];
    topWaveView.waveColor = RGB(255, 98, 155);
}

#pragma mark 读取数据
- (void)getTodayData
{
    NSArray *array = [[KMDataManager sharedDatabaseInstance] getBloodSugarDataModels:EDataTimePeriodStatusDay forDate:nil];
    if ([array count] > 0)
    {
        _todayHaveData = YES;
        NSArray *newArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSTimeInterval objInterval1;
            NSTimeInterval objInterval2;
            BloodSugarDataModel * model = (BloodSugarDataModel *)obj1;
            objInterval1 = [model.timeInterval doubleValue];
            
            BloodSugarDataModel * model2 = (BloodSugarDataModel *)obj2;
            objInterval2 = [model2.timeInterval doubleValue];
            if (objInterval2 > objInterval1)
            {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];
        _model = nil;
        _model = newArray[0];
        NSInteger type = [_model.timeScale integerValue];
        CGFloat value = _model.value_id.doubleValue;
        NSArray *segmentTitleArray = @[@"早餐前",@"早餐后",@"午餐前",@"午餐后",@"晚餐前",@"晚餐后", @"睡前", @"凌晨", @"随机"];
        if (type > 9 )
        {
            self.timeLabel.text = segmentTitleArray[8];
        }
        else if (type > 0 )
        {
            self.timeLabel.text = segmentTitleArray[type-1];
        }
        else
        {
            self.timeLabel.text = segmentTitleArray[type];
        }
        self.valueLabel.text = [NSString stringWithFormat:@"%.1f",value];
        if (value > 4.5)
        {
            mainColor = RGB(38, 208, 254);
            colorType = 0;
        }
        else
        {
            mainColor = RGB(253, 80, 137);
            colorType = 1;
        }
        if (type == 1 || type == 3 ||type == 5)
        {
            if (value >= 7.0)
            {
                mainColor = RGB(253, 175, 83);
                colorType = 2;
            }
        }
        else
        {
            if (value >= 10.0)
            {
                mainColor = RGB(253, 175, 83);
                colorType = 2;
            }
        }
    }
    else
    {
        _todayHaveData = NO;
    }
    
}

-(void)updataViewAndData:(NSNotification *)obj
{
    [self getTodayData];
    BloodSugarSpreadView * waterView = [(BloodSugarSpreadView *)self.view viewWithTag:1001];
    waterView.type = colorType;
    [_insulinButton setImage:[UIImage imageNamed:_todayHaveData?@"insulin_white":@"insulin_blue"] forState:UIControlStateNormal];
//    [_recordButton setImage:[UIImage imageNamed: @"arrows_white"] forState:UIControlStateNormal];
//    [_recordButton setTitleColor:_todayHaveData?[UIColor whiteColor]:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_insulinButton setTitleColor:_todayHaveData?[UIColor whiteColor]:AppColor forState:UIControlStateNormal];
    _hudLabel.text = _todayHaveData?@"":@"请添加您的血糖记录";
    WXWaveView *topWaveView = [(WXWaveView *)self.view viewWithTag:10086];
    topWaveView.waveColor = mainColor;
    [topWaveView wave];

}

#pragma mark - Animation
- (void)spreadAnimation
{
    BloodSugarSpreadView * waterView = [(BloodSugarSpreadView *)self.view viewWithTag:1001];
    
    [UIView animateWithDuration:0.95 animations:^{
        waterView.maskView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.4, 1.4);
        waterView.maskView.alpha = 0.f;
    }completion:^(BOOL finished)
     {
         waterView.maskView.transform = CGAffineTransformIdentity;
         waterView.maskView.alpha = 1.f;
     }];
}

#pragma mark - Action
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
        [self goRecord];
    }
}
- (void)goAddBloodSugar
{
    UIStoryboard *sboard = [KMTools getStoryboardInstance];
    AddBloodSugarViewController *bloodSugarViewController = [sboard instantiateViewControllerWithIdentifier:@"AddBloodSugarViewController"];
    [self.navigationController pushViewController:bloodSugarViewController animated:YES];
}

- (void)goRecord
{
    CATransition* transition = [CATransition animation];
    transition.duration =0.3f;
    transition.type =kCATransitionMoveIn;
    transition.subtype =kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    UIStoryboard *sboard = [KMTools getStoryboardInstance];
    InsulinRecordViewController *bloodSugarViewController = [sboard instantiateViewControllerWithIdentifier:@"InsulinRecordViewController"];
    [self.navigationController pushViewController:bloodSugarViewController animated:NO];
}

- (void)goInsulin
{
    UIStoryboard *sboard = [KMTools getStoryboardInstance];
    AddInsulinViewController *bloodSugarViewController = [sboard instantiateViewControllerWithIdentifier:@"AddInsulinViewController"];
    [self.navigationController pushViewController:bloodSugarViewController animated:YES];
}

- (void)remindAciton
{
    UIStoryboard *sboard = [KMTools getStoryboardInstance];
    TimedReminderViewController *bloodSugarViewController = [sboard instantiateViewControllerWithIdentifier:@"TimedReminderViewController"];
    [self.navigationController pushViewController:bloodSugarViewController animated:YES];
}

#pragma mark - fristOpenVC
-(void)fristOpenVC
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *maskview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    maskview.backgroundColor = RGBA(0, 0, 0, 0.5);
    maskview.tag = 3000;
    [window addSubview:maskview];
    
    CGFloat labelHeight = 40;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth-labelHeight-10, kStatusBarHeight + 2, labelHeight, labelHeight)];
    view.layer.cornerRadius = labelHeight/2;
    view.backgroundColor = RGBA(255, 255, 255, 1);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, labelHeight, labelHeight)];
    imageView.image = [UIImage imageNamed:@"remind"];
    imageView.contentMode = UIViewContentModeCenter;
    [view addSubview:imageView];
    
    [maskview addSubview:view];
    
    UIImageView *arrowBG = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth-132-10, 20+ labelHeight, 132, 83)];
    arrowBG.image = [UIImage imageNamed:@"remindguide"];
    [maskview addSubview:arrowBG];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissMask:)];
    [maskview addGestureRecognizer:tapGesture];
}

-(void)fristOpenVC2
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *maskview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    maskview.backgroundColor = RGBA(0, 0, 0, 0.5);
    maskview.tag = 3000;
    [window addSubview:maskview];

    CGFloat waterW = MainScreenWidth/3+10;
    BloodSugarSpreadView *waterView = [[BloodSugarSpreadView alloc]initWithFrame:CGRectMake((MainScreenWidth-waterW)/2, kStatusAndNavHeight+80, waterW, waterW) status:colorType];
    waterView.backgroundColor = [UIColor clearColor];
    waterView.tag = 1001;
    [maskview addSubview:waterView];
    
    UIImageView *arrowBG = [[UIImageView alloc] initWithFrame:CGRectMake((MainScreenWidth-93)/2, CGRectGetMidY(waterView.frame), 93, 159)];
    arrowBG.image = [UIImage imageNamed:@"clickguide"];
    [maskview addSubview:arrowBG];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissMask2:)];
    [maskview addGestureRecognizer:tapGesture];
}


- (void)dismissMask:(id)sender
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (UIView *elem in window.subviews) {
        if (elem.tag == 3000) {
            [UIView animateWithDuration:0.3
                             animations:^(void) {
                                 elem.alpha = 0.f;
                             } completion:^(BOOL completed) {
                                 while ([elem.subviews lastObject] != nil) {
                                     [(UIView*)[elem.subviews lastObject] removeFromSuperview];
                                 }
                                 [elem removeFromSuperview];
                                 [self fristOpenVC2];
                             }];
        }
    }
}

- (void)dismissMask2:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"FirstGoBloodSugar"];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (UIView *elem in window.subviews) {
        if (elem.tag == 3000) {
            [UIView animateWithDuration:0.3
                             animations:^(void) {
                                 elem.alpha = 0.f;
                             } completion:^(BOOL completed) {
                                 while ([elem.subviews lastObject] != nil) {
                                     [(UIView*)[elem.subviews lastObject] removeFromSuperview];
                                 }
                                 [elem removeFromSuperview];
                             }];
        }
    }
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
