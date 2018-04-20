//
//  BodyDataViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 2017/2/9.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFLineChart.h"
#import "InputBodyDataView.h"
#import "SexAndAgeInputView.h"
typedef NS_ENUM(NSInteger, EBodyDataTimePeriod) {
    EBodyDataTimePeriodStatusWeek           = 1,
    EBodyDataTimePeriodStatusMonth          = 2,
    EBodyDataTimePeriodStatusYear
};

@interface BodyDataViewController : KMUIViewController<ZFGenericChartDataSource, ZFLineChartDelegate, InputBodyDataDelegate,SexAndAgeInputDelegate>
{
    __weak IBOutlet UISegmentedControl *mySegmentedView;
    __weak IBOutlet UIScrollView *myScrollView;
    InputBodyDataView *inputView;
    SexAndAgeInputView * sexAgeView;
    NSString *sexStr;
    NSString *birthdayStr;
    NSString *IDStr;
    NSMutableDictionary *dataDict;
    NSMutableDictionary *valueDict;
    NSMutableDictionary *dateDict;
    BOOL isGoBFRView;
    BOOL isChangeData;
    __weak IBOutlet NSLayoutConstraint *segmentedConstraint;
}
@end
