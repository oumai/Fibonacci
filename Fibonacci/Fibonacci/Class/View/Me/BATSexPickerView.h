//
//  BATSexPickerView.h
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/22.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BATSexPickerView;
@protocol BATSexPickerViewDelegate <NSObject>

- (void)BATSexPickerView:(BATSexPickerView *)sexPickerView didSelectRow:(NSInteger)row titleForRow:(NSString *)title;

@end

@interface BATSexPickerView : UIView

@property (nonatomic,strong) UIToolbar *toolBar;

@property (nonatomic,strong) UIPickerView *pickerView;

@property (nonatomic,weak) id<BATSexPickerViewDelegate> delegate;

- (void)show;

- (void)hide;

@end
