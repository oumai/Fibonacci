//
//  ViewController.m
//  NewPagedFlowViewDemo
//
//  Copyright © 2016年 Mars. All rights reserved.
//  Designed By PageGuo,
//  QQ:799573715
//  github:https://github.com/PageGuo/NewPagedFlowView

#import "NewViewController.h"

//vc
#import "HeartRateDetectioViewController.h"
#import "BloodPressureDetectioViewController.h"
#import "EyeTestViewController.h"
#import "VitalCapacityViewController.h"
#import "BloodOxygenViewController.h"
#import "HealthStepViewController.h"
#import "BloodSugarViewController.h"
#import "BodyDataViewController.h"
#import "BATLoginViewController.h"
#import "SettingViewController.h"
#import "DetailViewController.h"

//view
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "BATShowResultView.h"
#import "BATMenuView.h"
#import "ShapeView.h"

#import "BATPerson.h"
#import "HeartChartViewController.h"

//model
#import "BloodOxygenDataModel.h"
#import "BloodPressureDataModel.h"
#import "VisionDataModel.h"
#import "BloodSugarDataModel.h"
#import "HeartRateDataModel.h"
#import "VitalCapacityDataModel.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface NewViewController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>

@property (nonatomic,strong) UIStoryboard *sboard;

// 三条线
@property (nonatomic,strong)  ShapeView  *pathShapeView1;
@property (nonatomic,strong)  ShapeView  *pathShapeView2;
@property (nonatomic,strong)  ShapeView  *pathShapeView3;

@property (nonatomic,assign) CGSize size;
@property (nonatomic,assign) CGFloat offsetX;
@property (nonatomic,assign) CGFloat offsetSizeWidth;
@property (nonatomic,assign) CGFloat scrollViewHeight;

//默认图片数组
@property (nonatomic,strong) NSArray *imageNomelArr;
//选中图片数组
@property (nonatomic,strong) NSArray *imageSlectArr;
//文字数字
@property (nonatomic,strong) NSArray *titleArr;

//背景
@property (nonatomic,strong) UIImageView *bgImageView;
//滚动视图
@property (nonatomic,strong) NewPagedFlowView *pageFlowView;

//大图数组
@property (nonatomic, strong) NSMutableArray *imageArray;

//当前左侧选中项
@property (nonatomic,assign) NSInteger currentIndex;
//指标选中项
@property (nonatomic,assign) NSInteger currentClickIndex;

//血氧、血氧等文字和图片
@property (nonatomic,strong) UILabel *topLable;
@property (nonatomic,strong) UILabel *midLable;
@property (nonatomic,strong) UILabel *bottomLable;
@property (nonatomic,strong) UIImageView *topImageView;
@property (nonatomic,strong) UIImageView *midImageView;
@property (nonatomic,strong) UIImageView *botImageView;

//上下点击滚动区域
@property (nonatomic,strong) UIView *upView;
@property (nonatomic,strong) UIView *midView;
@property (nonatomic,strong) UIView *downView;

//上下箭头
@property (nonatomic,strong) UIImageView *upImageView;
@property (nonatomic,strong) UIImageView *downImageView;

//标题
@property (nonatomic,strong) UILabel *titleLable;

//弹框
@property (nonatomic,strong) BATShowResultView *showResultView;

//登入注册
@property (nonatomic,strong) BATMenuView *menuView;
@property (nonatomic,strong) UIButton *loginAndRegisterBtn;


@end

@implementation NewViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataUserState)
                                                 name:@"UPDATA_LOGIN_STATION"
                                               object:nil];
    
    self.sboard = [KMTools getStoryboardInstance];;
    if (iPhone5) {
        self.size = CGSizeMake(Width/450*250, Height/800*180);
        self.offsetX = 20;
        self.offsetSizeWidth = 10;
    }else if (iPhone6){
        self.size = CGSizeMake(Width/450*250, Height/800*180);
        self.offsetX = 8;
        self.offsetSizeWidth = 10;
    }else if (iPhone6p){
        self.size = CGSizeMake(Width/450*250, Height/800*180);
        self.offsetX = 0;
        self.offsetSizeWidth = 0;
    }else{
        //x
        self.size = CGSizeMake(Width/450*260, Height/800*180);
        self.offsetX = 13;
        self.offsetSizeWidth = 0;
    }
    
    //头、腿、腹部排列---》//腹部、腿、头排列
    self.imageNomelArr = @[@[@"iconb2_01",@"iconb2_02",@"iconb2_03"],@[@"iconb3_01",@"iconb3_02"],@[@"iconb1_01",@"iconb1_02",@"iconb1_03"]];
    self.imageSlectArr = @[@[@"icony2_01",@"icony2_02",@"icony2_03"],@[@"icony3_01",@"icony3_02"],@[@"icony1_01",@"icony1_02",@"icony1_03"]];
    self.titleArr = @[@[@"血压量测",@"心率量测",@"肺活量"],@[@"计步",@"体脂"],@[@"血氧",@"视力",@"血糖"]];
    
    //暂时用这个当时遮盖下那个问题，后面处理
    //    for (int i = 0; i < 10; i++) {
    for (int index = 0; index < 3; index++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Yosemite%02d",index]];
        [self.imageArray addObject:image];
    }
    //    }
    
    //默认从0开始,0标识腹部，3条线；1表示腿，2条线；2表示头部，3条线
    self.currentIndex = 0;
    
    [self layoutPages];
    
    [self creatThreeLine];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self satrtadsAnimationWithLintCount:self.currentIndex];
    });
    
    [self updataUserState];
}

