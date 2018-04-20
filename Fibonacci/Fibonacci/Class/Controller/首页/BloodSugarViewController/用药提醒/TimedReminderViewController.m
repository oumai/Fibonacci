//
//  TimedReminderViewController.m
//  Fibonacci
//
//  Created by shipeiyuan on 2016/12/21.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "TimedReminderViewController.h"
#import "ReminderViewController.h"
#import "ReminderModel.h"
#import "MZTimerLabel.h"
#import "AppDelegate.h"
@interface TimedReminderViewController ()
@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic, strong) EKCalendar *calendar;
@property (nonatomic) BOOL isAccessToEventStoreGranted;
@property (strong, nonatomic) NSMutableArray *todoItems;
@property (copy, nonatomic) NSArray *reminders;
@end

#define CELLHEIGHT 45.0

typedef void(^HasNotifty)(BOOL have);

@implementation TimedReminderViewController
- (void)dealloc
{
    theVideoMZTimer.delegate = nil;
    theVideoMZTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    self.title = @"定时提醒";
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchReminders) name:EKEventStoreChangedNotification object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initTableViewData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self requestLocalNotification];
    [self getEventAuthorized];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableViewData
{
    if ([titleArray count]>0)
    {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults.dictionaryRepresentation.allKeys containsObject: KEY_REMINDER_ARRAY])
    {
        [self getReminderData];
    }
    else
    {
        modelArray = [NSMutableArray new];
    }
    titleArray = @[@"血糖监控",@"餐后2小时提醒",@"用药提醒"];
    CGFloat minY = 0;
    if (self.navigationController.navigationBar.translucent&&!self.extendedLayoutIncludesOpaqueBars) {
        minY = kStatusAndNavHeight;
    }

    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, minY, MainScreenWidth, MainScreenHeight - minY)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.backgroundView = [[UIView alloc] init];
    myTableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTableView];
}

