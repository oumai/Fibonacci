//
//  DetectioResultViewController.m
//  Fibonacci
//
//  Created by shipeiyuan on 16/8/26.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "DetectioResultViewController.h"
#import "DetectioResultView.h"
#import "HeartView.h"
#import "HelpViewController.h"
#import "ManuallyEnteredViewController.h"
#import "ShareCustom.h"
#import "AppDelegate+BATShare.h"

#define DetectioHeartViewHeightAndWidth 35

@interface DetectioResultViewController ()

@end

static const NSTimeInterval TIDetectioResultViewControllerHeartMoveInterval = 1.0;

@implementation DetectioResultViewController
@synthesize sumCount = _sumCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试结果";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[KMDataManager sharedDatabaseInstance] insertHeartRateDataModelNumber:[NSNumber numberWithInteger:_sumCount]];
    });
    [self initControllerView];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)initControllerView
{
    CGFloat minY = 0;
    if (self.navigationController.navigationBar.translucent&&!self.extendedLayoutIncludesOpaqueBars) {
        minY = kStatusAndNavHeight;
    }
    CGFloat heartResultY = 50 ;
    if(iPhone5)
    {
        heartResultY = 20;
    }
    UILabel* heartResultLabel = [[UILabel alloc] initWithFrame:CGRectMake((MainScreenWidth- 100)/2-50, heartResultY + minY, 100, 50)];
    heartResultLabel.textColor = RGB(230, 171, 61);

    heartResultLabel.font = [UIFont systemFontOfSize: 50];
    heartResultLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_sumCount];
    heartResultLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:heartResultLabel];
    
    HeartView * heartView = [[HeartView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(heartResultLabel.frame) + 10, CGRectGetMinY(heartResultLabel.frame)+5, 23, 23)];
    heartView.lineWidth = 1;
    heartView.strokeColor = RGB(230, 171, 61);
    heartView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:heartView];
    
    UILabel* HUDLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(heartResultLabel.frame) + 10, CGRectGetMaxY(heartView.frame)-5, 50, 25)];
    HUDLabel.textColor = RGB(99,177,249);
    HUDLabel.font = [UIFont systemFontOfSize: 18];
    HUDLabel.text = @"BMP";
    HUDLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:HUDLabel];
    
    CGFloat DetectioResultViewWidth = MainScreenWidth - 50; //色彩渐变条的宽度
    CGFloat detectioHeartViewStartX = (25-DetectioHeartViewHeightAndWidth/2); //心的起始Y
    CGFloat detectioHeartViewMinY = CGRectGetMaxY(heartResultLabel.frame)+50;
    if(iPhone5)
    {
        detectioHeartViewMinY = CGRectGetMaxY(heartResultLabel.frame)+20;
    }
    detectioHeartView = [[HeartView alloc]initWithFrame:CGRectMake(detectioHeartViewStartX, detectioHeartViewMinY, DetectioHeartViewHeightAndWidth, DetectioHeartViewHeightAndWidth)];
    detectioHeartView.lineWidth = 0.1;
    detectioHeartView.strokeColor = RGB(212, 93, 88);
    detectioHeartView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:detectioHeartView];
    
    detectioResultView = [[DetectioResultView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(detectioHeartView.frame), DetectioResultViewWidth, 12)];
    detectioResultView.backgroundColor = [UIColor whiteColor];
    detectioResultView.layer.cornerRadius = 7.0;
    detectioResultView.layer.masksToBounds = YES;
    [self.view addSubview:detectioResultView];
    
    [self setValueHUDLabelFromType:0];
    
    UILabel *textLable = [[UILabel alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(detectioResultView.frame)+30+30, MainScreenWidth, 50}];
    textLable.backgroundColor = RGBA(37, 36, 99, 0.4);
    textLable.text = @"  本次测量时状态";
    textLable.font = [UIFont systemFontOfSize:11];
    textLable.textColor = RGB(99,177,249) ;
    [self.view addSubview:textLable];
    
    NSArray *titleArray = @[@"休息",@"运动前",@"运动后",@"最大心率"];
    NSArray *imageArray = @[@"cardiograph_rest_icon", @"cardiograph_beforeexercise_icon", @"cardiograph_postexercise_icon", @"cardiograph_maximum_icon"];
    NSUInteger count = 4;
    CGFloat imageWidth = 35;
    CGFloat imageHeight = 35;
    CGFloat labelWidth = imageWidth +20;
    CGFloat labelHeight = 40;
    CGFloat width = (MainScreenWidth -count*labelWidth)/count;
    CGFloat viewHeight = imageHeight + labelHeight;
    CGFloat viewWidth = labelWidth;
    CGFloat stateViewHeight = 0;
    UIView *stateView = [[UIView alloc] init];
    [self.view addSubview:stateView];
    for (NSInteger i = 0;i< [titleArray count];i++)
    {
        UIView *btnView = [[UIView alloc] init];
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonStateTap :)];
        [btnView addGestureRecognizer:tapGesture];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(10, 0, imageWidth, imageHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 101+i;
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, imageHeight, labelWidth, labelHeight)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = RGB(99,177,249);
        [btnView addSubview:imageView];
        [btnView addSubview:label];
        
        btnView.tag = i;
        btnView.frame = CGRectMake(width/2+(i%count)*width+((i%count)*labelWidth), 10+(i/count)*(viewWidth + 30), viewWidth, viewHeight);
        label.text = titleArray[i];
        [stateView addSubview:btnView];
        stateViewHeight = CGRectGetHeight(btnView.frame);
        imageView.image = [UIImage imageNamed: imageArray[i]];
    }
    stateView.frame = (CGRect){0,CGRectGetMaxY(textLable.frame)+5,MainScreenWidth,stateViewHeight};
    
    CGFloat buttonH = 50;
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(MainScreenWidth/3, CGRectGetMaxY(stateView.frame)+30, MainScreenWidth/3, buttonH);
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [shareButton setTitle: @"分享" forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"btn"];
    [shareButton setBackgroundImage: image forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
    
    UIButton *accuracyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    accuracyButton.frame = CGRectMake(50, CGRectGetMaxY(shareButton.frame)+5, MainScreenWidth - 100, buttonH);
    [accuracyButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [accuracyButton setTitle: @"不准" forState:UIControlStateNormal];
    [accuracyButton setTitleColor:RGB(99,177,249) forState:UIControlStateNormal];
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

- (void)setValueHUDLabelFromType:(NSInteger)type
{
    CGFloat y = CGRectGetMaxY(detectioResultView.frame);
    detectioResultView.shadeType = type;
    NSArray *textArray;
    CGFloat labelWRatio = 0.f;
    CGFloat labelW = (MainScreenWidth - 50)/3;
        switch (type) {
            case 0:
            {
                labelWRatio = 1;
                HeightHeartRate = 120;
                LowHeartRate = 30;
                textArray = @[@"<60过缓",@"60-90正常",@">90过快"];
            }
                break;
            case 1:
            {
                labelWRatio = 1.1;
                HeightHeartRate = 130;
                LowHeartRate = 50;
                textArray = @[@"<75过缓",@"75-100正常",@">100过快"];
            }
                break;
            case 2:
            {
                labelWRatio = 1.2;

                HeightHeartRate = 140;
                LowHeartRate = 60;
                textArray = @[@"<90过缓",@"90-120正常",@">120过快"];
            }
                break;
            case 3:
            {
                labelWRatio = 1.3;
                HeightHeartRate = 155;
                LowHeartRate = 75;
                textArray = @[@"<105过缓",@"105-135正常",@">135过快"];
            }
                break;
                
            default:
                break;
    }
    for (UIView *elem in self.view.subviews) {
        if (elem.tag >999 && elem.tag!= 2018007) {
            [elem removeFromSuperview];
        }
    }
    CGFloat lastWitdh = 0.f;
    CGFloat lastX = 0.f;
    for (int i = 0; i <3; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = textArray[i];
        label.textColor = RGB(99,177,249);
        label.font = [UIFont fontWithName:@"Avenir-Light" size:13];
        label.tag = 1000+i;
        switch (i) {
            case 0:
                label.frame = CGRectMake(lastX+25, y, labelWRatio *labelW, 30);
                label.textAlignment = NSTextAlignmentRight;
                break;
            case 1:
                label.frame = CGRectMake(lastX+25, y, lastWitdh, 30);
                label.textAlignment = NSTextAlignmentCenter;
                break;
            case 2:
                //NSLog(@"%f",MainScreenWidth - 50-lastWitdh);
                label.frame = CGRectMake(type==3?lastX+12:lastX+25, y, MainScreenWidth - 25-lastX, 30);
                label.textAlignment = NSTextAlignmentLeft;
                break;
            default:
                break;
        }
        lastX = CGRectGetMaxX(label.frame)-25;
        lastWitdh = CGRectGetWidth(label.frame);
        [self.view addSubview:label];
    }
    [self getHeartMoveY:_sumCount];
    [self animateForheartMove];
}

//计算坐标
- (void)getHeartMoveY:(CGFloat)sum
{
    CGFloat DetectioResultViewWidth = MainScreenWidth - 50; //色彩渐变条的宽度
    CGFloat pixelY = DetectioResultViewWidth/(HeightHeartRate-LowHeartRate);  //每个心跳需要移动的坐标
    CGFloat detectioHeartViewStartX = (25-DetectioHeartViewHeightAndWidth/2); //心的起始Y
    if (sum<LowHeartRate)
    {
        sum = LowHeartRate;
    }
    else if (sum >HeightHeartRate)
    {
        sum = HeightHeartRate;
    }
    detectioHeartViewY = (sum - LowHeartRate)*pixelY + detectioHeartViewStartX;
    if (detectioHeartViewY>(DetectioResultViewWidth+detectioHeartViewStartX))
    {
        detectioHeartViewY = DetectioResultViewWidth+detectioHeartViewStartX;
    }
    else if (detectioHeartViewY< detectioHeartViewStartX)
    {
        detectioHeartViewY = detectioHeartViewStartX;
    }
}

#pragma mark -
- (void)buttonStateTap:(UITapGestureRecognizer *)tap
{
    UITapGestureRecognizer *tempTap = (UITapGestureRecognizer *)tap;
    UIView *view = (UIView *)tempTap.view;
    
    [self setValueHUDLabelFromType:view.tag];
    for (UIView *elem in tap.view.subviews) {
        if (elem.tag>100)
        {
            [UIView animateWithDuration:0.7 animations:^{
                elem.transform = CGAffineTransformMakeScale(1.3, 1.3);
                elem.alpha = 0.5;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    elem.alpha = 1;
                    elem.transform = CGAffineTransformIdentity;
                }];
            }];
        }
    }
}

