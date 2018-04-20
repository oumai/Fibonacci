//
//  KMTools.m
//  PlamHospital
//
//  Created by 123 on 15/7/15.
//  Copyright (c) 2015年 KM. All rights reserved.
//

#import "KMTools.h"
#import "SFHFKeychainUtils.h"

#define TripleDESKey    @"012345670123456701234567"
#define gIv             @"01234567"

@implementation KMTools

+ (BOOL)connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

+ (void)showAlertMessage:(NSString *)message{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles: @"确定", nil];
    [alertView show];
#endif
}

+ (void)showAlertMessage:(NSString *)message cancel:(NSString *)cancal inViewController:(UIViewController *)viewController handler:(void (^)(UIAlertAction *action))handler{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_8_0
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle: @"确定" style:UIAlertActionStyleDefault handler:handler];
        [alertController addAction:sureAction];
        UIAlertAction *canleAction = [UIAlertAction actionWithTitle: @"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:canleAction];
        [viewController presentViewController:alertController animated:YES completion:nil];
#endif
}

//纯数字正则验证
+ (BOOL)isOnlyNumber:(NSString *)number
{
    NSString *numberRegex = @"^[0-9]*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:number];
}

+ (BOOL)isFloatNumber:(NSString *)number
{
    NSString *numberRegex = @"^[0-9]+(.[0-9]{1,2})?$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:number];
}

+ (BOOL)isPhoneNumber:(NSString *)phoneNumber{
    
    NSString *regex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    //@"^((13[0-9])|(14[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d(8)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    return isMatch;
}

//拨打电话
+ (void)callPhoneNumber:(NSString *)phoneNum inView:(UIView *)view{
    NSString *callingPhoneNum = [NSString stringWithFormat:@"tel:%@",phoneNum];
    UIWebView *callWebView = [[UIWebView alloc] init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callingPhoneNum]]];
    [view addSubview:callWebView];
}

//3DES加密
+ (NSString *)TripleDES:(NSString *)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt encryptOrDecryptKey:(NSString *)encryptOrDecryptKey{

    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)//解密
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else //加密
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    const void *vkey = (const void *)[encryptOrDecryptKey UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    /*if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
     else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; 
    **/
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                length:(NSUInteger)movedBytes]
                                        encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    return result;

}

// 加密方法
+ (NSString*)encrypt:(NSString*)plainText {
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [TripleDESKey UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [GTMBase64 stringByEncodingData:myData];
    return result;
}

// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText {
    NSData *encryptData = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [TripleDESKey UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                      length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    return result;
}

+ (UIColor *) colorWithHexString: (NSString *) hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#"withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            return [UIColor blackColor];
            //[NSException:@"Invalid color value"format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

#pragma mark - 检查是否是手机号码
+ (BOOL) checkIsMobileNumber:(NSString *)mobileNumber {
    NSString *strMobile = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString *strCM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString *strCU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString *strCT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";\
    
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strMobile];
    NSPredicate *regextestCM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strCM];
    NSPredicate *regextestCU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strCU];
    NSPredicate *regextestCT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strCT];
    
    if (([regextestMobile evaluateWithObject:mobileNumber]) == YES ||
        ([regextestCM evaluateWithObject:mobileNumber]) == YES ||
        ([regextestCU evaluateWithObject:mobileNumber]) == YES ||
        ([regextestCT evaluateWithObject:mobileNumber]) == YES) {
        return YES;
    }
    
    return NO;
}

//验证是否位11位纯数字切开头为1的正则
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber {
    NSString *strRegex = @"^1[3-9]\\d{9}$";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    
    return [emailPredicate evaluateWithObject:phoneNumber];
}

#pragma mark - 检查是否是邮箱地址

+ (BOOL) checkEmailAddress:(NSString *)emailAddress {
    NSString *strRegex = @"[A-Z0-9a-z._%+-]+@[A-Z0-9a-z._]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    
    return [emailPredicate evaluateWithObject:emailAddress];
}

//+ (NSInteger) getWeekDayFromDateString:(NSString *)dateString {
//    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
//    NSDate * date = [formatter dateFromString:dateString]; //日期转化NSString to NSDate
//    
//    NSCalendar *calendaraa = [NSCalendar currentCalendar];
//    [calendaraa setFirstWeekday:2]; //设定周一为周首日
//    NSUInteger unitFlags = NSCalendarUnitYear | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit;
//    NSDateComponents *dateComponent = [calendaraa components:unitFlags fromDate:date];
//    NSInteger weekday = [dateComponent weekday];
//    return weekday - 1;
//}