#pragma mark 获取推送权限
- (void)requestLocalNotification
{
    if(IS_IOS10)
    {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if(granted)
                                  {
                                      NSLog(@"授权成功");
                                      isNotification = YES;
                                  }
                                  else
                                  {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"此功能功能需要获取通知权限" message:@"请开启权限：设置->康美小管家->通知" preferredStyle:UIAlertControllerStyleAlert];
                                          UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                              [self.navigationController popViewControllerAnimated:YES];
                                              dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.3*NSEC_PER_SEC);
                                              dispatch_after(time, dispatch_get_main_queue(), ^{
                                                  dispatch_async(dispatch_get_main_queue(), ^(){
                                                      //跳转界面
                                                      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                  });
                                              });
                                          }];
                                          [alertController addAction:sureAction];
                                          UIAlertAction *canleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                                          [alertController addAction:canleAction];
                                          [self presentViewController:alertController animated:YES completion:nil];
                                      });
                                  }
                              }];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIUserNotificationType types = UIUserNotificationTypeAlert|UIUserNotificationTypeSound;
            UIUserNotificationSettings *mySettings =[UIUserNotificationSettings settingsForTypes:types categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
        });

        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types)
        {
            isNotification = YES;
        }
        else
        {
            isNotification = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"此功能功能需要获取通知权限" message:@"请开启权限：设置->康美小管家->通知" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self.navigationController popViewControllerAnimated:YES];
                    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.3*NSEC_PER_SEC);
                    dispatch_after(time, dispatch_get_main_queue(), ^{
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            //跳转界面
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                        });
                    });
                }];
                [alertController addAction:sureAction];
                UIAlertAction *canleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:canleAction];
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [modelArray count]+ [titleArray count]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%li%li", [indexPath section], [indexPath row]];//以indexPath来唯一确定cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor clearColor];
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, CELLHEIGHT)];
        titlelabel.font = [UIFont fontWithName:@"Helvetica-Light" size: 14];
        titlelabel.tag = 100;
        titlelabel.textColor = AppFontColor;
        [cell.contentView addSubview:titlelabel];
        
        UILabel *rigthLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth-180, 2, 150, CELLHEIGHT-4)];
        rigthLabel.font = [UIFont fontWithName:@"Helvetica-Light" size: 15];
        rigthLabel.tag = 101;
        rigthLabel.textAlignment = NSTextAlignmentRight;
        rigthLabel.textColor = AppFontYellowColor;
        rigthLabel.text = @"点击开启";
        rigthLabel.hidden = YES;
        [cell.contentView addSubview:rigthLabel];

        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, MainScreenWidth, CELLHEIGHT);
        [button setTitle: @"添加更多用药次数" forState:UIControlStateNormal];
        [button setTitleColor: AppFontGrayColor forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"addbutton"] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        button.titleLabel.font = [UIFont fontWithName:AppFontHelvetica size:12];
        [button addTarget:self action:@selector(addReminder) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 102;
        [cell.contentView addSubview:button];
        
        UIImageView *remindIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth-50, (CELLHEIGHT-25)/2, 25, 25)];
        remindIcon.image = [UIImage imageNamed:@"remind"];
        remindIcon.hidden = YES;
        remindIcon.tag = 103;
        [cell.contentView addSubview:remindIcon];

    }

    UILabel *label = [cell.contentView viewWithTag: 100];
    label.text = @"";
    UILabel *rigthLabel = [cell.contentView viewWithTag: 101];
    UIView *button = [cell.contentView viewWithTag: 102];
    UIView *imageView = [cell.contentView viewWithTag: 103];
    button.hidden = YES;
    imageView.hidden = YES;
    NSInteger dataCount = [titleArray count] + [modelArray count];
    if ([titleArray count]>indexPath.row)
    {
        label.text = titleArray[indexPath.row];
    }
    if (indexPath.row == 0 || indexPath.row == 2)
    {
        label.textColor = AppFontGrayColor;
        cell.backgroundColor = RGBA(21, 34, 100, 0.3);
    }
    else if (indexPath.row == dataCount)
    {
        button.hidden =NO;
    }
    else if (indexPath.row > [titleArray count]-1 && indexPath.row < dataCount)
    {
        ReminderModel *model = modelArray[indexPath.row-[titleArray count]];
        NSArray *array = [model.name componentsSeparatedByString:@" "];
        label.text = array[0];
        if (!model.isCompleted) {
            imageView.hidden = !model.isReminder;
        }
        else
        {
            imageView.hidden = YES;
        }
    }
    
    if (indexPath.row == 1)
    {
        rigthLabel.hidden = NO;
        [self isHasNotifty:^(BOOL have)
         {
             if (have) {
                 NSLog(@"发现一个");
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (!theVideoMZTimer)
                     {
                         theVideoMZTimer = [[MZTimerLabel alloc] initWithLabel:rigthLabel andTimerType:MZTimerLabelTypeTimer];
                     }
                     [theVideoMZTimer setCountDownTime:notiftyInterval];
                     theVideoMZTimer.delegate = self;
                     [theVideoMZTimer setTimeFormat:@"HH:mm:ss"];
                     [theVideoMZTimer start];
                 });
             }
             else
             {
                 NSLog(@"啥都没有");
                 dispatch_async(dispatch_get_main_queue(), ^{
                     theVideoMZTimer.delegate = nil;
                     [theVideoMZTimer removeFromSuperview];
                     theVideoMZTimer = nil;
                     rigthLabel.text = @"点击开启";
                 });
             }
         }];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 下面这几行代码是用来设置cell的上下行线的位置
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row >2) {
        UIStoryboard *sboard = [KMTools getStoryboardInstance];
        ReminderViewController *bloodSugarViewController = [sboard instantiateViewControllerWithIdentifier:@"ReminderViewController"];
        bloodSugarViewController.delegate = self;
        bloodSugarViewController.model = modelArray[indexPath.row-3];
        [self.navigationController pushViewController:bloodSugarViewController animated:YES];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self isHasNotifty:^(BOOL have)
             {
                 if (have)
                 {
                     NSLog(@"删除");
                     [self removeNotifity];
                 }
                 else
                 {
                     NSLog(@"添加");
                     [self addNotifity];
                 }
             }];
        });
    }
}

#pragma mark - ReminderDelegate
- (void)ReminderViewController:(ReminderViewController *)reminderViewController deleteModel:(ReminderModel *)model
{
    if ([modelArray containsObject:model])
    {
        NSUInteger idx = [modelArray indexOfObject:model];
        [modelArray removeObjectAtIndex:idx];
    }
    [self saveReminderData];
    [myTableView reloadData];
}