#pragma mark - layoutPages
- (void)layoutPages{
    
    WEAK_SELF(self);
    //背景
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(-65, 134, Width, [UIScreen mainScreen].bounds.size.height - 204 - 10)];
    self.pageFlowView.delegate = self;
    self.pageFlowView.dataSource = self;
    self.pageFlowView.minimumPageAlpha = 0.1;
    //是否循环
    self.pageFlowView.isCarousel = YES;
    //滚动方向
    self.pageFlowView.orientation = NewPagedFlowViewOrientationVertical;
    //自动滚动
    self.pageFlowView.isOpenAutoScroll = NO;
    
    [self.pageFlowView setScrollViewWillStopDraggingBlock:^{
        STRONG_SELF(self);
        //结束滚动后，禁止滑动，开始引线动画
        self.topImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageNomelArr[self.currentIndex][0]]];
        self.midImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.currentIndex==1?@"":self.imageNomelArr[self.currentIndex][1]]];
        self.botImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.currentIndex==1?self.imageNomelArr[self.currentIndex][1]:self.imageNomelArr[self.currentIndex][2]]];
        [self satrtadsAnimationWithLintCount:self.currentIndex];
        
    }];
    
    self.scrollViewHeight = [UIScreen mainScreen].bounds.size.height - 204;
    
    [self.pageFlowView setScrollViewWillBeganDraggingBlock:^{
        STRONG_SELF(self);
        //开始滑动，移除动画
        [self removeLayer];
    }];
    
    [self.view addSubview:self.pageFlowView];
    [self.pageFlowView reloadData];
    
    [self.view addSubview:self.upView];
    [self.view addSubview:self.midView];
    [self.view addSubview:self.downView];
    [self.view addSubview:self.topImageView];
    [self.view addSubview:self.topLable];
    [self.view addSubview:self.midLable];
    [self.view addSubview:self.midImageView];
    [self.view addSubview:self.bottomLable];
    [self.view addSubview:self.botImageView];
    [self.view addSubview:self.titleLable];
    [self.view addSubview:self.upImageView];
    [self.view addSubview:self.downImageView];
    [self.view addSubview:self.loginAndRegisterBtn];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.view.mas_top).offset(35);
    }];
    
    [self.upImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.bottom.equalTo(self.pageFlowView.mas_top).offset(-10);
    }];
    
    [self.downImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.pageFlowView.mas_bottom).offset(10);
    }];
    
    [self.loginAndRegisterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.view.mas_top).offset(40);
        make.width.mas_offset(30);
        make.height.mas_offset(25);
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.menuView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.showResultView];
    
    
}