+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect= CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (CGRect)getLabelFrameWithString:(NSString *)context
                             font:(UIFont *)textFont
                         sizeMake:(CGSize)labelSize
{
    CGRect tmpRect = [context boundingRectWithSize:labelSize
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:[NSDictionary dictionaryWithObjectsAndKeys:textFont,NSFontAttributeName, nil]
                                        context:nil];
    return tmpRect;
}

//获取版本号
+ (NSString *) getVersionNumber {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *versionStr =[infoDic objectForKey:@"CFBundleShortVersionString"];
    return versionStr;
}

+ (NSString *) getAppDisplayName {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *versionStr =[infoDic objectForKey:@"CFBundleName"];
    return versionStr;
}

+ (BOOL) fileIsExists:(NSString *)filePath {
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (UIStoryboard *) getStoryboardInstance
{
    NSString *storyboardName = [self getStoryboardName];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    return storyboard;
}

+ (NSString *) getStoryboardName
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return @"Main";
    }
    else
    {
        return @"Main";
    }
}

//密码进行 MD5加密
+ (NSString *)md5String:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG) strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//获取当前时间
+ (NSString *) getLocalDateWithTimeString:(BOOL) time
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:zone];
    if (time) {
        [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    }
    else
    {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSString *strTime = [formatter stringFromDate:date];
    return strTime;
}

+ (NSDate *)getDateFromString:(NSString *)string
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:zone];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:string];
    return date;
}
//时间转字符
+ (NSString *) getStringFromDate:(NSDate*)date
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:zone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strTime = [formatter stringFromDate:date];
    return strTime;
}

//字符转时间戳
+ (NSTimeInterval)getIntervalFromString:(NSString *)str
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:zone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [formatter dateFromString:str];
    NSTimeInterval interval= [date timeIntervalSince1970];
    return interval;
}

+ (NSString *)getStringFromInterval:(NSTimeInterval)interval
{
    NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:interval];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:zone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * strTime = [formatter stringFromDate:currentTime];
    return strTime;
}

+ (NSString*)getWeekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

////获取当前时间
//+ (NSDate *) getLocalDate{
//    NSDate *date = [NSDate date];
////    NSTimeZone *zone = [NSTimeZone systemTimeZone];
////    NSInteger interval = [zone secondsFromGMTForDate:date];
////    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
//    return date;
//}

// 获取当前系统的语言
+ (NSString *) getCurrentSysLanguage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}

// 拼接URL
+ (NSString *) spliceUrl:(NSString *)interfaceName {
    NSString *language = [self getCurrentSysLanguage];
    NSString *stringLanguage = @"";
    if ([language isEqualToString:@"en-CN"]) {
        stringLanguage = @"en";
    }
    else {
        stringLanguage = @"zh";
    }
    NSString *requestUrl = [NSString stringWithFormat:@"%@?locale=%@", interfaceName, stringLanguage];
    return requestUrl;
}

+ (BOOL)getAuthStatus:(UIViewController *)viewController
{
    if(IS_IOS7)
    {
        __block BOOL isAvalible = NO;
        NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if (authStatus == AVAuthorizationStatusNotDetermined) //第一次使用，则会弹出是否打开权限
        {
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                isAvalible = granted;
            }];
            return isAvalible;
        }
        else if(authStatus == AVAuthorizationStatusAuthorized)
        {
            return YES;
        }
        else
        {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_8_0
            if (IS_IOS8)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法启动相机" message:@"请开启相机权限：设置->隐私->康美小管家" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                    else
                    {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"]];
                    }
                }];
                [alertController addAction:sureAction];
                UIAlertAction *canleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:canleAction];
                [viewController presentViewController:alertController animated:YES completion:nil];
                return isAvalible;
            }
#else
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法启动相机" message:@"请开启相机权限：设置->隐私->体检管家" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alertView show];
#endif
            return isAvalible;
        }
    }
    else
    {
        return YES;
    }
}
//+ (NSString *)getAnyChatServerString {
//    if (KMMO_ENVIRONMENT == 1) {//正式环境
//        return [AppDelegate getAppDelegate].anychat_Server_String;
//    }else{//测试环境
//        return [AppDelegate getAppDelegate].anychat_Server_Test_String;
//    }
//    
//}

