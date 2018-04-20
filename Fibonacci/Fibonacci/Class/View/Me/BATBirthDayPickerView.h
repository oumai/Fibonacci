//
//  BATAgePickerView.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/10/10.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, EBirthDayType)
{
    EBirthDayTypeDefault        = 0,
    EBirthDayTypeDateAndTime    = 1,
    EBirthDayTypeDateWeek       = 2,
    EBirthDayTypeDateTime       = 3,
};

@class BATBirthDayPickerView;
@protocol BATBirthDayPickerViewDelegate <NSObject>

- (void)BATBirthDayPickerView:(BATBirthDayPickerView *)birthDayPickerView didSelectDateString:(NSString *)dateString;

@end

@interface BATBirthDayPickerView : UIView
{
    EBirthDayType birthDayType;
}

@property (nonatomic,strong) UIToolbar *toolBar;

@property (nonatomic,strong) UIDatePicker *pickerView;

@property (nonatomic,weak) id<BATBirthDayPickerViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(EBirthDayType)type;

- (void)show;

- (void)hide;
@end