#pragma mark - NSNotificationCenter
- (void)updataUserState
{
    if (LOGIN_STATION == NO)
    {
        [_menuView.loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        _menuView.loginBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    }
    else
    {
        BATPerson *person = PERSON_INFO;
        [_menuView.loginBtn setTitle:person.Data.UserName forState:UIControlStateNormal];
        CGFloat fontSize = 14;
        NSUInteger length = 5;
        if(person.Data.UserName.length > length)
        {
            fontSize -= (person.Data.UserName.length - length + 1);
        }
        _menuView.loginBtn.titleLabel.font=[UIFont systemFontOfSize:fontSize];
    }
}

#pragma mark - action
//影藏测评结果页
- (void)hiddenResultView{
    self.showResultView.hidden = YES;
    [self.showResultView.timer invalidate];
}

//显示测评结果页
- (void)reShowResultView{
    self.showResultView.hidden = NO;
    [self.showResultView creatTimer];
    [self.showResultView reloadData];
}

//血氧跳转
- (void)goBloodOxygenVC{
    [TalkingData trackEvent:@"2100007" label:@"首页>血氧测试"];
    BloodOxygenViewController *bloodOxygenView = [self.sboard instantiateViewControllerWithIdentifier:@"BloodOxygenViewController"];
    [self.navigationController pushViewController:bloodOxygenView animated:YES];
}

//视力跳转
- (void)goEyeTestVC{
    [TalkingData trackEvent:@"2100005" label:@"首页>视力测试"];
    EyeTestViewController *eyeTestViewController = [self.sboard instantiateViewControllerWithIdentifier:@"EyeTestViewController"];
    [self.navigationController pushViewController:eyeTestViewController animated:YES];
}

//血糖跳转
- (void)goBloodSugarVC{
    BloodSugarViewController *bloodSugarViewController = [self.sboard instantiateViewControllerWithIdentifier:@"BloodSugarViewController"];
    [self.navigationController pushViewController:bloodSugarViewController animated:YES];
}

//计步跳转
- (void)goHealthStepVC{
    HealthStepViewController *workGradeViewController = [self.sboard instantiateViewControllerWithIdentifier:@"HealthStepViewController"];
    [self.navigationController pushViewController:workGradeViewController animated:YES];
}

//体脂跳转
- (void)goBodyDataVC{
    BodyDataViewController *bloodOxygenView = [self.sboard instantiateViewControllerWithIdentifier:@"BodyDataViewController"];
    [self.navigationController pushViewController:bloodOxygenView animated:YES];
}

//血压跳转
- (void)goBloodPressentVC{
    [TalkingData trackEvent:@"2100003" label:@"首页>血压测量"];
    BloodPressureDetectioViewController *bloodPressureDetectioViewController = [self.sboard instantiateViewControllerWithIdentifier:@"BloodPressureDetectioViewController"];
    [self.navigationController pushViewController:bloodPressureDetectioViewController animated:YES];
}

//肺活量跳转
- (void)goVitalCapacityVC{
    [TalkingData trackEvent:@"2100006" label:@"首页>肺活量测量"];
    VitalCapacityViewController *vitalCapacityViewController = [self.sboard instantiateViewControllerWithIdentifier:@"VitalCapacityViewController"];
    [self.navigationController pushViewController:vitalCapacityViewController animated:YES];
}

//心率跳转
- (void)goHeartReatVC{
    [TalkingData trackEvent:@"2100002" label:@"首页>心率测量"];
    HeartRateDetectioViewController *workGradeViewController = [self.sboard instantiateViewControllerWithIdentifier:@"HeartRateDetectioViewController"];
    [self.navigationController pushViewController:workGradeViewController animated:YES];
}

- (void)resultViewReloadData{
    
    switch (self.currentIndex) {
        case 2:
        {
            if(self.currentClickIndex == 0){
                //血氧====
                id model = [[KMDataManager sharedDatabaseInstance] getLastDataModelFromeType:EDataBloodOxygenType];
                if ([model isKindOfClass:[BloodOxygenDataModel class]]) {
                    BloodOxygenDataModel *obj = (BloodOxygenDataModel *)model;
                    
                    //                    NSLog(@"血氧 === %@",obj.value_id);
                    if ([obj.value_id floatValue] == 0) {
                        //没数据，直接去测量页
                        [self goBloodOxygenVC];
                    }else{
                        self.showResultView.type = EDataBloodOxygenType;
                        self.showResultView.valueNum = obj.value_id;
                        [self reShowResultView];
                    }
                }else{
                    [self goBloodOxygenVC];
                }
                
            }else if (self.currentClickIndex == 1){
                //视力
                //没数据，直接去测量页
                [self goEyeTestVC];
            }else{
                //血糖
                //没数据，直接去测量页
                [self goBloodSugarVC];
            }
            
        }
            break;
        case 1:
        {
            if(self.currentClickIndex == 0){
                //计步
                //没数据，直接去测量页
                HealthStepViewController *workGradeViewController = [self.sboard instantiateViewControllerWithIdentifier:@"HealthStepViewController"];
                [self.navigationController pushViewController:workGradeViewController animated:YES];
            }else if (self.currentClickIndex == 1){
                return ;
            }else{
                //体脂
                //没数据，直接去测量页
                BodyDataViewController *bloodOxygenView = [self.sboard instantiateViewControllerWithIdentifier:@"BodyDataViewController"];
                [self.navigationController pushViewController:bloodOxygenView animated:YES];
            }
            
        }
            break;
        case 0:
        {
            if(self.currentClickIndex == 0){
                //血压测量
                id model = [[KMDataManager sharedDatabaseInstance] getLastDataModelFromeType:EDataBloodPressureType];
                if ([model isKindOfClass:[BloodPressureDataModel class]]) {
                    BloodPressureDataModel *obj = (BloodPressureDataModel *)model;
       
                    if ([obj.systolic_pressure_id floatValue] == 0 && [obj.diastolic_blood_id floatValue] == 0) {
                        //没数据，直接去测量页
                        [self goBloodPressentVC];
                    }else{
                        self.showResultView.type = EDataBloodPressureType;
                        self.showResultView.leftNum = obj.diastolic_blood_id;
                        self.showResultView.RightNum = obj.systolic_pressure_id;
                        [self reShowResultView];
                    }
                }else{
                    [self goBloodPressentVC];
                }
            }else if (self.currentClickIndex == 1){
                //心率测量
                id model = [[KMDataManager sharedDatabaseInstance] getLastDataModelFromeType:EDataHeartRateType];
                if ([model isKindOfClass:[HeartRateDataModel class]]) {
                    HeartRateDataModel *obj = (HeartRateDataModel *)model;

                    if ([obj.value_id floatValue] == 0) {
                        //没数据，直接去测量页
                        [self goHeartReatVC];
                    }else{
                        self.showResultView.type = EDataHeartRateType;
                        self.showResultView.valueNum = obj.value_id;
                        [self reShowResultView];
                    }
                }else{
                    [self goHeartReatVC];
                }
            }else{
                //肺活量测
                id model = [[KMDataManager sharedDatabaseInstance] getLastDataModelFromeType:EDataVitalCapacityType];
                if ([model isKindOfClass:[VitalCapacityDataModel class]]) {
                    VitalCapacityDataModel *obj = (VitalCapacityDataModel *)model;
   
                    if ([obj.value_id floatValue] == 0) {
                        //没数据，直接去测量页
                        [self goVitalCapacityVC];
                    }else{
                        self.showResultView.type = EDataVitalCapacityType;
                        self.showResultView.valueNum = obj.value_id;
                        [self reShowResultView];
                    }
                }else{
                    [self goVitalCapacityVC];
                }
            }
            
        }
            break;
        default:
            break;
    }
}


//上划
- (void)upScrollView{
    [self.pageFlowView autoNextPage:YES];
}

//下滑
- (void)downScrollView{
    [self.pageFlowView autoNextPage:NO];
}

//隐藏菜单
- (void)loginOrRegister{
    self.menuView.hidden = NO;
}

//隐藏线条和图片
- (void)removeLayer{
    
    [UIView animateWithDuration:0 animations:^{
        self.topLable.alpha = 0;
        self.topImageView.alpha = 0;
        self.midImageView.alpha = 0;
        self.midLable.alpha = 0;
        self.botImageView.alpha = 0;
        self.bottomLable.alpha = 0;
        
        if(self.pathShapeView1.shapeLayer){
            self.pathShapeView1.shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        }
        if(self.pathShapeView2.shapeLayer){
            self.pathShapeView2.shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        }
        if(self.pathShapeView3.shapeLayer){
            self.pathShapeView3.shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        }
    }];
}


- (void)creatThreeLine{
    
    //添加path的UIView
    self.pathShapeView1 = [[ShapeView alloc] init];
    self.pathShapeView1.backgroundColor = [UIColor clearColor];
    self.pathShapeView1.opaque = NO;
    self.pathShapeView1.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.pathShapeView1];
    
    
    //添加path的UIView
    self.pathShapeView2 = [[ShapeView alloc] init];
    self.pathShapeView2.backgroundColor = [UIColor clearColor];
    self.pathShapeView2.opaque = NO;
    self.pathShapeView2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.pathShapeView2];
    
    //添加path的UIView
    self.pathShapeView3= [[ShapeView alloc] init];
    self.pathShapeView3.backgroundColor = [UIColor clearColor];
    self.pathShapeView3.opaque = NO;
    self.pathShapeView3.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.pathShapeView3];
}