#pragma mark -
//收缩压
+(NSUInteger) getSystolicPressure:(NSUInteger )heartRate
{
    if (heartRate == 0) {
        return 0;
    }
    CGFloat R = 18.5; // Average R = 18.31; // Vascular resistance // Very hard to calculate from person to person
    CGFloat ejectionTime = 364.5 - 1.23 * heartRate;
    CGFloat bodySurfaceArea = 0.007184 * (pow(160, 0.425)) * (pow(75, 0.725));
    CGFloat strokeVolume = -6.6 + 0.25 * (ejectionTime - 35) - 0.62 * heartRate + 40.4 * bodySurfaceArea - 0.51 * 23; // Volume of blood pumped from heart in one beat
    CGFloat pulsePressure = strokeVolume / ((0.013 * 160 - 0.007 * 23 - 0.004 * heartRate) + 1.307);
    CGFloat meanPulsePressure = 5 * R;
    NSUInteger systolicPressure = (meanPulsePressure + 3 / 2 * pulsePressure - 9);
    return systolicPressure;
}

//舒张压
+(NSUInteger)getDiatolicPressure:(NSUInteger) heartRate
{
    if (heartRate == 0) {
        return 0;
    }
    CGFloat R = 18.5; //
    CGFloat ejectionTime = 364.5 - 1.23 * heartRate;
    CGFloat bodySurfaceArea = 0.007184 * (pow(160, 0.425)) * (pow(75, 0.725));
    CGFloat strokeVolume = -6.6 + 0.25 * (ejectionTime - 35) - 0.62 * heartRate + 40.4 * bodySurfaceArea - 0.51 * 23;
    CGFloat pulsePressure = strokeVolume / ((0.013 * 160 - 0.007 * 23 - 0.004 * heartRate) + 1.307);
    CGFloat meanPulsePressure = 5 * R;
    NSUInteger diastolicPressure = (meanPulsePressure - pulsePressure / 3 - 15);
    return diastolicPressure;
}



+(NSInteger )heartCountTransformationSPO2H:(NSInteger)count
{
    if (count<60)
    {
        count = 100;
    }
    else if (count < 70)
    {
        count = 90;
    }
    else if (count < 80)
    {
        count = 80;
    }
    else if (count < 90)
    {
        count = 70;
    }
    else if (count > 90)
    {
        count = 60;
    }
    count = 94 + 5-(count-55)/10;
    return count;
}

#pragma mark - 倒计时
+ (void)countdownWithTime:(int)time
                      End:(void(^)())end
                    going:(void(^)(NSString * time))going {
    
    __block int timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^
                                      {
                                          if(timeout<=0) {
                                              
                                              //倒计时结束，关闭
                                              dispatch_source_cancel(_timer);
                                              dispatch_async(dispatch_get_main_queue(), ^
                                                             {
                                                                 //设置界面的按钮显示 根据自己需求设置
                                                                 if (end) {
                                                                     end();
                                                                 }
                                                                 
                                                             });
                                          }
                                          else {
                                              
                                              int seconds = timeout % (time + 1);
                                              NSString *strTime = [NSString stringWithFormat:@"%d秒后重发", seconds];
                                              dispatch_async(dispatch_get_main_queue(), ^
                                                             {
                                                                 //设置界面的按钮显示 根据自己需求设置
                                                                 going(strTime);
                                                             });
                                              timeout--;
                                          }
                                      });
    dispatch_resume(_timer);
}

#pragma mark - 图片压缩方法
+ (UIImage *) compressImageWithImage:(UIImage *)orignalImage ScalePercent:(CGFloat)percent
{
    if (orignalImage.size.width - 640 > 0) {
        CGSize imgSize = orignalImage.size;
        
        CGFloat fScale = 640 / orignalImage.size.width;
        
        imgSize.width = 640;
        imgSize.height = fScale * orignalImage.size.height;
        
        // 压缩图片质量
        UIImage *imageReduced = [self reduceImage:orignalImage percent:percent];
        
        // 压缩图片尺寸
        UIImage *imageCompress = [self imageWithImageSimple:imageReduced scaledToSize:imgSize];
        
        return imageCompress;
    }
    else {
        return orignalImage;
    }
}

