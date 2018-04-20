//
//  JudgeView.h
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/21.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JudgeViewStatus) {
    JudgeViewStatusError            = 0,
    JudgeViewStatusRight            = 1,
    JudgeViewStatusButton           = 2,
};

@interface JudgeView : UIView
{
    JudgeViewStatus judgeViewStatus;
    BOOL removeCircle;
}
- (instancetype)initWithFrame:(CGRect)frame status:(JudgeViewStatus)status;
- (instancetype)initWithFrame:(CGRect)frame status:(JudgeViewStatus)status removeCircle:(BOOL)circle;
@end
