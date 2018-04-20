//
//  BATMacro.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/8/15.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#ifndef BATMacro_h
#define BATMacro_h

//引入地区信息
#import "BATLocalDataSourceMacro.h"

//引入通知宏定义
#import "BATNotificationMacro.h"

//引入公用枚举定义
#import "BATEnumMacro.h"

#define ServiceName @"com.KMBATHalthyManage.app"    //保存密码的标示
#define KEY_LOGIN_TOKEN @"Token"                    //登录TOKEN
#define KEY_LOGIN_NAME  @"LOGIN_NAME"               //登录名key
#define KEY_INSULINNAME_TARRAY @"InsulinNameArray"  //胰岛素常用药品
#define KEY_REMINDER_ARRAY @"REMINDER_ARRAY"        //血糖定时提醒
#define KEY_PHYSICALRECORD_DIC @"PhysicalRecord_Dic"    //网络医院体检数据记录

//网络
#define BASE_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"appdominUrl"]//总域名
#define BASE_LOGIN_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"appLoginUrl"]//登录域名
#define BASE_NOTAPI_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"appdominNotApiUrl"]//web域名

#define SHARE_URL  [NSString stringWithFormat:@"%@/app/shareindex",BASE_NOTAPI_URL]//分享地址
#define APPSTORE_URL @"https://itunes.apple.com/cn/app/kang-mei-xiao-guan-jia/id1169968028?l=zh&mt=8"
#define CODESHARE_URL  [NSString stringWithFormat:@"%@/app/shareindex",BASE_NOTAPI_URL]//分享地址


#define LOCAL_TOKEN [[NSUserDefaults standardUserDefaults] valueForKey:@"Token"]//存入本地的token

//登录
#define LOGIN_STATION [[NSUserDefaults standardUserDefaults] boolForKey:@"LoginStation"]//登录状态
#define SET_LOGIN_STATION(bool) [[NSUserDefaults standardUserDefaults] setBool:bool forKey:@"LoginStation"];[[NSUserDefaults standardUserDefaults] synchronize];//改变登录状态
#define PRESENT_LOGIN_VC [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[BATLoginViewController new]] animated:YES completion:nil];//弹出登录界面
#define GET_PHYSICALRECOID [[NSUserDefaults standardUserDefaults] valueForKey: KEY_PHYSICALRECORD_DIC ]//获取网络医院体检数据Dic

//颜色
//#define BASE_COLOR [UIColor colorWithRed:69.0/255.0  green:160.0/255.0   blue:240.0/255.0  alpha:1.0]
#define BASE_COLOR UIColorFromHEX(0X1579f1, 1)

#define BASE_BACKGROUND_COLOR [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0]

#define kAllTextGrayColor [UIColor colorWithRed:133.0 / 255 green:138.0 / 255 blue:142.0 / 255 alpha:1.0]

//个人信息
#define PERSON_INFO [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"]]

//登录信息
#define LOGIN_INFO [NSKeyedUnarchiver unarchiveObjectWithFile: [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserLogin.data"]]

#endif /* BATMacro_h */
