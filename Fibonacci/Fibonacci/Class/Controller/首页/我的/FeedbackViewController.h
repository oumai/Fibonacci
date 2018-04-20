//
//  FeedbackViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/10/9.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZImagePickerController.h"

@interface FeedbackViewController : KMUIViewController<UINavigationControllerDelegate,TZImagePickerControllerDelegate>
{
    BOOL once;
    UITextView *myTextView;
    UILabel *myLabel;
    CALayer *GBLayer;
    NSMutableArray *imageUrlArray;
    NSMutableArray *imagePicArray;
    NSMutableArray *imageAssetsArray;
    UIView *updateImageView;
    UIButton *myButton;
    UILabel *titleLabel;
    UILabel *textLabel;
    BOOL Pickering;
}
@end
