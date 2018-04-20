//
//  BloodSugarNoteViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/12/15.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BloodSugarNoteViewController;
@protocol BloodSugarNoteDelegate <NSObject>
- (void)BloodSugarNoteViewController:(BloodSugarNoteViewController *)birthDayPickerView noteString:(NSString *)noteString;
@end

@interface BloodSugarNoteViewController : KMUIViewController
{
    UITextView *myTextView;
    UILabel *label;
}
@property (nonatomic, assign) id <BloodSugarNoteDelegate> delegate;
@property (nonatomic, copy) NSString *noteString;
@property (nonatomic, assign) BOOL isPreviewType;
@end
