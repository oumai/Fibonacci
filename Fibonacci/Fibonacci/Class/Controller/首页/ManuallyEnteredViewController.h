//
//  ManuallyEnteredViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/10/13.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EEnteredType) {
    EEnteredHeartRateType             = 0,
    EEnteredBloodPressureType         = 1,
    EEnteredHealthStepType            = 2,
    EEnteredBloodOxygenType           = 3,
    EEnteredVitalCapacityType         = 4,
    EEnteredVisionDataType            = 5,
};

@interface ManuallyEnteredViewController : KMUIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
{
}
@property(nonatomic,assign)EEnteredType enteredType;
@end
