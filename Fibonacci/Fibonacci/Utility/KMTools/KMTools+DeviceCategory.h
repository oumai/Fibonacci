//
//  KMTools+DeviceCategory.h
//  Fibonacci
//
//  Created by four on 2017/9/14.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import "KMTools.h"

@interface KMTools (DeviceCategory)

/*
 获取设备描述
 */
+ (NSString *)getCurrentDeviceModelDescription;
/*
 由获取到的设备描述，来匹配设备型号
 */
+ (NSString *)getCurrentDeviceModel;


/**
 保存设备信息到本地
 */
+ (void)saveDeviceInfo;

@end
