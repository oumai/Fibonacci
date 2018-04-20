//
//  KMUINavigationController.h
//  Fibonacci
//
//  Created by shipeiyuan on 16/9/1.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMUINavigationController : UINavigationController<UIGestureRecognizerDelegate>
- (void)navigationCanDragBack:(BOOL)bCanDragBack;
@end
