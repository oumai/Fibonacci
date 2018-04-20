//
//  HeartChartViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/29.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFLineChart.h"

typedef NS_ENUM(NSInteger, EChartDataType) {
    EChartDataHeartRateType             = 0,
    EChartDataBloodPressureType         = 1,
    EChartDataHealthStepType            = 2,
    EChartDataBloodOxygenType           = 3,
    EChartDataVitalCapacityType         = 4,
    EChartDataVisionDataType            = 5,
    EChartDataBloodSugarDataType        = 6,
};

@interface HeartChartViewController : KMUIViewController<ZFGenericChartDataSource, ZFLineChartDelegate>
{
    ZFLineChart *lineChartView;
    EDataTimePeriod timerType;
    __weak IBOutlet UIView *valueHudView;
    __weak IBOutlet UISegmentedControl *mySegmentView;
    __weak IBOutlet UIView *myChartView;
    __weak IBOutlet UITableView *myTableView;
    __weak IBOutlet UILabel *newLabel;
    __weak IBOutlet UILabel *maxLabel;
    __weak IBOutlet UILabel *minLabel;
    __weak IBOutlet UILabel *averageLabel;
    __weak IBOutlet NSLayoutConstraint *segmentConstraint;
    
    NSMutableArray *valueArray;//表格数值
    NSMutableArray *dateArray; //表格时间
    NSMutableArray *numberArray;//数值
    NSMutableArray *modelArray; //
    CGFloat valueWidth;
    BOOL onceInit;
}
@property(assign,nonatomic) EChartDataType type;
@end
