//
//  SexAndAgeInputView.h
//  Fibonacci
//
//  Created by woaiqiu947 on 2017/2/14.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SexAndAgeInputView;
@protocol SexAndAgeInputDelegate <NSObject>

- (void)sexAndAgeInputView:(SexAndAgeInputView *)sexAndAgeInputView sexValue:(NSString *)sexValue ageValue:(NSString *)ageValue;
@end

@interface SexAndAgeInputView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView *blackView;
    UIPickerView *agePickerView;
}
@property (nonatomic,weak) id<SexAndAgeInputDelegate> delegate;
-(void)presentSexAndAgeInputView;
-(void)removeAllSubview;
@end
