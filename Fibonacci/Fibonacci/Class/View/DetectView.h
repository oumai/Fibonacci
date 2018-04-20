//
//  DetectView.h
//  testApp
//
//  Created by shipeiyuan on 2017/9/9.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DetectView : UIView
- (void)begin;
- (void)stop;

- (instancetype)initWithFrame:(CGRect)frame withLineWidth:(CGFloat)width innerLineWidth:(CGFloat)innerWidth;
@end
