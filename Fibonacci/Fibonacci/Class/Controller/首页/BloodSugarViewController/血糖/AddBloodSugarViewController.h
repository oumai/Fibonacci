//
//  AddBloodSugarViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/12/14.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BloodSugarSlider.h"
#import "BATBirthDayPickerView.h"
#import "BloodSugarNoteViewController.h"
#import "BloodSugarDataModel.h"
@interface AddBloodSugarViewController : KMUIViewController<UITableViewDelegate,UITableViewDataSource,BATBirthDayPickerViewDelegate,BloodSugarNoteDelegate>
{
    BloodSugarSlider *bloodSugarSlider;
    UIScrollView *segmentScrollView;
    UITableView *myTableView;
    BATBirthDayPickerView *birthDayPickerView;
    NSString *dateStr;
    NSString *noteStr;
    NSString *timeScale;
    CALayer *lineLayer;
    CGFloat lineX;
    CGFloat lineW;
    NSString *secondStr;
    BOOL isPreview;
}

@property(nonatomic, retain)BloodSugarDataModel * previewModel;
@end
