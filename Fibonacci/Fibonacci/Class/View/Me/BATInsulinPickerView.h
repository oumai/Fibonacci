//
//  BATInsulinPickerView.h
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/12/16.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BATInsulinPickerView;
@protocol BATInsulinPickerViewViewDelegate <NSObject>

- (void)BATInsulinPickerView:(BATInsulinPickerView *)birthDayPickerView didSelectInsulinString:(NSString *)insulinString;

@end

@interface BATInsulinPickerView : UIView
{
    UIToolbar *toolBar;
    UIPickerView *_pickerView;
}
@property (nonatomic,weak) id<BATInsulinPickerViewViewDelegate> delegate;
- (void)show;

- (void)hide;
@end
