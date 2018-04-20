//
//  ForgetAndChangeViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/10/12.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EViewType ) {
    EViewRegistType             = 0,
    EViewForgetType             = 1,
    EViewChangeType             = 2,
};

@interface ForgetAndChangeViewController : KMUIViewController
{
    __weak IBOutlet UITableView *myTableView;
    NSArray *titleArray;
    NSArray *placeholderArray;
    UIButton *countdownButton;
    UITextField *phoneField;
    UITextField *antuField;
    UITextField *passwrodField;
    UITextField *confirmField;
}
@property(nonatomic,assign) EViewType type;
@end
