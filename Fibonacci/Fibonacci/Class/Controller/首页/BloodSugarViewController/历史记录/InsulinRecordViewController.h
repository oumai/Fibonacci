//
//  InsulinRecordViewController.h
//  Fibonacci
//
//  Created by shipeiyuan on 2016/12/17.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsulinRecordViewController : KMUIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * myTableView;
    UIView * segmentView;
    CALayer * segmentLine;
    NSMutableDictionary *userDataDic;
    NSMutableArray *dateArray;
}
@end
