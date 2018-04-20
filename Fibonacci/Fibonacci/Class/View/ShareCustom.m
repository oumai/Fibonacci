//
//  ShareCustom.m
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/10/14.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "ShareCustom.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <WeiboSDK.h>
@import QuartzCore;

//设备物理大小
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define SYSTEM_VERSION   [[UIDevice currentDevice].systemVersion floatValue]
//屏幕宽度相对iPhone6屏幕宽度的比例
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f
#define Share_Scale    kScreenHeight/3

@implementation ShareCustom

static id _publishContent;//类方法中的全局变量这样用（类型前面加static）

+(void)shareWithContent:(id)publishContent
{
    _publishContent = publishContent;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIImageView *blackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    blackView.userInteractionEnabled = YES;
    if (IS_IOS8) {
        UIVisualEffectView *visualEffect = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        visualEffect.frame = blackView.frame;
        visualEffect.alpha = 0;
        [blackView addSubview:visualEffect];
//        blackView.alpha = 0;
    }
    else
    {
        blackView.backgroundColor = UIColorFromHEX(00000, 0);
    }
    
    blackView.tag = 440;
    UITapGestureRecognizer *cancelGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goTapGesture:)];
    [blackView addGestureRecognizer:cancelGesture];
    [window addSubview:blackView];
    
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, Share_Scale-90)];
//    shareView.backgroundColor = RGB(246, 246, 246);
    shareView.backgroundColor = [UIColor whiteColor];
    shareView.alpha = 0.6;
    shareView.tag = 441;
    [window addSubview:shareView];
    
    CALayer *topLine =[CALayer layer];
    topLine.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;
    topLine.frame = CGRectMake(0, 0, kScreenWidth, 1);
    [shareView.layer addSublayer:topLine];
    
    CGFloat labelH = 45;
    if (kScreenHeight == 568) {
        labelH = 35;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(shareView.frame), labelH)];
    titleLabel.text = @"分享到";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15*KWidth_Scale];
    titleLabel.textColor = RGB(42, 42, 42);
    titleLabel.backgroundColor = [UIColor clearColor];
    [shareView addSubview:titleLabel];
    
    NSArray *btnImages = @[@"share_weChatfriends_icon", @"share_moments_icon", @"share_QQ_icon", @"share_weibo"];
    NSArray *btnTitles = @[@"微信", @"微信朋友圈", @"QQ好友", @"新浪微博"];
    CGFloat imageWidth = 55;
    CGFloat imageHeight = 55;
    CGFloat labelWidth = imageWidth +20;
    CGFloat labelHeight = 40;
    CGFloat width = (MainScreenWidth -4*labelWidth)/4;
    CGFloat viewHeight = imageHeight + labelHeight;
    CGFloat viewWidth = labelWidth;
    for (NSInteger i=0; i<[btnImages count]; i++)
    {
        UIView *btnView = [[UIView alloc] init];
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goTapGesture:)];
        [btnView addGestureRecognizer:tapGesture];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(10, 1, imageWidth, imageHeight)];
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, imageHeight, labelWidth, labelHeight)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"STHeitiTC-Light" size: 13];
        label.textColor = [UIColor blackColor];
        [btnView addSubview:imageView];
        [btnView addSubview:label];
        
        btnView.tag = i;
        btnView.frame = CGRectMake(width/2+(i%4)*width+((i%4)*labelWidth), 55+(i/4)*(viewWidth + 45), viewWidth, viewHeight);
        label.text = btnTitles[i];
        imageView.image = [UIImage imageNamed: btnImages[i]];
        [shareView addSubview:btnView];
        switch (i) {
            case 0:
            {
                btnView.tag = 997;
            }
                break;
            case 1:
            {
                btnView.tag = 23;
            }
                break;
            case 2:
            {
                btnView.tag = 998;
            }
                break;
            case 3:
            {
                btnView.tag = 1;
            }
                break;
                
            default:
                break;
        }
    }
    CGFloat labelCancelH = 60;
    if (kScreenHeight == 568) {
        labelCancelH = 40;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, labelCancelH)];
    label.text = @"取消";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:AppFontHelvetica size:16];
    label.textColor = RGB(51, 51, 51);
    label.backgroundColor = [UIColor whiteColor];
    label.alpha = 0.7;
    label.tag = 2016;
    label.userInteractionEnabled = YES;
    [window addSubview:label];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goTapGesture:)];
    [label addGestureRecognizer:tapGesture];
    
    CALayer *line =[CALayer layer];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;
    line.frame = CGRectMake(0, CGRectGetMinY(label.frame)-1, kScreenWidth, 1);
    [shareView.layer addSublayer:line];

    [UIView animateWithDuration:0.35f animations:^{
        shareView.frame = CGRectMake(0, kScreenHeight-Share_Scale, kScreenWidth, Share_Scale);
            } completion:^(BOOL finished) {
    }];
    [UIView animateWithDuration:0.35f animations:^{
        label.frame =  CGRectMake(0, kScreenHeight-labelCancelH, kScreenWidth, labelCancelH);
        if (!IS_IOS8)
        {
            blackView.backgroundColor = UIColorFromHEX(00000, 0.85);
        }
        else
        {
            for (UIView *elem  in blackView.subviews) {
                if ([elem isKindOfClass:[UIVisualEffectView class]]) {
                    UIVisualEffectView *view = (UIVisualEffectView *)elem;
                    view.alpha = 1;
                }
            }
            blackView.alpha = 1;
        }
        
    }];
}