- (void)ReminderViewController:(ReminderViewController *)reminderViewController changeModel:(ReminderModel *)model
{
    if ([modelArray containsObject:model]) {
        NSUInteger idx = [modelArray indexOfObject:model];
        [modelArray removeObjectAtIndex:idx];
        [modelArray insertObject:model atIndex:idx];
    }
    else
    {
        [modelArray addObject:model];
    }

    [self saveReminderData];
    [myTableView reloadData];

}

- (void)saveReminderData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([modelArray count] > 0) {
        NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:modelArray];
        [defaults setObject:myEncodedObject forKey: KEY_REMINDER_ARRAY];
    }
    else
    {
        [defaults removeObjectForKey: KEY_REMINDER_ARRAY];
    }
    [defaults synchronize];
    
    [self removeAllReminder];
    [modelArray enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         ReminderModel *model = (ReminderModel *)obj;
         [self addReminderForToDoItem:model];
         NSLog(@"%@",model.name);
     }];
}

- (void)getReminderData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults.dictionaryRepresentation.allKeys containsObject: KEY_REMINDER_ARRAY])
    {
        NSData *myEncodedObject = [defaults objectForKey: KEY_REMINDER_ARRAY];
        modelArray = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    }
    
}
#pragma mark - Action
- (void)addReminder
{
    UIStoryboard *sboard = [KMTools getStoryboardInstance];
    ReminderViewController *bloodSugarViewController = [sboard instantiateViewControllerWithIdentifier:@"ReminderViewController"];
    bloodSugarViewController.delegate = self;
    [self.navigationController pushViewController:bloodSugarViewController animated:YES];
}

-(void)removeAllReminder
{
    NSPredicate *predicate = [self.eventStore predicateForRemindersInCalendars:@[self.calendar]];
    
    [self.eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders)
     {
         [reminders enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop)
          {
              EKReminder *reminder = (EKReminder *)obj;
              NSError *removeError = nil;
              if ([self.eventStore removeReminder:reminder commit:YES error:&removeError])
              {
                  NSLog(@"Successfully created the recurring event.");
              } else {
                  NSLog(@"Failed to create the recurring event %@", removeError);
              }
          }];
     }];
}

#pragma mark - Notifity
- (void)addNotifity
{
    if (!isNotification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"此功能功能需要获取通知权限" message:@"请开启权限：设置->康美小管家->通知" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self.navigationController popViewControllerAnimated:YES];
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.3*NSEC_PER_SEC);
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    });
                });
            }];
            [alertController addAction:sureAction];
            UIAlertAction *canleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:canleAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"chifanle" forKey:@"key"];
#ifdef DEBUG
    NSTimeInterval timeInterval = 10;
#else
    NSTimeInterval timeInterval = 7200;
#endif
    if (IS_IOS10)
    {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        AppDelegate *delegate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
        center.delegate = delegate;
        
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        content.title = [NSString localizedUserNotificationStringForKey:@"温馨提示" arguments:nil];
        content.body = [NSString localizedUserNotificationStringForKey:@"记得吃药哦"
                                                             arguments:nil];
        content.sound = [UNNotificationSound defaultSound];
        content.userInfo = dic;
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:timeInterval repeats:NO];
        NSDate *eventStartDate = [[NSDate date] dateByAddingTimeInterval:timeInterval];
        NSTimeInterval fire= [eventStartDate timeIntervalSince1970];
        NSString *str = [NSString stringWithFormat:@"%f",fire];
//        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComp repeats:NO];
        
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:str
                                                                              content:content trigger:trigger];
        //添加推送成功后的处理！
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [myTableView reloadData];
            });
        }];
    }
    else
    {
        UIUserNotificationType types = UIUserNotificationTypeAlert|UIUserNotificationTypeSound;
        UIUserNotificationSettings *mySettings =[UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
        
        UILocalNotification *notifity=[[UILocalNotification alloc] init];
        notifity.fireDate= [[NSDate date] dateByAddingTimeInterval:timeInterval];
        notifity.timeZone = [NSTimeZone systemTimeZone];
        notifity.alertTitle = @"温馨提示";
        notifity.alertBody=@"记得吃药哦";
        notifity.soundName = UILocalNotificationDefaultSoundName;
        notifity.alertAction = @"查看";
        notifity.userInfo = dic;
        [[UIApplication sharedApplication] scheduleLocalNotification:notifity];
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 *NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [myTableView reloadData];

        });
    }
}

