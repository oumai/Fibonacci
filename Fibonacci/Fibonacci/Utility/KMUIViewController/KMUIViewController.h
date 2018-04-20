//
//  KMUIViewController.h
//  Fibonacci
//
//  Created by shipeiyuan on 16/9/1.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMUIViewController : UIViewController
-(void)initHelpButton:(SEL)action;
-(void)addRightButton:(SEL)action image:(UIImage *)image;
-(void)addRightButton:(SEL)action titile:(NSString *)str titleColor:(UIColor *)color;
-(void)deleteBackButton;
-(void)initBackLastWebButton:(SEL)action;
-(void)initRefreshButton:(SEL)action;
@end
