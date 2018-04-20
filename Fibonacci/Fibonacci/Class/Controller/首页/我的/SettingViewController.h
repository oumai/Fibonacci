//
//  SettingViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/10/9.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : KMUIViewController
{
    NSArray *titleArray;
    __weak IBOutlet UITableView *myTableView;
    CGFloat cacheSize;
}
@end
