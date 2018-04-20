//
//  EyeTestResultViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/22.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "EyeTestResultViewController.h"
#import "ManuallyEnteredViewController.h"
#import "ShareCustom.h"
#import "AppDelegate+BATShare.h"
@interface EyeTestResultViewController ()

@end

@implementation EyeTestResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视力测试结果";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[KMDataManager sharedDatabaseInstance] insertVisionDataModelFromNumber:[NSNumber numberWithFloat:self.value]];
    });
    [self initResultData];
    [self setHudString];
    // Do any additional setup after loading the view.
}

- (void)initResultData
{
    NSString *labelText = @"";
    
    if (self.value <4.7)
    {
        labelText = [NSString stringWithFormat:@"%.1f近视",self.value];
    }
    else
    {
        labelText = [NSString stringWithFormat:@"%.1f正常",self.value];
    }
    int a = 50;
    int b = 20;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    [paragraphStyle setParagraphSpacing:10];//调整行间距
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:a] range:NSMakeRange(0, 3)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:b] range:NSMakeRange(3, labelText.length - 3)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, labelText.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(219, 155, 57) range:NSMakeRange(0, 3)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:AppFontColor range:NSMakeRange(3, labelText.length - 3)];
    
    hudLabel.attributedText = attributedString;
    
//    CALayer *lineLayer = [CALayer layer];
//    lineLayer.frame = CGRectMake( 0, CGRectGetMaxY(hudLabel.frame)+10, MainScreenWidth, 1);
//    lineLayer.backgroundColor = [RGB(220, 220, 220) CGColor];
//    [self.view.layer addSublayer:lineLayer];
    
    textLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat buttonH = 50;
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(MainScreenWidth/3, CGRectGetMaxY(textLabel.frame)+(iPhone5?10:50), MainScreenWidth/3, buttonH);
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
    
    UILabel *resultHUDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainScreenHeight-40, MainScreenWidth, 40)];
    resultHUDLabel.font = [UIFont fontWithName:AppFontHelvetica size:13];
    resultHUDLabel.textAlignment = NSTextAlignmentCenter;
    resultHUDLabel.textColor = AppFontGrayColor;
    resultHUDLabel.numberOfLines = 2;
    resultHUDLabel.text = @"数据可能会存在一定范围的误差,测量结果仅供参考";
    [self.view addSubview:resultHUDLabel];
}

- (void)setHudString
{
    NSString *detailedText = @"";
    NSDictionary *dic = @{@"4.0":@"650", @"4.1":@"550~600", @"4.2":@"500", @"4.3":@"450", @"4.4":@"400", @"4.5":@"300~450", @"4.6":@"250", @"4.7":@"200", @"4.8":@"150", @"4.9":@"100" };
    float value = self.value;
    if (value < 4.0) {
        detailedText =  [NSString stringWithFormat:@"您的视力是%.1f,请佩戴眼镜",self.value];
    }
    else if(value >= 5.0)
    {
        detailedText =  [NSString stringWithFormat:@"您的视力是%.1f,请继续爱护您的眼睛",self.value];
    }
    else
    {
//        NSNumber *number = [NSNumber numberWithFloat:self.value];
        NSString *valueString = [NSString stringWithFormat:@"%.1f",self.value];
        detailedText =  [NSString stringWithFormat:@"您的视力是%.1f,近视%@度",value,dic[valueString]];
    }
    textLabel.textColor = AppFontColor;
    textLabel.text = detailedText;
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
    helpViewController.enteredType = EEnteredVisionDataType;
    [self.navigationController pushViewController:helpViewController animated:YES];
}

-(void)shareButton:(UIButton*)button
{
    [TalkingData trackEvent:@"21000050101" label:@"测量结果页>分享"];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"logo"]];
    if (imageArray)
    {
        NSString *paramsText = [NSString stringWithFormat:@"%@ %@",textLabel.text,SHARE_URL];
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
