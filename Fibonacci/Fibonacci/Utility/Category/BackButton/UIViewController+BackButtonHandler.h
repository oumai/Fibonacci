//
//  UIViewController+BackButtonHandler.h
//  HealthBAT_Pro
//
//  Created by KM on 16/7/212016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackButtonHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
-(BOOL)navigationShouldPopOnBackButton;
@end
@interface UIViewController (BackButtonHandler) <BackButtonHandlerProtocol>
@end