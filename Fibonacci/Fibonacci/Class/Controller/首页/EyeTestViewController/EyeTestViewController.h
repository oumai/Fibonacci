//
//  EyeTestViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/20.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXHRrettyRuler.h"
@class EView;
@interface EyeTestViewController : KMUIViewController<TXHRrettyRulerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    __weak IBOutlet UIButton *colorBlindButton;
    __weak IBOutlet UIButton *eyeTestButton;
    __weak IBOutlet UIButton *eyeListButton;
    __weak IBOutlet UIView *buttonView;
    __weak IBOutlet UIView *eyeTestView;
    __weak IBOutlet UIView *colorBlindView;
    __weak IBOutlet UIView *eyeListView;
    __weak IBOutlet NSLayoutConstraint *buttonViewTopConstraint;
    
    //视力
    EView *eView;
    CALayer *lineLayer;  //button下面的线
    CGFloat buttonWidth;
    CGFloat buttonX;
    CGFloat EWidth;
    CGPoint ECenter;
    CGFloat scrollRulerValue;
    UIView *eyeButtonView;
    TXHRrettyRuler *rulerView; //尺子
    
    NSInteger randomNumber;
    
    NSInteger errorCount;   //错误次数
    NSInteger rightCount;   //正确次数
    CGFloat judgeX;
    
    //色盲
    UIScrollView *colorBlindScroll;
    UIPickerView *colorBlindPicker;
    NSArray *colorBlindArray;
    NSMutableArray *colorBlindCacheArray;
    NSArray *singleDigitArray;
    NSArray *tensDigitArray;
    NSString *singleDigitString; //选中的值
    NSString *tensDigitString; //选中的值
    NSInteger imageIndex;
    
    UIButton *confirmButton;
    UIButton *dimnessButton;
    CGFloat imageX;
    CGFloat imageH;
    NSMutableArray *imageNameArray;
    NSMutableArray *colorResultArray;
    
    //视力表
    UIScrollView *eyeListScrollView;
    NSMutableArray *eyeListArray;
    NSInteger randomNumberList;

    //
    BOOL once;
    BOOL onceColor;
    BOOL onceList;
    BOOL onceHelp;
    BOOL onceColorHelp;
}
@end
