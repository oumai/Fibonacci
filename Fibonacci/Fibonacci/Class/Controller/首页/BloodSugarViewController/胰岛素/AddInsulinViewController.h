//
//  AddInsulinViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/12/16.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATBirthDayPickerView.h"
#import "BATInsulinPickerView.h"
#import "InsulinDataModel.h"
@interface AddInsulinViewController : KMUIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,BATBirthDayPickerViewDelegate,BATInsulinPickerViewViewDelegate,UITextViewDelegate>
{
    UITableView *myTableView;
    NSArray *titleArray;
    UITextField *doseField;
    UILabel *nameLabel;
    UITextView *noteView;
    UIView *buttonView;
    NSString *dateStr;
    NSString *secondStr;
    BATBirthDayPickerView *birthDayPickerView;
    BATInsulinPickerView *insulinPickerView;
    NSUserDefaults * userDefaults;
    NSString *deleteStr;
    BOOL isPreview;
}

@property (nonatomic, retain)InsulinDataModel *previewModel;
@end
