//
//  BATAppDelegate+BATShare.h
//  HealthBAT_Pro
//
//  Created by four on 16/9/12.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "AppDelegate.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <MOBFoundation/MOBFoundation.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

///**
// 友盟分享
// */
//#import "UMSocial.h"
//#import "UMSocialQQHandler.h"
//#import "UMSocialWechatHandler.h"
//#import "UMSocialSinaSSOHandler.h"

@interface AppDelegate (BATShare)

/**
 *  初始化Share分享
 */
- (void)bat_initShare;

/**
 *  初始化友盟分享（暂时使用Share分享）
 */
-(void)bat_initUMShare;

@end