-(void)removeNotifity
{
    if (IS_IOS10)
    {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        [center removeAllDeliveredNotifications];
        [center removeAllPendingNotificationRequests];
    }
    else
    {
        NSArray * array = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification * loc in array) {
            if ([[loc.userInfo objectForKey:@"key"] isEqualToString:@"chifanle"]) {
                [[UIApplication sharedApplication] cancelLocalNotification:loc];
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [myTableView reloadData];
    });
    
}

-(void)isHasNotifty:(HasNotifty)complete
{
    __block BOOL isHave = NO;
    if (IS_IOS10)
    {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests)
        {
            if ([requests count] > 0)
            {
                for (UNNotificationRequest * loc in requests)
                {
                    if ([[loc.content.userInfo objectForKey:@"key"] isEqualToString:@"chifanle"])
                    {
                        NSTimeInterval fire= [loc.identifier doubleValue];;
                        NSTimeInterval  now = [[NSDate date] timeIntervalSince1970];
                        notiftyInterval = fire - now;
                        isHave = YES;
                    }
                }
            }
            if (complete)
            {
                complete(isHave);
            }
        }];
    }
    else
    {
        NSArray * array = [[UIApplication sharedApplication] scheduledLocalNotifications];
        if ([array count] > 0)
        {
            for (UILocalNotification * loc in array)
            {
                if ([[loc.userInfo objectForKey:@"key"] isEqualToString:@"chifanle"])
                {
                    NSTimeInterval  fire = [loc.fireDate timeIntervalSince1970];
                    NSTimeInterval  now = [[NSDate date] timeIntervalSince1970];
                    notiftyInterval = fire - now;
                    isHave = YES;
                }
            }
        }
        if (complete) {
            complete(isHave);
        }
    }
}

-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime
{
    timerLabel.delegate = nil;
    timerLabel = nil;
    [myTableView reloadData];
}

#pragma mark -
#pragma mark - EKEventStore
- (void)getEventAuthorized {
    EKAuthorizationStatus EKstatus = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeReminder];
    switch (EKstatus) {
        case EKAuthorizationStatusAuthorized:
            self.isAccessToEventStoreGranted = YES;
            [self fetchReminders];
            NSLog(@"同意");
            break;
        case EKAuthorizationStatusNotDetermined:
        {
            EKEventStore *store = [[EKEventStore alloc]init];
            [store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
                self.isAccessToEventStoreGranted = granted;
                [self fetchReminders];
                if (granted) {
                    NSLog(@"Authorized");
                }else{
                    NSLog(@"Denied or Restricted");
                }
            }];
            NSLog(@"不确定");
        }
            break;
        case EKAuthorizationStatusRestricted:
        case EKAuthorizationStatusDenied:
        {
            NSLog(@"受限制");
            self.isAccessToEventStoreGranted = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"此功能需要获取提醒事项权限" message:@"请开启权限：设置->康美小管家->提醒事项" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self.navigationController popViewControllerAnimated:YES];
                    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.3*NSEC_PER_SEC);
                    dispatch_after(time, dispatch_get_main_queue(), ^{
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                        });
                    });
                }];
                [alertController addAction:sureAction];
                UIAlertAction *canleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:canleAction];
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
            break;
        default:
            break;
    }
}

- (EKEventStore *)eventStore {
    if (!_eventStore) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return _eventStore;
}

- (EKCalendar *)calendar {
    if (!_calendar) {
        NSArray *calendars = [self.eventStore calendarsForEntityType:EKEntityTypeReminder];
        NSString *calendarTitle = @"用药提醒";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", calendarTitle];
        NSArray *filtered = [calendars filteredArrayUsingPredicate:predicate];
        if ([filtered count])
        {
            _calendar = [filtered firstObject];
        }
        else
        {
            _calendar = [EKCalendar calendarForEntityType:EKEntityTypeReminder eventStore:self.eventStore];
            _calendar.title = @"用药提醒";
            _calendar.source = self.eventStore.defaultCalendarForNewReminders.source;
            _calendar.CGColor = AppColor.CGColor;
            NSError *calendarErr = nil;
            BOOL calendarSuccess = [self.eventStore saveCalendar:_calendar commit:YES error:&calendarErr];
            if (!calendarSuccess) {
            }
        }
    }
    return _calendar;
}

