//
//  DoseTimeViewController.h
//  Fibonacci
//
//  Created by shipeiyuan on 2016/12/21.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReminderModel.h"
#import "BATBirthDayPickerView.h"

@class DoseTimeViewController;
@protocol DoseTimeDelegate <NSObject>
- (void)DoseTimeViewController:(DoseTimeViewController *)doseTimeViewController deleteModel:(DoseTime *)model;
- (void)DoseTimeViewController:(DoseTimeViewController *)doseTimeViewController changeModel:(DoseTime *)model;
@end

@interface DoseTimeViewController : KMUIViewController<UITableViewDataSource,UITableViewDelegate,BATBirthDayPickerViewDelegate,UITextFieldDelegate>
{
    UITableView *myTableView;
    UITextField *_textField;
    BATBirthDayPickerView *birthDayPickerView;
}
@property(nonatomic, strong)DoseTime *dose;
@property (nonatomic,weak) id<DoseTimeDelegate> delegate;
@end
