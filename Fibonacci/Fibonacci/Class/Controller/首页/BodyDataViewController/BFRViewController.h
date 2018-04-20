//
//  BFRViewController.h
//  Fibonacci
//
//  Created by shipeiyuan on 2017/2/19.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFRViewController : KMUIViewController<UIScrollViewDelegate>
{
    UIScrollView *myScrollView;
    UIScrollView *verticalScreenScrollView;
    UIPageControl *pageControl;
}
@end
