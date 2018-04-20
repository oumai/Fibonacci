//
//  AppDelegate.m
//  Fibonacci
//
//  Created by shipeiyuan on 16/8/19.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "AppDelegate.h"
#import "KMDataManager.h"
#import "HTTPTool+BATDomainAPI.h"//获取域名
#import "AppDelegate+BATShare.h"
#import "AppDelegate+BATVersion.h"
#import "HTTPTool+HeartDataRequst.h"

#import "NewViewController.h"
#import "KMTools+DeviceCategory.h"//设备信息
#import "CoreCameraDetection.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize rootViewController = _rootViewController;
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"ImageResolutionHeight"]) {
        [KMTools saveDeviceInfo];
    }
    
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    _window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UIStoryboard *sboard = [KMTools getStoryboardInstance];
    

    NewViewController *_mainController = [sboard instantiateViewControllerWithIdentifier:@"NewViewController"];

    _rootViewController = [[RootViewController alloc] initWithRootViewController:_mainController];
    self.window.rootViewController = _rootViewController;

    [[KMDataManager sharedDatabaseInstance] updateDataBase];
    //获取最新的域名
    [HTTPTool getDomain];
    
    //初始化shareSDK
    [self bat_initShare];
    
    // App ID: 在 App Analytics 创建应用后，进入数据报表页中，在“系统设置”-“编辑应用”页面里查看App ID。
    // 渠道 ID: 是渠道标识符，可通过不同渠道单独追踪数据。
    [TalkingData setVersionWithCode:[KMTools getVersionNumber] name:[KMTools getAppDisplayName]];
    [TalkingData sessionStarted:@"C2AC7C6674CC48C894DB37DDEAB93531" withChannelId:@"app store"];

//    if (IS_IOS9) {
//        [self configShortCutItems];
//    }
//#warning
    [KMTools updateAppStoreVersion];
    [HTTPTool getPhysicalRecoidCompletion:^(BOOL success,NSMutableDictionary * dict, NSError *error){
    }];
//    if (launchOptions[@"UIApplicationLaunchOptionsShortcutItemKey"] == nil) {
//        return YES;
//    } else {
//        return NO;
//    }
    
    return YES;
}

- (void)bat_setXcodeColorsConfigration {
    //开启使用 XcodeColors
    setenv("XcodeColors", "YES", 0);
    //检测
    char *xcode_colors = getenv("XcodeColors");
    if (xcode_colors && (strcmp(xcode_colors, "YES") == 0))
    {
        // XcodeColors is installed and enabled!
        NSLog(@"XcodeColors is installed and enabled");
    }
    //开启DDLog 颜色
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:DDLogFlagVerbose];
    
    //配置DDLog
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
    
    
    NSLog(@"NSLog");
    DDLogVerbose(@"Verbose");
    DDLogDebug(@"Debug");
    DDLogWarn(@"Warn");
    DDLogError(@"Error");
    
    DDLogError(@"%@",NSHomeDirectory());
}

/** 创建shortcutItems */
- (void)configShortCutItems {
    NSMutableArray *shortcutItems = [NSMutableArray array];
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeLove];
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeFavorite];
    UIMutableApplicationShortcutItem *item1 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"1" localizedTitle:@"心率测量" localizedSubtitle:nil icon:icon1 userInfo:nil];
    UIMutableApplicationShortcutItem *item2 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"2" localizedTitle:@"血压测量" localizedSubtitle:nil icon:icon2 userInfo:nil];
    [shortcutItems addObject:item1];
    [shortcutItems addObject:item2];
    [[UIApplication sharedApplication] setShortcutItems:shortcutItems];
}

/** 处理shortcutItem */
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    switch (shortcutItem.type.integerValue) {
        case 1:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"touchGotoVc" object:self userInfo:@{@"type":@"1"}];
        }
            break;
        case 2:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"touchGotoVc" object:self userInfo:@{@"type":@"2"}];
        }   break;
        default:
            break;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if ([[CoreCameraDetection sharedCoreCameraDetection] cameraRunningStatus] && [KMTools getAuthStatus:self.rootViewController]) {
        [[CoreCameraDetection sharedCoreCameraDetection] sendErrorCount:2];
    }
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [HTTPTool getPhysicalRecoidCompletion:^(BOOL success,NSMutableDictionary * dict, NSError *error){
//    }];

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - iOS8 UILocalNotification
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //成功注册registerUserNotificationSettings:后，回调的方法
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //收到本地推送消息后调用的方法
    UIApplicationState state = application.applicationState;
    if (state == UIApplicationStateActive) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"记得吃药哦" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:sureAction];
        [_rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    completionHandler();

}

#pragma mark iOS10 UILocalNotification
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    NSLog(@"iOS10 前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
    
}
@end