- (void)addReminderForToDoItem:(ReminderModel *)model {
    if (!self.isAccessToEventStoreGranted || !model.isReminder)
        return;
    EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
    reminder.title = model.name;
    reminder.calendar = self.calendar;
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone systemTimeZone]];
    NSInteger flags = NSCalendarUnitYear | NSCalendarUnitMonth |
    NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    
    NSDate * startDate = [KMTools getDateFromString:model.date];
    NSDateComponents* dateComp = [cal components:flags fromDate: startDate];
    dateComp.timeZone = [NSTimeZone systemTimeZone];
    reminder.startDateComponents = dateComp; //开始时间
    reminder.dueDateComponents = dateComp; //到期时间
    
    [model.doseTimeArray enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         DoseTime *dose = (DoseTime *)obj;
         NSArray *timerArray = [dose.time componentsSeparatedByString:@":"];
         NSString *hourString = timerArray[0];
         NSString *minuteString = timerArray[1];
         NSInteger hour = [hourString integerValue];
         NSInteger minute = [minuteString integerValue];
         NSTimeInterval ti = hour*3600+minute*60;
         NSDate *eventStartDate = [startDate dateByAddingTimeInterval:ti];
         EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:eventStartDate]; //添加一个闹钟
         [reminder addAlarm:alarm];
         
         reminder.dueDateComponents = nil;
         NSDateComponents* dateComp = [cal components:flags fromDate: eventStartDate];
         dateComp.timeZone = [NSTimeZone systemTimeZone];
         reminder.dueDateComponents = dateComp; //到期时间
         NSLog(@"%@",dose.time);
     }];
    
    reminder.notes = model.note;
    
    NSError *error = nil;
    BOOL success = [self.eventStore saveReminder:reminder commit:YES error:&error];
    if (!success) {
        NSLog(@"闹钟添加失败");
    }
    NSTimeInterval NSOneYear = 24 * 60 * 60;
    __block NSTimeInterval daySum = 0;
    NSMutableArray *arrayWeek = [NSMutableArray new];
    [model.weekArray enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         NSNumber *number = (NSNumber *)obj;
         BOOL isBool = [number boolValue];
         if (isBool ) {
             daySum ++;
             idx = idx +2;
             if (idx > 7) {
                 idx = idx - 7;
             }
             EKRecurrenceDayOfWeek *daysOfWeek = [EKRecurrenceDayOfWeek dayOfWeek:idx];
             [arrayWeek addObject:daysOfWeek];
         }
     }];
    NSOneYear = NSOneYear *daySum;
    NSDate *oneYearFromNow = [startDate dateByAddingTimeInterval:NSOneYear];
    EKRecurrenceEnd *recurringEnd = [EKRecurrenceEnd recurrenceEndWithEndDate:oneYearFromNow];
    EKRecurrenceRule *recurringRule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1 daysOfTheWeek:arrayWeek daysOfTheMonth:nil monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:recurringEnd];
    reminder.recurrenceRules =  [[NSArray alloc] initWithObjects:recurringRule, nil];
    NSError *saveError = nil;
    if ([self.eventStore saveReminder:reminder commit:YES error:&saveError])
    {
        NSLog(@"Successfully created the recurring event.");
    } else {
        NSLog(@"Failed to create the recurring event %@", saveError);
    }
}

- (void)fetchReminders {
    if (self.isAccessToEventStoreGranted)
    {
        NSPredicate *predicate = [self.eventStore predicateForRemindersInCalendars:@[self.calendar]];
        
         [self.eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders)
         {
             self.reminders = reminders;
             if ([self.reminders count] > 0 && [reminders count] >0)
             {
                 [modelArray enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop)
                  {
                      ReminderModel *model = (ReminderModel *)obj;
                      model.isReminder = NO;
                      [self.reminders enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop)
                       {
                           EKReminder *reminder = (EKReminder *)obj;
                           if ([model.name isEqualToString:reminder.title]) {
                               model.isReminder = YES;;
                               model.isCompleted = reminder.completed;
                               *stop = YES;
                           }
                       }];
                  }];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [myTableView reloadData];
                 });
             }
 
         }];
    }
}

- (BOOL)itemHasReminder:(NSString *)item {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", item];
    NSArray *filtered = [self.reminders filteredArrayUsingPredicate:predicate];
    return (self.isAccessToEventStoreGranted && [filtered count]);
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