- (void)animateForheartMove
{
    CGRect heartFrame = detectioHeartView.frame;
    heartFrame.origin.x = (25-DetectioHeartViewHeightAndWidth/2);
    detectioHeartView.frame = heartFrame;
    [UIView animateWithDuration:TIDetectioResultViewControllerHeartMoveInterval
                     animations:^(void) {
                         CGRect heartFrame = detectioHeartView.frame;
                         heartFrame.origin.x = detectioHeartViewY;
                         detectioHeartView.frame = heartFrame;
                     } completion:^(BOOL completed) {
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action
-(void)accuracyButton:(UIButton *)button
{
    UIStoryboard *sboard = [KMTools getStoryboardInstance];
    ManuallyEnteredViewController *helpViewController = [sboard instantiateViewControllerWithIdentifier:@"ManuallyEnteredViewController"];
    helpViewController.hidesBottomBarWhenPushed = YES;
    helpViewController.enteredType = EEnteredHeartRateType;
    [self.navigationController pushViewController:helpViewController animated:YES];
}

-(void)shareButton:(UIButton*)button
{
    [TalkingData trackEvent:@"210000202" label:@"测量结果页>分享"];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"logo"]];
    if (imageArray)
    {
        NSString *paramsText = [NSString stringWithFormat:@"心率测量 %li %@",_sumCount,SHARE_URL];
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