// 压缩图片质量
+ (UIImage *)reduceImage:(UIImage *)image percent:(float)percent
{
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}

//压缩图片尺寸
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

#pragma mark - 判断字符串是不是NSNull类
+ (BOOL)isNSNullCharacter:(NSString *)string
{
    BOOL isResult = NO;
    
    if ([string isKindOfClass:[NSNull class]]) {
        isResult = YES;
    }
    else if ([string isKindOfClass:[NSString class]]) {
        if ([string isEqualToString:@"(null)"]) {
            isResult = YES;
        }
    }
    
    return isResult;
}

+ (UIColor *)getRandomColor
{
    return  [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
}

#pragma mark - 
//根据appstore中版本号与本地版本号对比判断是否需要更新
+ (void)updateAppStoreVersion {
    
    //网络获取当前最新版本及版本更新信息
    //T_WARNING APP在appstore上的APPID
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",APPSTORE_ID];
    
    [HTTPTool requestNormalWithURLString:url parameters:nil serializerType:kHTTP type:kGET success:^(id responseObject) {
        
        //获取信息
        NSDictionary * response = responseObject;
        NSArray * arr = [response valueForKey:@"results"];
        NSDictionary * result = arr[0];
        NSString * appStoreVersion = [result valueForKey:@"version"];
        NSString * releaseNotes = [result valueForKey:@"releaseNotes"];
        
        //获取本地版本号
        NSString *localVersion = [self getVersionNumber];;
        
        BOOL isUpdate = NO;
        
        NSMutableArray *localArray = [NSMutableArray arrayWithArray:[localVersion componentsSeparatedByString:@"."]];
        NSMutableArray *versionArray = [NSMutableArray arrayWithArray:[appStoreVersion componentsSeparatedByString:@"."]];
        
        while (localArray.count < 3) {
            [localArray addObject:@"0"];
        }
        
        while (versionArray.count < 3) {
            [versionArray addObject:@"0"];
        }
        if ((versionArray.count == 3) && (localArray.count == versionArray.count)) {
            
            if ([localArray[0] intValue] <  [versionArray[0] intValue]) {
                
                isUpdate = YES;
            }
            else if ([localArray[0] intValue]  ==  [versionArray[0] intValue]) {
                
                if ([localArray[1] intValue] <  [versionArray[1] intValue]) {
                    
                    isUpdate = YES;
                }
                else if ([localArray[1] intValue] ==  [versionArray[1] intValue]) {
                    
                    if ([localArray[2] intValue] <  [versionArray[2] intValue]) {
                        
                        isUpdate = YES;
                    }
                }
            }
        }
        //判断
        if (isUpdate) {
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"新版本更新"
                                                                            message:releaseNotes
                                                                     preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"去更新"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action)
                                        {
                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?mt=8",APPSTORE_ID]]];
                                            
                                        }];
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            UIWindow * window = [UIApplication sharedApplication].keyWindow;
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma  mark -获取UUID
+ (NSString *)getUUID {
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    return identifierForVendor;
}

//获取不变的UUID
+ (NSString *)getPostUUID {
    //保存UUID
    NSError *uuidError;
    NSString * uuidString = [SFHFKeychainUtils getPasswordForUsername:@"UUID" andServiceName:ServiceName error:&uuidError];
    if (!uuidString) {
        BOOL saved = [SFHFKeychainUtils storeUsername:@"UUID" andPassword:[self getUUID] forServiceName:ServiceName updateExisting:YES error:&uuidError];
        uuidString = [SFHFKeychainUtils getPasswordForUsername:@"UUID" andServiceName:ServiceName error:&uuidError];
        if (!saved) {
            DDLogDebug(@"存储UUID失败");
            uuidString = [self getUUID];
        }
    }
    return uuidString;
}

/**
 *    @brief    截取指定小数位的值
 *
 *    @param     price     目标数据
 *    @param     position     有效小数位
 *
 *    @return    截取后数据
 */
+ (NSString *)notRounding:(double)price afterPoint:(NSInteger)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (BOOL)judgeIdentityStringValid:(NSString *)identityString {
    
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}

+ (NSInteger)getRandomFrome:(NSInteger)value to:(NSInteger)toValue
{
    return arc4random()%(toValue-value)+value;
}
@end
