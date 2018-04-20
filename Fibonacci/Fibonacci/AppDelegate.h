//
//  AppDelegate.h
//  Fibonacci
//
//  Created by shipeiyuan on 16/8/19.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//
//com.KMBATHalthyManage.app
//com.PhysicalExamination.Enterprise.app

/*
 康美小管家_企业账号 c67a9718b94cf1daebc0b63a196a34a6
 康美小管家_公司账号 92f5f3003561381a390fbcf9a084ac1e
 */
#import <UIKit/UIKit.h>
#import "RootViewController.h"
@import UserNotifications;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootViewController *rootViewController;

@end

