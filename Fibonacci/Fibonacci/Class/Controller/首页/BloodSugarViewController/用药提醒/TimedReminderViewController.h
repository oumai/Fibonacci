//
//  TimedReminderViewController.h
//  Fibonacci
//
//  Created by shipeiyuan on 2016/12/21.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReminderViewController.h"
#import "MZTimerLabel.h"
@import UserNotifications;

@import EventKit;
@interface TimedReminderViewController : KMUIViewController<UITableViewDelegate,UITableViewDataSource,ReminderDelegate,MZTimerLabelDelegate,UNUserNotificationCenterDelegate>
{
    UITableView *myTableView;
    NSArray *titleArray;
    NSMutableArray *modelArray;
    NSTimeInterval notiftyInterval;
    MZTimerLabel *theVideoMZTimer;
    BOOL isNotification;
}
@end
