//
//  DetailViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/10/9.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATSexPickerView.h"
#import "BATBirthDayPickerView.h"
@class BATPerson;
@interface DetailViewController : KMUIViewController<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,BATSexPickerViewDelegate,BATBirthDayPickerViewDelegate,UITextFieldDelegate>
{
    __weak IBOutlet UITableView *myTablewView;
    
    NSArray *titleArray;
    NSArray *sexArray;
    NSMutableArray * birthDateArray;
    BATPerson *person;
    BATSexPickerView *sexPickerView;
    BATBirthDayPickerView *birthDayPickerView;
}
@property (nonatomic, copy)UIImage *defaultImage;
@end