//开始瞄点
- (void)satrtadsAnimationWithLintCount:(NSInteger)lineCount{
    
    self.topLable.text = [NSString stringWithFormat:@"%@",self.titleArr[self.currentIndex][0]];
    self.midLable.text = [NSString stringWithFormat:@"%@",self.currentIndex==1?@"":self.titleArr[self.currentIndex][1]];
    self.bottomLable.text = [NSString stringWithFormat:@"%@",self.currentIndex==1?self.titleArr[self.currentIndex][1]:self.titleArr[self.currentIndex][2]];
    
    
    if (self.currentIndex !=1) {
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.topLable.alpha = 1;
            self.topImageView.alpha = 1;
            self.midLable.alpha = 1;
            self.midImageView.alpha = 1;
            self.bottomLable.alpha = 1;
            self.botImageView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
        
        //不是腿，三条线
        [UIView animateWithDuration:0 animations:^{
            
            //设置线条的颜色
            self.pathShapeView1.shapeLayer.fillColor = nil;
            self.pathShapeView1.shapeLayer.strokeColor = UIColorFromHEX(0x42b3ff, 1).CGColor;
            self.pathShapeView1.shapeLayer.lineWidth = 1;
            
            //创建动画
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
            animation.fromValue = @0.0;
            animation.toValue = @1.0;
            animation.duration = 0.4;//kDuration;
            [self.pathShapeView1.shapeLayer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
            [self updatePathsWithPathShapeView:self.pathShapeView1 statrPoint:CGPointMake(self.size.width + 25 - self.offsetX, (self.view.frame.size.height)/2.0 - 10) midPoint:CGPointMake(self.size.width + 45 - self.offsetX, (self.view.frame.size.height)/2.0 - 20 - 10) endPoint:CGPointMake(self.size.width + 55 - self.offsetX, (self.view.frame.size.height)/2.0 - 20 - 10) lastPoint:CGPointMake(self.size.width + 55 - self.offsetX, (self.view.frame.size.height)/2.0 - 20 - 10)];
        } completion:^(BOOL finished) {

            if (finished) {
                [UIView animateWithDuration:0 animations:^{
                    
                    //设置线条的颜色
                    UIColor *pathColor = UIColorFromHEX(0x42b3ff, 1);
                    self.pathShapeView2.shapeLayer.fillColor = nil;
                    self.pathShapeView2.shapeLayer.strokeColor = pathColor.CGColor;
                    self.pathShapeView2.shapeLayer.lineWidth = 1;
                    
                    //创建动画
                    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
                    animation.fromValue = @0.0;
                    animation.toValue = @1.0;
                    animation.duration = 0.4;//kDuration;
                    [self.pathShapeView2.shapeLayer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
                    [self updatePathsWithPathShapeView:self.pathShapeView2 statrPoint:CGPointMake(self.size.width + 25 - self.offsetX, (self.view.frame.size.height)/2.0 + 30) midPoint:CGPointMake(self.size.width + 75 - self.offsetX, (self.view.frame.size.height)/2.0 + 30) endPoint:CGPointMake(self.size.width + 5 + 77 - self.offsetX, (self.view.frame.size.height)/2.0 + 40) lastPoint:CGPointMake(self.size.width + 95 - self.offsetX, (self.view.frame.size.height)/2.0 + 40) ];
                }completion:^(BOOL finished) {
                    if (finished) {
                        [UIView animateWithDuration:0.5 animations:^{
                            
                            //设置线条的颜色
                            UIColor *pathColor = UIColorFromHEX(0x42b3ff, 1);
                            self.pathShapeView3.shapeLayer.fillColor = nil;
                            self.pathShapeView3.shapeLayer.strokeColor = pathColor.CGColor;
                            self.pathShapeView3.shapeLayer.lineWidth = 1;
                            
                            //创建动画
                            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
                            animation.fromValue = @0.0;
                            animation.toValue = @1.0;
                            animation.duration = 0.4;//kDuration;
                            [self.pathShapeView3.shapeLayer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
                            [self updatePathsWithPathShapeView:self.pathShapeView3 statrPoint:CGPointMake(self.size.width + 25 - self.offsetX, (self.view.frame.size.height)/2.0 + 70) midPoint:CGPointMake(self.size.width + 5 + 40 - self.offsetX, (self.view.frame.size.height)/2.0 + 90  ) endPoint:CGPointMake(self.size.width + 55 - self.offsetX, (self.view.frame.size.height)/2.0 + 90) lastPoint:CGPointMake(self.size.width + 55 - self.offsetX, (self.view.frame.size.height)/2.0 + 90)];
                        } completion:^(BOOL finished) {
                        }];
                    }
                }];
            }
        }];
    }
    else{
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.topLable.alpha = 1;
            self.topImageView.alpha = 1;
            self.midLable.alpha = 0;
            self.midImageView.alpha = 0;
            self.bottomLable.alpha = 1;
            self.botImageView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
        
        //腿，两条线
        [UIView animateWithDuration:0 animations:^{
            
            //设置线条的颜色
            self.pathShapeView1.shapeLayer.fillColor = nil;
            self.pathShapeView1.shapeLayer.strokeColor = UIColorFromHEX(0x42b3ff, 1).CGColor;
            self.pathShapeView1.shapeLayer.lineWidth = 1;
            
            //创建动画
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
            animation.fromValue = @0.0;
            animation.toValue = @1.0;
            animation.duration = 0.4;//kDuration;
            [self.pathShapeView1.shapeLayer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
            [self updatePathsWithPathShapeView:self.pathShapeView1 statrPoint:CGPointMake(self.size.width + 25 - self.offsetX, (self.view.frame.size.height)/2.0 - 10) midPoint:CGPointMake(self.size.width + 45 - self.offsetX, (self.view.frame.size.height)/2.0 - 20 - 10) endPoint:CGPointMake(self.size.width + 55 - self.offsetX, (self.view.frame.size.height)/2.0 -20 - 10) lastPoint:CGPointMake(self.size.width + 55 - self.offsetX, (self.view.frame.size.height)/2.0 - 20 - 10)];
        }completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0 animations:^{
                    
                    //设置线条的颜色
                    self.pathShapeView2.shapeLayer.fillColor = nil;
                    self.pathShapeView2.shapeLayer.strokeColor = [UIColor clearColor].CGColor;
                    self.pathShapeView2.shapeLayer.lineWidth = 1;
                    
                    //创建动画
                    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
                    animation.fromValue = @0.0;
                    animation.toValue = @1.0;
                    animation.duration = 0.4;//kDuration;
                    [self.pathShapeView2.shapeLayer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
                    [self updatePathsWithPathShapeView:self.pathShapeView2 statrPoint:CGPointMake(self.size.width + 25 - self.offsetX, (self.view.frame.size.height)/2.0 + 30) midPoint:CGPointMake(self.size.width + 75 - self.offsetX, (self.view.frame.size.height)/2.0 + 30) endPoint:CGPointMake(self.size.width + 5 + 57 + 20 - self.offsetX, (self.view.frame.size.height)/2.0 + 40) lastPoint:CGPointMake(self.size.width + 95 - self.offsetX, (self.view.frame.size.height)/2.0 + 40) ];
                }completion:^(BOOL finished) {
                    if (finished) {
                        [UIView animateWithDuration:0.5 animations:^{
                            
                            //设置线条的颜色
                            self.pathShapeView3.shapeLayer.fillColor = nil;
                            self.pathShapeView3.shapeLayer.strokeColor = UIColorFromHEX(0x42b3ff, 1).CGColor;
                            self.pathShapeView3.shapeLayer.lineWidth = 1;
                            
                            //创建动画
                            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
                            animation.fromValue = @0.0;
                            animation.toValue = @1.0;
                            animation.duration = 0.4;//kDuration;
                            [self.pathShapeView3.shapeLayer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
                            [self updatePathsWithPathShapeView:self.pathShapeView3 statrPoint:CGPointMake(self.size.width + 25 - self.offsetX, (self.view.frame.size.height)/2.0 + 70) midPoint:CGPointMake(self.size.width + 5 + 40 - self.offsetX, (self.view.frame.size.height)/2.0 + 90  ) endPoint:CGPointMake(self.size.width + 55 - self.offsetX, (self.view.frame.size.height)/2.0 + 90) lastPoint:CGPointMake(self.size.width + 55 - self.offsetX, (self.view.frame.size.height)/2.0 + 90)];
                        } completion:^(BOOL finished) {
                        }];
                    }
                }];
            }
        }];
    }
    
}


//开始划线
- (void)updatePathsWithPathShapeView:(ShapeView *)pathShapeView statrPoint:(CGPoint)statrPoint midPoint:(CGPoint)midPoint  endPoint:(CGPoint)endPoint lastPoint:(CGPoint)lastPoint
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:statrPoint];
    [path addLineToPoint:midPoint];
    [path addLineToPoint:endPoint];
    [path addLineToPoint:lastPoint];
    
    //最后一个圆点
    [path addLineToPoint:CGPointMake(lastPoint.x+0.5, lastPoint.y-0.5)];
    [path addLineToPoint:CGPointMake(lastPoint.x+1, lastPoint.y)];
    [path addLineToPoint:CGPointMake(lastPoint.x+0.5, lastPoint.y+0.5)];
    [path addLineToPoint:CGPointMake(lastPoint.x, lastPoint.y)];
    
    path.usesEvenOddFillRule = YES;
    pathShapeView.shapeLayer.path = path.CGPath;
}


#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    
    return self.size;
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {

}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    //根据滑动的下标，切换线条数量、图标、文字
    self.currentIndex = pageNumber%3;
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.imageArray.count;
    
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    
    bannerView.mainImageView.image = self.imageArray[index];
    
    return bannerView;
}


