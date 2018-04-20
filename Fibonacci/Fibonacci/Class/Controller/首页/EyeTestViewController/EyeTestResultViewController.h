//
//  EyeTestResultViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/22.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EyeTestResultViewController : KMUIViewController
{    
    __weak IBOutlet UILabel *hudLabel;
    __weak IBOutlet UILabel *textLabel;
}
@property(nonatomic,assign)float value;
@end
