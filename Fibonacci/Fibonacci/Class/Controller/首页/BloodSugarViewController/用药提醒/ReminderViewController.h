//
//  ReminderViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/12/20.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BATBirthDayPickerView.h"
#import "BATInsulinPickerView.h"
#import "ReminderViewController.h"
#import "ReminderModel.h"
#import "DoseTimeViewController.h"

@class ReminderViewController;
@protocol ReminderDelegate <NSObject>
- (void)ReminderViewController:(ReminderViewController *)reminderViewController deleteModel:(ReminderModel *)model;
- (void)ReminderViewController:(ReminderViewController *)reminderViewController changeModel:(ReminderModel *)model;
@end

@interface ReminderViewController : KMUIViewController<UITableViewDelegate,UITableViewDataSource,BATBirthDayPickerViewDelegate,BATInsulinPickerViewViewDelegate,UITextViewDelegate,DoseTimeDelegate>
{
    UITableView *myTableView;
    UITableView *doseAndTimeTableView;
    UITextView *noteView;
    BATBirthDayPickerView *birthDayPickerView;
    BATInsulinPickerView *insulinPickerView;
    UISwitch *reminderSwitch;
    UIView *weekView;
    NSArray *doseAndTimeArray;
    NSArray *titleArray;
    CGFloat weekViewHeight;
}
@property(nonatomic, strong)ReminderModel *model;
@property(nonatomic, weak)id <ReminderDelegate> delegate;
@end
