//
//  KMTools.h
//  PlamHospital
//
//  Created by 123 on 15/7/15.
//  Copyright (c) 2015年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>  //需要用到UIKit框架里的文件
@import AVFoundation;

//针对判断是否有网络需要的头文件
#import <CommonCrypto/CommonHMAC.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import <arpa/inet.h>

#import "GTMBase64.h"
#import <CommonCrypto/CommonCrypto.h>  

@interface KMTools : NSObject

//判断当前是否可以连接到网络
+ (BOOL)connectedToNetwork;

//消息提示框
+ (void)showAlertMessage:(NSString *)message;

//消息提示框(兼容iOS8以后)
+ (void)showAlertMessage:(NSString *)message cancel:(NSString *)cancal inViewController:(UIViewController *)viewController handler:(void (^)(UIAlertAction *action))handler;

//纯数字正则验证
+ (BOOL)isOnlyNumber:(NSString *)number;

//验证是否为数字或两位小数
+ (BOOL)isFloatNumber:(NSString *)number;

//正则表达式判断手机号
+ (BOOL)isPhoneNumber:(NSString *)phoneNumber;

//拨打电话
+ (void)callPhoneNumber:(NSString *)phoneNum inView:(UIView *)view;

//3DES加密与解密
+ (NSString *)TripleDES:(NSString *)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt encryptOrDecryptKey:(NSString *)encryptOrDecryptKey;

//3DES加密
+ (NSString*)encrypt:(NSString*)plainText;

//3DES解密方法
+ (NSString*)decrypt:(NSString*)encryptText;

//十六进制颜色字符串转uicolor
+ (UIColor *) colorWithHexString: (NSString *) hexString;

// 检查是否符合手机号码格式
+ (BOOL) checkIsMobileNumber:(NSString *)mobileNumber;

// 检查是否符合邮箱地址格式
+ (BOOL) checkEmailAddress:(NSString *)emailAddress;

////判断是否登录
//+ (BOOL)loginStatus;

// 获取星期几
//+ (NSInteger) getWeekDayFromDateString:(NSString *)dateString;

+ (NSString*)getWeekdayStringFromDate:(NSDate*)inputDate;
+ (UIImage*) createImageWithColor: (UIColor*) color;

//自动获取labelframe
+ (CGRect)getLabelFrameWithString:(NSString *)context
                             font:(UIFont *)textFont
                         sizeMake:(CGSize)labelSize;
//获取版本号
+ (NSString *)getVersionNumber;
//获取应用名称
+ (NSString *) getAppDisplayName;

//验证是否位11位纯数字切开头为1的正则
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber;

// 验证文件是否存在
+ (BOOL) fileIsExists:(NSString *)filePath;

// 获取Storyboard实例
+ (UIStoryboard *) getStoryboardInstance;

//密码进行 MD5加密
+ (NSString *)md5String:(NSString *)str;

//获取本地时间string
+ (NSString *) getLocalDateWithTimeString:(BOOL)time;
////获取本地时间
//+ (NSDate *) getLocalDate;
+ (NSString *) getStringFromDate:(NSDate*)date;

//时间戳转换成字符串
+ (NSString *)getStringFromInterval:(NSTimeInterval)interval;

+ (NSDate *)getDateFromString:(NSString *)string;
//字符串转换时间戳
+ (NSTimeInterval)getIntervalFromString:(NSString *)str;

// 获取当前系统的语言
+ (NSString *) getCurrentSysLanguage;

// 拼接URL
+ (NSString *) spliceUrl:(NSString *)interfaceName;

//获取应用环境
//+ (NSString *)getAnyChatServerString;
+ (BOOL)getAuthStatus:(UIViewController *)viewController;

//收缩压
+(NSUInteger) getSystolicPressure:(NSUInteger )heartRate;
//舒张压
+(NSUInteger)getDiatolicPressure:(NSUInteger) heartRate;
+(NSInteger )heartCountTransformationSPO2H:(NSInteger)count;
/**
 *  倒计时
 *
 *  @param time  倒计时间
 *  @param end   结束动作
 *  @param going 倒计进行中动作
 */
+ (void)countdownWithTime:(int)time
                      End:(void(^)())end
                    going:(void(^)(NSString * time))going;

/**
 *  图片压缩方法
 *
 *  @param orignalImage 原图
 *  @param percent      缩放压缩质量
 *
 *  @return image
 */
+ (UIImage *) compressImageWithImage:(UIImage *)orignalImage ScalePercent:(CGFloat)percent;

/**
 *  判断字符串是不是NSNull类
 *
 *  @param string 字符串
 *
 *  @return YES OR NO
 */
+ (BOOL)isNSNullCharacter:(NSString *)string;

/**
 *  获取随机颜色
 *
 *
 *  @return color
 */
+ (UIColor *)getRandomColor;

+ (void)updateAppStoreVersion;

+ (NSString *)getUUID;

//获取不变的UUID
+ (NSString *)getPostUUID;

/**
 *    @brief    截取指定小数位的值
 *
 *    @param     price     目标数据
 *    @param     position     有效小数位
 *
 *    @return    截取后数据
 */
+ (NSString *)notRounding:(double)price afterPoint:(NSInteger)position;

/**
 *  判断身份证字符串是否合法
 *
 *
 *  @return BOOL
 */
+ (BOOL)judgeIdentityStringValid:(NSString *)identityString;

/**
 *  @brief 获取范围随机数
 *  @param value    起始范围
 *  @param toValue  目标范围
 *  @return NSInteger
 */
+ (NSInteger)getRandomFrome:(NSInteger)value to:(NSInteger)toValue;
@end
