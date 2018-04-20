//
//  UIViewController+BATShowToast.m
//  HealthBAT_Pro
//
//  Created by KM on 16/8/222016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "UIViewController+BATShowToast.h"
#import "SVProgressHUD.h"

@implementation UIViewController (BATShowToast)


- (void)showProgress {
    [SVProgressHUD show];
}

- (void)showProgres:(float)progress {
    [SVProgressHUD showProgress:progress];
}

- (void)dismissProgress {
    [SVProgressHUD dismiss];
}

- (void)showText:(NSString *)text {
    [SVProgressHUD showImage:NULL status:text];
}

- (void)showSuccessWithText:(NSString *)text {
    [SVProgressHUD showSuccessWithStatus:text];
}

- (void)showErrorWithText:(NSString *)text {
    [SVProgressHUD showErrorWithStatus:text];
}

- (void)showProgressWithText:(NSString *)text {
    [SVProgressHUD showWithStatus:text];
}

@end
