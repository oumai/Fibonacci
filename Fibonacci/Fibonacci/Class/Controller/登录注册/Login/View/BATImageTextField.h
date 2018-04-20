//
//  ImageTextField.h
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/7/13.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATImageTextField : UIView

@property (nonatomic,strong) UITextField *rightTF;

- (instancetype)initWithFrame:(CGRect)frame Image:(UIImage *)image placehold:(NSString *)placehold;

@end
