//
//  KMTools+DeviceCategory.m
//  Fibonacci
//
//  Created by four on 2017/9/14.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import "KMTools+DeviceCategory.h"

#import <sys/sysctl.h>

@implementation KMTools (DeviceCategory)

+ (NSString *)getCurrentDeviceModelDescription{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

+ (NSString *)getCurrentDeviceModel{
    
    NSString *platform = [KMTools getCurrentDeviceModelDescription];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4s";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPod Touch 6G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad Mini 3";
    
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini 4 WiFi";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad Mini 4 WiFi+Cellular";
    
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air2";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air2";
    
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro WiFi 12.7-inch";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro WiFi+Cellular 12.7-inch";
    
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro WiFi 9.7-inch";
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro WiFi+Cellular 9.7-inch";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

+ (void)saveDeviceInfo {
    
    if ([[KMTools getCurrentDeviceModel] isEqualToString:@"iPhone 4s"]) {
        
        //320*480
        [[NSUserDefaults standardUserDefaults] setInteger:960 forKey:@"ImageResolutionHeight"];
        
    }
    
    if ([[KMTools getCurrentDeviceModel] isEqualToString:@"iPhone 5"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPhone 5c"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPhone 5s"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPod Touch 5G"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPod Touch 6G"]||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPhone SE"] ){
        
        //320*568
        [[NSUserDefaults standardUserDefaults] setInteger:1136 forKey:@"ImageResolutionHeight"];
        
    }
    
    
    
    if ([[KMTools getCurrentDeviceModel] isEqualToString:@"iPhone 6"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPhone 6s"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPhone 7"]||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPhone 8"]) {
        
        //375*667
        [[NSUserDefaults standardUserDefaults] setInteger:1334 forKey:@"ImageResolutionHeight"];
        
    }
    
    if ([[KMTools getCurrentDeviceModel] isEqualToString:@"iPhone 6 Plus"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPhone 6s Plus"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPhone 7 Plus"]||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPhone 8 Plus"]) {
        
        //417*736
        [[NSUserDefaults standardUserDefaults] setInteger:2208 forKey:@"ImageResolutionHeight"];
        
    }
    
    if ([[KMTools getCurrentDeviceModel] isEqualToString:@"iPhone X"]) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:2436 forKey:@"ImageResolutionHeight"];
    }
    
    if ([[KMTools getCurrentDeviceModel] isEqualToString:@"iPad 2"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPad Mini 1G"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPad 3"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPad 4"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPad Air"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPad Mini 2G"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPad Mini 3"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPad Mini 4 WiFi"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPad Mini 4 WiFi+Cellular"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPad Air2"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPad Pro WiFi 12.7-inch"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPad Pro WiFi+Cellular 12.7-inch"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPad Pro WiFi 9.7-inch"] ||
        [[KMTools getCurrentDeviceModel] isEqualToString:@"iPad Pro WiFi+Cellular 9.7-inch"]) {
        
        //768*1024
        [[NSUserDefaults standardUserDefaults] setInteger:1024 forKey:@"ImageResolutionHeight"];
        
    }
    
    if ([[KMTools getCurrentDeviceModel] isEqualToString:@"iPhone Simulator"]) {
        
        //模拟器
        //模拟器
        [[NSUserDefaults standardUserDefaults] setInteger:[UIScreen mainScreen].currentMode.size.height forKey:@"ImageResolutionHeight"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