#pragma mark --懒加载
- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bgImageView.image = [UIImage imageNamed:@"indexbg"];
        [_bgImageView sizeToFit];
    }
    
    return _bgImageView;
}


- (UILabel *)topLable{
    if (!_topLable) {
        _topLable = [[UILabel alloc]init];
        if (iPhone5) {
            _topLable.frame = CGRectMake(self.size.width + 120 - self.offsetX - self.offsetSizeWidth, (self.view.frame.size.height)/2.0 - 35, 100, 25);
        }else if (iPhone6){
            _topLable.frame = CGRectMake(self.size.width + 125 - self.offsetX - self.offsetSizeWidth, (self.view.frame.size.height)/2.0 - 35, 100, 25);
        }else if (iPhone6p){
            _topLable.frame = CGRectMake(self.size.width + 125 - self.offsetX - self.offsetSizeWidth, (self.view.frame.size.height)/2.0 - 35, 100, 25);
        }else{
            //x
            _topLable.frame = CGRectMake(self.size.width + 120 - self.offsetX - self.offsetSizeWidth, (self.view.frame.size.height)/2.0 - 35, 100, 25);
        }
        _topLable.textColor = UIColorFromHEX(0x42b3ff, 1);
        _topLable.font = [UIFont systemFontOfSize:12];
        _topLable.textAlignment = NSTextAlignmentLeft;
        _topLable.alpha = 0;
        _topLable.text = @"血氧";
    }
    return _topLable;
}

