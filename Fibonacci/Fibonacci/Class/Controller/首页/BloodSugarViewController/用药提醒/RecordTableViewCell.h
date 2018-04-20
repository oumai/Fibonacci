//
//  RecordTableViewCell.h
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/12/19.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTableViewCell : UITableViewCell
{
    UILabel *typeLabel;
    UILabel *noteLabel;
}
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconBG;
@property (weak, nonatomic) IBOutlet UIImageView *lowOrHeight;


- (void)setCellData:(id)obj;
@end
