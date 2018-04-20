//
//  BATAppDelegate+BATShare.m
//  HealthBAT_Pro
//
//  Created by four on 16/9/12.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "AppDelegate+BATShare.h"

#define UMShareAppKey @"572312db67e58e235b0007e2"

@implementation AppDelegate (BATShare)

- (void)bat_initShare{
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    
    [ShareSDK registerActivePlatforms:@[ @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformSubTypeWechatTimeline),
                                        @(SSDKPlatformTypeQQ),
                                        @(SSDKPlatformTypeSinaWeibo)]
                             onImport:^(SSDKPlatformType platformType)
                                 {
                                     switch (platformType)
                                     {
                                         case SSDKPlatformTypeWechat:
                                             [ShareSDKConnector connectWeChat:[WXApi class]];
                                             break;
                                         case SSDKPlatformSubTypeWechatTimeline:
                                             [ShareSDKConnector connectWeChat:[WXApi class]];
                                             break;
                                         case SSDKPlatformTypeQQ:
                                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                             break;
                                         case SSDKPlatformTypeSinaWeibo:
                                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                             break;
                                         default:
                                             break;
                                     }
                                 }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx50921d49822d6f4c"
                                       appSecret:@"56f9bcb45d097d783b8d4667e5b9abe6"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105667925"
                                      appKey:@"3XcDPEOTSTsrSWer"
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"1080661342"
                                           appSecret:@"957caf8332f7a99222b5769108637ab0"
                                         redirectUri:@"http://www.jkbat.com"
                                            authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
                  
   
}


- (void)bat_initUMShare{
//    //友盟分享
//    [UMSocialData setAppKey:UMShareAppKey];
//    //设置QQAppId、appSecret，分享url
//    [UMSocialQQHandler setQQWithAppId:@"1105372508" appKey:@"CvEgfA6dccBHqI3B" url:@"http://www.jkbat.com"];
//    //设置微信AppId、appSecret，分享url
//    [UMSocialWechatHandler setWXAppId:@"wxe604d9160748549a" appSecret:@"3236b4c913005ab48142ea443f65270d" url:@"http://www.jkbat.com"];
//    //设置新浪微博AppId、appSecret，分享url
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2990270720" secret:@"97e6b861798dd15947f293c2687a7e80" RedirectURL:@"http://www.jkbat.com"];
}

@end