- (UILabel *)midLable{
    if (!_midLable) {
        _midLable = [[UILabel alloc]init];
        if (iPhone5) {
            _midLable.frame = CGRectMake(self.size.width + 30 - self.offsetX - self.offsetSizeWidth - 5, (self.view.frame.size.height)/2.0 , 80, 25);
        }else if (iPhone6){
            _midLable.frame = CGRectMake(self.size.width + 25 - self.offsetX - self.offsetSizeWidth, (self.view.frame.size.height)/2.0 , 80, 25);
        }else{
            //x/6sp
            _midLable.frame = CGRectMake(self.size.width + 20 - self.offsetX - self.offsetSizeWidth, (self.view.frame.size.height)/2.0 , 80, 25);
        }
        _midLable.textColor = UIColorFromHEX(0x42b3ff, 1);
        _midLable.font = [UIFont systemFontOfSize:12];
        _midLable.alpha = 0;
        _midLable.textAlignment = NSTextAlignmentCenter;
        _midLable.text = @"视力";
    }
    return _midLable;
}

- (UILabel *)bottomLable{
    if (!_bottomLable) {
        _bottomLable = [[UILabel alloc]init];
        if (iPhone5) {
            _bottomLable.frame = CGRectMake(self.size.width + 120 - self.offsetX - self.offsetSizeWidth, (self.view.frame.size.height)/2.0 + 70, 100, 25);
        }else if (iPhone6){
            _bottomLable.frame = CGRectMake(self.size.width + 125 - self.offsetX - self.offsetSizeWidth, (self.view.frame.size.height)/2.0 + 70, 100, 25);
        }else if (iPhone6p){
            _bottomLable.frame = CGRectMake(self.size.width + 125 - self.offsetX - self.offsetSizeWidth, (self.view.frame.size.height)/2.0 + 70, 100, 25);
        }else{
            //x
            _bottomLable.frame = CGRectMake(self.size.width + 120 - self.offsetX - self.offsetSizeWidth, (self.view.frame.size.height)/2.0 + 70, 100, 25);
        }
        
        _bottomLable.textColor = UIColorFromHEX(0x42b3ff, 1);
        _bottomLable.font = [UIFont systemFontOfSize:12];
        _bottomLable.text = @"血脂";
        _bottomLable.textAlignment = NSTextAlignmentLeft;
        _bottomLable.alpha = 0;
    }
    return _bottomLable;
}

- (UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        if (iPhone5) {
            _topImageView.frame = CGRectMake(self.size.width + 65 - self.offsetX - 5, (self.view.frame.size.height)/2.0 - 45, 50, 50);
        }else if (iPhone6){
            _topImageView.frame = CGRectMake(self.size.width + 65 - self.offsetX, (self.view.frame.size.height)/2.0 - 45, 50, 50);
        }else{
            //x/6sp
            _topImageView.frame = CGRectMake(self.size.width + 65 - self.offsetX, (self.view.frame.size.height)/2.0 - 50, 50, 50);
        }
        _topImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageNomelArr[self.currentIndex][0]]];;
        _topImageView.alpha = 0;
        _topImageView.userInteractionEnabled = YES;
        WEAK_SELF(self);
        [_topImageView bk_whenTapped:^{
            STRONG_SELF(self);
            [UIView animateWithDuration:0 animations:^{
                if (self.currentIndex == 1) {
                    self.pathShapeView3.shapeLayer.strokeColor = UIColorFromHEX(0x42b3ff, 1).CGColor;
                    self.pathShapeView2.shapeLayer.strokeColor = [UIColor clearColor].CGColor;
                    self.pathShapeView1.shapeLayer.strokeColor = UIColorFromHEX(0xd9b611, 1).CGColor;
                }else{
                    self.pathShapeView3.shapeLayer.strokeColor = UIColorFromHEX(0x42b3ff, 1).CGColor;
                    self.pathShapeView2.shapeLayer.strokeColor = UIColorFromHEX(0x42b3ff, 1).CGColor;
                    self.pathShapeView1.shapeLayer.strokeColor = UIColorFromHEX(0xd9b611, 1).CGColor;
                }
                
                self.topImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageSlectArr[self.currentIndex][0]]];
                self.midImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.currentIndex==1?@"":self.imageNomelArr[self.currentIndex][1]]];
                self.botImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.currentIndex==1?self.imageNomelArr[self.currentIndex][1]:self.imageNomelArr[self.currentIndex][2]]];
            }];
            
            self.currentClickIndex = 0;
            [self resultViewReloadData];
        }];
    }
    
    return _topImageView;
}

- (UIImageView *)midImageView{
    if (!_midImageView) {
        _midImageView = [[UIImageView alloc] init];
        if (iPhone5) {
            _midImageView.frame = CGRectMake(self.size.width + 105 - self.offsetX - 5, (self.view.frame.size.height)/2.0 + 5, 50, 50);
        }else if (iPhone6){
            _midImageView.frame = CGRectMake(self.size.width + 105 - self.offsetX, (self.view.frame.size.height)/2.0 + 5, 50, 50);
        }else{
            //x/6sp
            _midImageView.frame = CGRectMake(self.size.width + 105 - self.offsetX, (self.view.frame.size.height)/2.0 + 5, 50, 50);
        }
        _midImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.currentIndex==1?@"":self.imageNomelArr[self.currentIndex][1]]];;
        _midImageView.userInteractionEnabled = YES;
        _midImageView.alpha = 0;
        WEAK_SELF(self);
        [_midImageView bk_whenTapped:^{
            STRONG_SELF(self);
            [UIView animateWithDuration:0 animations:^{
                self.pathShapeView3.shapeLayer.strokeColor = UIColorFromHEX(0x42b3ff, 1).CGColor;
                self.pathShapeView1.shapeLayer.strokeColor = UIColorFromHEX(0x42b3ff, 1).CGColor;
                self.pathShapeView2.shapeLayer.strokeColor = UIColorFromHEX(0xd9b611, 1).CGColor;
                
                self.topImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageNomelArr[self.currentIndex][0]]];
                self.midImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.currentIndex==1?@"":self.imageSlectArr[self.currentIndex][1]]];
                self.botImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.currentIndex==1?self.imageNomelArr[self.currentIndex][1]:self.imageNomelArr[self.currentIndex][2]]];
            }];
            
            self.currentClickIndex = 1;
            [self resultViewReloadData];
        }];
    }
    
    return _midImageView;
}


