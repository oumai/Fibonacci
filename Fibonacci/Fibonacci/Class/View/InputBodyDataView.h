//
//  InputBodyDataView.h
//  Fibonacci
//
//  Created by woaiqiu947 on 2017/2/13.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InputBodyDataView;
typedef NS_ENUM(NSInteger, EInputViewType) {
    EInputViewTypeBust            = 0,
    EInputViewTypeHeight          = 1,
    EInputViewTypeWeight
};


@protocol InputBodyDataDelegate <NSObject>

- (void)inputViewType:(InputBodyDataView *)inputBodyDataView inputViewType:(EInputViewType)type saveValue:(NSString *)value;

@end

@interface InputBodyDataView : UIView<UITextFieldDelegate>
{
    UILabel *titleLabel;
    UITextField *inputField;
    UILabel *unitLabel;
    UIButton * saveButton;
    EInputViewType inputType;
}
@property (nonatomic,weak) id<InputBodyDataDelegate> delegate;

-(void)presentInputView:(EInputViewType)type;
- (void)removeAllSubview;
@end

