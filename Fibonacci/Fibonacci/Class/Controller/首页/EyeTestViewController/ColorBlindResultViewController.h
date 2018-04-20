//
//  ColorBlindResultViewController.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/22.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorBlindResultViewController : KMUIViewController
{

    __weak IBOutlet UILabel *hudLabel;
    NSString *shareText;
}
@property(nonatomic,retain )NSMutableArray *valueArray;
@end