- (UIImageView *)botImageView{
    if (!_botImageView) {
        _botImageView = [[UIImageView alloc] init];
        if (iPhone5) {
            _botImageView.frame = CGRectMake(self.size.width + 65 - self.offsetX - 5, (MainScreenHeight)/2.0 + 55, 50, 50);
        }else if (iPhone6){
            _botImageView.frame = CGRectMake(self.size.width + 65 - self.offsetX, (MainScreenHeight)/2.0 + 55, 50, 50);
        }else{
            //x/6sp
            _botImageView.frame = CGRectMake(self.size.width + 65 - self.offsetX, (MainScreenHeight)/2.0 + 55, 50, 50);
        }
        _botImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.currentIndex==1?self.imageNomelArr[self.currentIndex][1]:self.imageNomelArr[self.currentIndex][2]]];
        _botImageView.alpha = 0;
        _botImageView.userInteractionEnabled = YES;
        WEAK_SELF(self);
        [_botImageView bk_whenTapped:^{
            STRONG_SELF(self);
            [UIView animateWithDuration:0 animations:^{
                if (self.currentIndex == 1) {
                    self.pathShapeView3.shapeLayer.strokeColor = UIColorFromHEX(0xd9b611, 1).CGColor;
                    self.pathShapeView2.shapeLayer.strokeColor = [UIColor clearColor].CGColor;
                    self.pathShapeView1.shapeLayer.strokeColor = UIColorFromHEX(0x42b3ff, 1).CGColor;
                }else{
                    self.pathShapeView1.shapeLayer.strokeColor = UIColorFromHEX(0x42b3ff, 1).CGColor;
                    self.pathShapeView2.shapeLayer.strokeColor = UIColorFromHEX(0x42b3ff, 1).CGColor;
                    self.pathShapeView3.shapeLayer.strokeColor = UIColorFromHEX(0xd9b611, 1).CGColor;
                }
                
                
                self.topImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageNomelArr[self.currentIndex][0]]];
                self.midImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.currentIndex==1?@"":self.imageNomelArr[self.currentIndex][1]]];
                self.botImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.currentIndex==1?self.imageSlectArr[self.currentIndex][1]:self.imageSlectArr[self.currentIndex][2]]];
            }];
            
            self.currentClickIndex = 2;
            [self resultViewReloadData];
        }];
        
    }
    
    return _botImageView;
}


- (UIImageView *)upImageView{
    if (!_upImageView) {
        _upImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _upImageView.image = [UIImage imageNamed:@"up"];
        _upImageView.userInteractionEnabled = YES;
        [_upImageView sizeToFit];
        WEAK_SELF(self);
        [_upImageView bk_whenTapped:^{
            STRONG_SELF(self);
            [self upScrollView];
        }];
    }
    
    return _upImageView;
}

- (UIImageView *)downImageView{
    if (!_downImageView) {
        _downImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _downImageView.image = [UIImage imageNamed:@"down"];
        [_downImageView sizeToFit];
        _downImageView.userInteractionEnabled = YES;
        WEAK_SELF(self);
        [_downImageView bk_whenTapped:^{
            STRONG_SELF(self);
            [self downScrollView];
        }];
    }
    
    return _downImageView;
}

-(UIView *)upView{
    if (!_upView) {
        _upView = [[UIView alloc]init];
        _upView.frame = CGRectMake(0, 134, MainScreenWidth, self.scrollViewHeight/3.0);;
        _upView.backgroundColor = [UIColor clearColor];
        WEAK_SELF(self);
        [_upView bk_whenTapped:^{
            STRONG_SELF(self);
            [self downScrollView];
        }];
        
        UISwipeGestureRecognizer *recognizerUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(upScrollView)];
        [recognizerUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [_upView addGestureRecognizer:recognizerUp];
        
        UISwipeGestureRecognizer *recognizerDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(downScrollView)];
        [recognizerDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [_upView addGestureRecognizer:recognizerDown];
    }
    return _upView;
    
}

-(UIView *)midView{
    if (!_midView) {
        _midView = [[UIView alloc]init];
        _midView.frame = CGRectMake(0, 134+self.scrollViewHeight/3.0, MainScreenWidth, self.scrollViewHeight/3.0);;
        _midView.backgroundColor = [UIColor clearColor];
        
        UISwipeGestureRecognizer *recognizerUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(upScrollView)];
        [recognizerUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [_midView addGestureRecognizer:recognizerUp];
        
        UISwipeGestureRecognizer *recognizerDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(downScrollView)];
        [recognizerDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [_midView addGestureRecognizer:recognizerDown];
    }
    return _midView;
    
}

-(UIView *)downView{
    if (!_downView) {
        _downView = [[UIView alloc]init];
        _downView.frame = CGRectMake(0, 134+self.scrollViewHeight/3.0*2, MainScreenWidth, self.scrollViewHeight/3.0);
        _downView.backgroundColor = [UIColor clearColor];
        
        WEAK_SELF(self);
        [_downView bk_whenTapped:^{
            STRONG_SELF(self);
            [self upScrollView];
        }];
        
        UISwipeGestureRecognizer *recognizerUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(upScrollView)];
        [recognizerUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [_downView addGestureRecognizer:recognizerUp];
        
        UISwipeGestureRecognizer *recognizerDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(downScrollView)];
        [recognizerDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [_downView addGestureRecognizer:recognizerDown];
        
    }
    return _downView;
    
}

