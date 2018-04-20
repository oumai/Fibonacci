//
//  BATAppDelegate+BATVersion.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/292016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "AppDelegate+BATVersion.h"
#import "BATVersionModel.h"
#import "NSObject+MJKeyValue.h"

@implementation AppDelegate (BATVersion)

- (void)bat_version {

    NSDictionary *dic = @{@"accountType":@"1",
                         @"equipment":@"IOSAides",
                         @"versionId":[KMTools getVersionNumber]
                         };
    
    [HTTPTool requestWithURLString:@"/api/GetAppVersion"
                        parameters:dic
                        showStatus:NO
                              type:kGET success:^(id responseObject) {
                                  
                                  BATVersionModel *version = [BATVersionModel mj_objectWithKeyValues:responseObject];
                                  if (version.Data.IsUpdate) {
                                      //需要更新
                                      UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"当前版本需要更新" message:version.ResultMessage preferredStyle:UIAlertControllerStyleAlert];
                                      UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                                          //版本更新
                                          //跳转到更新地址
                                          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:version.Data.UpAddress]];
                                          //退出app
                                          //                                         exit(0);
                                      }];
                                      [alert addAction:okAction];;
                                      
                                      [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
                                      
                                  }
                                  
                              } failure:^(NSError *error) {
                                  
                              }];

}
@end
