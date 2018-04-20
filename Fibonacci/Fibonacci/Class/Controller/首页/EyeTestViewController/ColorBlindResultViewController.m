//
//  ColorBlindResultViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/22.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "ColorBlindResultViewController.h"
#import "JudgeView.h"
#import "ShareCustom.h"
#import "AppDelegate+BATShare.h"

@interface ColorBlindResultViewController ()

@end

@implementation ColorBlindResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"色盲测试结果";
    
    [self initResultData];
    [self initJudgeViewData];
    // Do any additional setup after loading the view.
}

- (void)initResultData
{
    NSInteger sum = 0;
    for (int i = 0; i < self.valueArray.count; i ++)
    {
        NSNumber *markNumber = self.valueArray[i];
        NSInteger markInteger= [markNumber integerValue];
        sum += markInteger*20;
    }
    int a = 50;
    int b = 20;
    NSString *labelText = @"";
    NSInteger redLength = 0;
    if (sum == 100)
    {
        labelText = [NSString stringWithFormat:@"%li 正常",(long)sum];
        redLength = 3;
    }
    else if(sum > 0)
    {
        labelText = [NSString stringWithFormat:@"%li 疑似",(long)sum];
        redLength = 2;
    }
    else
    {
        labelText = [NSString stringWithFormat:@"%li 疑似",(long)sum];
        redLength = 1;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [paragraphStyle setParagraphSpacing:10];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:a] range:NSMakeRange(0, redLength)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:b] range:NSMakeRange(redLength, labelText.length - redLength)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, labelText.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(219, 155, 57) range:NSMakeRange(0, redLength)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:AppFontColor range:NSMakeRange(redLength, labelText.length - redLength)];
    hudLabel.attributedText = attributedString;
    shareText =labelText;
}

- (void)initJudgeViewData
{
    CGFloat judgeW = 30;
    CGFloat judgeY = CGRectGetMaxY(hudLabel.frame) + judgeW;
    CGFloat widthSum = (MainScreenWidth-2*judgeW)/5;
    

    
    NSInteger ErrorCount = 0;
    CGFloat lastMaxY = 0;
    for (int i = 0; i < self.valueArray.count; i ++) {
        CGFloat judgeX = judgeW/2+i*widthSum + judgeW;
        if (lastMaxY>0) {
            CALayer *lineLayer = [CALayer layer];
            lineLayer.frame = CGRectMake( lastMaxY, judgeY+judgeW/2, widthSum-judgeW, 1);
            lineLayer.backgroundColor = [[UIColor lightGrayColor] CGColor];
            [self.view.layer addSublayer:lineLayer];
        }
        NSNumber *elem = self.valueArray[i];
        NSInteger Status = [elem integerValue];
        JudgeView *view = [[JudgeView alloc] initWithFrame:CGRectMake( judgeX,judgeY, judgeW, judgeW) status:Status];
        view.backgroundColor = [UIColor clearColor];
        view.layer.shouldRasterize = YES;
        [self.view addSubview:view];
        lastMaxY = CGRectGetMaxX(view.frame);
        if (Status<1) {
            ErrorCount++;
        }
    }
    
    NSString *hudStr = @"";
    switch (ErrorCount) {
        case 0:
        {
            hudStr = @"恭喜您，您没有色盲的症状";
        }
            break;
        case 1:
        {
            hudStr = @"您刚才状态有点不好，重新测量一次吧";
        }
            break;
        case 2:
        {
            hudStr = @"您有色盲的可能，多测量几次吧";
        }
            break;
        case 3:
        case 4:
        case 5:
        {
            hudStr = @"您很大几率是色盲患者";
        }
            break;
            
        default:
            break;
    }
    CGFloat buttonH = 50;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, judgeY+judgeW+40, MainScreenWidth-100, 30)];
    label.font = [UIFont fontWithName:AppFontHelvetica size:14];
    label.text = hudStr;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = AppFontColor;
    [self.view addSubview:label];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake( MainScreenWidth/3, CGRectGetMaxY(label.frame)+50, MainScreenWidth/3, buttonH);
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    UIImage *image = [UIImage imageNamed:@"btn"];
    [shareButton setTitle: @"分享" forState:UIControlStateNormal];
    [shareButton setBackgroundImage: image forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
    
    UILabel *resultHUDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainScreenHeight-40, MainScreenWidth, 40)];
    resultHUDLabel.font = [UIFont fontWithName:AppFontHelvetica size:13];
    resultHUDLabel.textAlignment = NSTextAlignmentCenter;
    resultHUDLabel.textColor = AppFontGrayColor;
    resultHUDLabel.numberOfLines = 2;
    resultHUDLabel.text = @"数据可能会存在一定范围的误差,测量结果仅供参考";
    [self.view addSubview:resultHUDLabel];
//    UIButton *accuracyButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    accuracyButton.frame = CGRectMake(50, CGRectGetMaxY(shareButton.frame)+5, MainScreenWidth - 100, buttonH);
//    //    [accuracyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [accuracyButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
//    [accuracyButton setTitle: @"不准？" forState:UIControlStateNormal];
//    //    [startButton addTarget:self action:@selector(startTestBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:accuracyButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)shareButton:(UIButton*)button
{
    [TalkingData trackEvent:@"21000050201" label:@"测量结果页>分享"];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"logo"]];
    if (imageArray)
    {
        NSString *paramsText = [NSString stringWithFormat:@"%@!%@",shareText,SHARE_URL];
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
