//
//  VitalCapacityViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/18.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCListener.h"
@class HeartLive;

@interface VitalCapacityViewController : KMUIViewController
{
    NSTimer *audioTimer;
    UILabel *valueLabel;
    HeartLive *liveHeart;
    NSMutableArray *vitalCapacityArray;
    NSInteger xCoordinateInMoniter;
    CGFloat lastValue;
    CGFloat currentValue;
    CGFloat markValue;
    UIButton *startButton;
    BOOL isGoResult;
    SCListener *listener;
}
@end