- (UILabel *)titleLable{
    
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLable.font = [UIFont systemFontOfSize:20];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.textColor = UIColorFromHEX(0x42b3ff, 1);
        _titleLable.text = @"首页";
    }
    return _titleLable;
}


- (BATShowResultView *)showResultView{
    if (!_showResultView) {
        _showResultView = [[BATShowResultView alloc] initWithFrame:self.view.bounds];
        _showResultView.hidden = YES;
        WEAK_SELF(self);
        
        [_showResultView setGoHiddenSelfBlock:^{
            STRONG_SELF(self);
            [self hiddenResultView];
        }];
        
        [_showResultView setGoTestBlock:^{
            STRONG_SELF(self);
            [self hiddenResultView];
            
            switch (self.currentIndex) {
                case 2:
                {
                    if(self.currentClickIndex == 0){
                        //血氧
                        [self goBloodOxygenVC];
                    }else if (self.currentClickIndex == 1){
                        //视力
                        [self goEyeTestVC];
                    }else{
                        //血糖
                        [self goBloodSugarVC];
                    }
                    
                }
                    break;
                case 1:
                {
                    if(self.currentClickIndex == 0){
                        //计步
                        [self goHealthStepVC];
                    }else if (self.currentClickIndex == 1){
                        return ;
                    }else{
                        //体脂
                        [self goBodyDataVC];
                    }
                    
                }
                    break;
                case 0:
                {
                    if(self.currentClickIndex == 0){
                        //血压测量
                        [self goBloodPressentVC];
                    }else if (self.currentClickIndex == 1){
                        //心率测量
                        [self goHeartReatVC];
                    }else{
                        //肺活量测
                        [self goVitalCapacityVC];
                    }
                    
                }
                    break;
                default:
                    break;
            }
            
            
        }];
        
        [_showResultView setGoResultBlock:^{
            STRONG_SELF(self);
            [self hiddenResultView];
            
            HeartChartViewController *heartChartViewController = [self.sboard instantiateViewControllerWithIdentifier:@"HeartChartViewController"];
            switch (self.currentIndex) {
                case 2:
                {
                    if(self.currentClickIndex == 0){
                        //血氧
                        heartChartViewController.type = EChartDataBloodOxygenType;
                    }else if (self.currentClickIndex == 1){
                        //视力
                        heartChartViewController.type = EChartDataVisionDataType;
                    }else{
                        //血糖
                        heartChartViewController.type = EChartDataBloodSugarDataType;
                    }
                }
                    break;
                case 1:
                {
                    
                    if(self.currentClickIndex == 0){
                        //计步
                        heartChartViewController.type = EChartDataHealthStepType;
                        
                    }else if (self.currentClickIndex == 1){
                        return ;
                    }else{
                        //体脂
                        self.showResultView.hidden = YES;
                    }
                    
                }
                    break;
                case 0:
                {
                    if(self.currentClickIndex == 0){
                        //血压测量
                        heartChartViewController.type = EChartDataBloodPressureType;
                        
                    }else if (self.currentClickIndex == 1){
                        //心率测量
                        heartChartViewController.type = EChartDataHeartRateType;
                    }else{
                        //肺活量测
                        heartChartViewController.type = EChartDataVitalCapacityType;
                    }
                    
                }
                    break;
                default:
                    break;
            }
            [self.navigationController pushViewController:heartChartViewController animated:YES];
            
            
        }];
    }
    
    return _showResultView;
}


- (UIButton *)loginAndRegisterBtn{
    if (!_loginAndRegisterBtn) {
        _loginAndRegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginAndRegisterBtn setImage:[UIImage imageNamed:@"option"] forState:UIControlStateNormal];
        _loginAndRegisterBtn.imageEdgeInsets = UIEdgeInsetsMake(5 ,5 , 5, 5);
        [_loginAndRegisterBtn addTarget:self action:@selector(loginOrRegister) forControlEvents:UIControlEventTouchUpInside];
        [_loginAndRegisterBtn sizeToFit];
    }
    return _loginAndRegisterBtn;
}

- (BATMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[BATMenuView alloc] initWithFrame:self.view.bounds];
        _menuView.hidden = YES;
        WEAK_SELF(self);
        
        [_menuView setGoHiddenSelfBlock:^{
            STRONG_SELF(self);
            self.menuView.hidden = YES;
            //            NSLog(@"影藏！");
        }];
        
        [_menuView setGoLoginBlock:^{
            STRONG_SELF(self);
            self.menuView.hidden = YES;
            //            NSLog(@"登录/注册！");
            if (LOGIN_STATION) {
                DetailViewController *heartChartViewController = [self.sboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
                [self.navigationController pushViewController:heartChartViewController animated:YES];
            }
            else
            {
                BATLoginViewController *loginVC = [[BATLoginViewController alloc] init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            
        }];
        
        [_menuView setGoTellPhoneBlock:^{
            STRONG_SELF(self);
            self.menuView.hidden = YES;
            //            NSLog(@"客服电话！");
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"客服电话：400-888-6158转1" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4008886158"]];
                });
            }];
            [alertController addAction:sureAction];
            UIAlertAction *canleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:canleAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }];
        
        [_menuView setGoSetBlock:^{
            STRONG_SELF(self);
            self.menuView.hidden = YES;
            //            NSLog(@"设置！");
            
            if (LOGIN_STATION) {
                SettingViewController *heartChartViewController = [self.sboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
                heartChartViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:heartChartViewController animated:YES];
            }
            else
            {
                BATLoginViewController *loginVC = [[BATLoginViewController alloc] init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            
        }];
        
    }
    
    return _menuView;
}

@end

