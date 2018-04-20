//
//  HelpViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/8.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EPageHelpType) {
    EPageHelpTypeNone             = 0,
    EPageHelpTypeEyeTest        = 1,
    EPageHelpTypeColorTest        = 2,
};

@interface HelpViewController : KMUIViewController
{
    
    __weak IBOutlet UIImageView *myImageView;
    __weak IBOutlet UILabel *heplLabel;
}

@property(nonatomic, assign)EPageHelpType helpType;
@end
