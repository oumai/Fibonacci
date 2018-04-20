//
//  CommonMacro.h
//  PalmDoctor
//
//  Created by Edward on 15/8/27.
//  Copyright (c) 2015年 km. All rights reserved.
//

#ifndef Fibonacci_CommonMacro_h

#define App_Db_Name @"KMPhysical.db"
#import "WeakDefine.h"
#import "CocoaLumberjack.h"
#ifdef RELEASE
static const DDLogLevel ddLogLevel = DDLogLevelOff;
#else
static const DDLogLevel ddLogLevel = DDLogLevelAll;
#endif

//定义屏幕的宽和高
#define MainScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define MainScreenHeight ([UIScreen mainScreen].bounds.size.height)

//定义导航栏的位置(默认状态栏,导航栏在iOS7后均为透明或半透明的,但在程序里设置为不透明)
#define kStatusBarHeight    [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavBarHeight       44
#define kStatusAndNavHeight  ([UIApplication sharedApplication].statusBarFrame.size.height + 44)
#define kTabbarHeight     (kStatusBarHeight>20?83:49) // 适配iPhone x 底栏高度

#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)568 ) < DBL_EPSILON)
#define IS_IPHONE_X (fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)812 ) < DBL_EPSILON)

#define isSimulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)

#define IS_IOS11 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 11)
#define IS_IOS10 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 10)
#define IS_IOS9 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 9)
#define IS_IOS8 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 8)
#define IS_IOS7 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 7)
#define IS_IOS6 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] == 6)

//小管家的App Store的ID
#define APPSTORE_ID @"1169968028"

//自定义rgb
#define RGB(a,b,c)      [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0]
#define RGBA(r, g, b, a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


//#warning 干净支持
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 10000
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//#ifdef IS_IOS10
//#define RGB(a,b,c)  [UIColor colorWithDisplayP3Red:a/255.0 green:b/255.0 blue:c/255.0 alpha: 1.0]
//#define RGBA(r, g, b, a)    [UIColor colorWithDisplayP3Red:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//#else
//#define RGB(a,b,c)      [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0]
//#define RGBA(r, g, b, a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//#endif

//#define AppColor        [UIColor colorWithRed:33.0/255.0  green:131.0/255.0  blue:245.0/255.0 alpha:1.0]
#define AppColor                RGB(33,131,245)
#define AppFontColor            RGB(66, 179, 255)
#define AppFontYellowColor      RGB(223, 169, 36)
#define AppFontGrayColor        RGB(152, 206, 243)
#define AppChartBGColor         RGB(13,187,132)
#define AppChartLineColor       RGB(255,234,0)
#define AppChartMaskLineColor   RGB(0,251,213)
#define LineColor               RGB(200,199,204)
#define ErrorText @"网络消化不良\n请检查您的网络哦"
#define AppFontHelvetica   @"Helvetica-Light"
//#define AppChartBGColor        [UIColor colorWithRed:13.0/255.0  green:187.0/255.0  blue:132.0/255.0 alpha:1.0]
//#define AppChartLineColor        [UIColor colorWithRed:255.0/255.0  green:234.0/255.0  blue:0.0/255.0 alpha:1.0]
//#define AppChartMaskLineColor        [UIColor colorWithRed:0.0/255.0  green:251.0/255.0  blue:213.0/255.0 alpha:1.0]
//#define LineColor		[UIColor colorWithRed:200.0/255.0  green:199.0/255.0  blue:204.0/255.0 alpha:1.0]

//通过设备型号定义设备的类型
#define iPhone3GS   (([[NSUserDefaults standardUserDefaults] integerForKey:@"ImageResolutionHeight"]) == 480?YES:NO)

#define iPhone4   (([[NSUserDefaults standardUserDefaults] integerForKey:@"ImageResolutionHeight"]) == 960?YES:NO)
#define iPhone5   (([[NSUserDefaults standardUserDefaults] integerForKey:@"ImageResolutionHeight"]) == 1136?YES:NO)
#define iPhone6   (([[NSUserDefaults standardUserDefaults] integerForKey:@"ImageResolutionHeight"]) == 1334?YES:NO)
#define iPhone6p  (([[NSUserDefaults standardUserDefaults] integerForKey:@"ImageResolutionHeight"]) == 2208?YES:NO)
#define iPhoneX   (([[NSUserDefaults standardUserDefaults] integerForKey:@"ImageResolutionHeight"]) == 2436?YES:NO)


//判断设备的软件版本
#define iPhoneSystemVersion ([UIDevice currentDevice].systemVersion.floatValue)

#define UIColorFromHEX(rgbValue,A)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:A]
#define Color_With_Hex(hexValue)    [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]

#endif
