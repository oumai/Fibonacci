//
//
//
//  url:http://www.xiongcaichang.com
//  Created by bear on 16/3/31.
//  Copyright © 2016年 bear. All rights reserved.
//
#import <UIKit/UIKit.h>
/*
 使用方法
 [self.tableView addScalableCoverWithImage:[UIImage imageNamed:@"image"]];
 */

static const CGFloat MaxHeight = 100;



@interface ScalableCover : UIImageView

@property (nonatomic, strong) UIScrollView *scrollView;

@end




@interface UIScrollView (ScalableCover)

@property (nonatomic, weak) ScalableCover *scalableCover;

- (void)addScalableCoverWithImage:(UIImage *)image;
- (void)removeScalableCover;

@end

