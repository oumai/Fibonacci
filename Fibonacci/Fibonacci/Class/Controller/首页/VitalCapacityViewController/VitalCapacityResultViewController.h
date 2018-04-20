//
//  VitalCapacityResultViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/22.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeartView;
@interface VitalCapacityResultViewController : KMUIViewController
{
    HeartView *vitalCapacityHeartView;
    CGFloat vitalCapacityHeartViewY;
    NSString *shareText;
}
@property(nonatomic,assign) NSInteger markValue;
@end