+(void)goTapGesture:(UITapGestureRecognizer *)tap
{
    UITapGestureRecognizer *tempTap = (UITapGestureRecognizer *)tap;
    UIView *view = (UIView *)tempTap.view;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:440];
    UIView *shareView = [window viewWithTag:441];
    UIView *canleView = [window viewWithTag:2016];
    
    shareView.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.15f animations:^{
        shareView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, Share_Scale);
        blackView.alpha = 0;
        canleView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 40);
    } completion:^(BOOL finished) {
        [shareView removeFromSuperview];
        [blackView removeFromSuperview];
        [canleView removeFromSuperview];
        int shareType = 0;
        switch (view.tag) {
            case 997:
            {
                shareType = SSDKPlatformTypeWechat;
            }
                break;
                
            case 23:
            {
                shareType = SSDKPlatformSubTypeWechatTimeline;
            }
                break;
            case 998:
            {
                shareType = SSDKPlatformTypeQQ;
            }
                break;
            case 1:
            {
                shareType = SSDKPlatformTypeSinaWeibo;
            }
                break;
                
            default:
                break;
        }
        
//        NSLog(@"%i",shareType);
        if (view.tag != 2016 && view.tag != 440) {
            [ShareSDK share:shareType
                 parameters:_publishContent
             onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
             {
                 switch (state) {
                     case SSDKResponseStateSuccess:
                     {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                         message:nil
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil, nil];
                         [alert show];
                     }
                         break;
                     case SSDKResponseStateFail:
                     {
                         if (shareType==998&&![QQApiInterface isQQInstalled]) {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                             message:@"没有安装QQ"
                                                                            delegate:self
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil,nil];
                             [alert show];
                         }
                         else if ((shareType==997||shareType==23)&&![WXApi isWXAppInstalled])
                         {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                             message:@"没有安装微信"
                                                                            delegate:self
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil,nil];
                             [alert show];
                         }
//                         else if (shareType==23&&![WeiboSDK isWeiboAppInstalled])
//                         {
//                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                             message:@"没有安装微博"
//                                                                            delegate:self
//                                                                   cancelButtonTitle:@"确定"
//                                                                   otherButtonTitles:nil,nil];
//                             [alert show];
//                         }
                         else
                         {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@",error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil, nil];
                             [alert show];
                         }
                     }
                         break;
                         
                     default:
                         break;
                 }
             }];
        }

    }];
}
@end
