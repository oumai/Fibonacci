//
//  EyeHelpCustom.m
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/10/17.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "EyeHelpCustom.h"
#import "JudgeView.h"
#define Help_Width    MainScreenWidth - 100
#define Help_Height    MainScreenWidth

@implementation EyeHelpCustom

+(void)presentEyeHelpView:(NEyeHelpViewType)type
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    blackView.backgroundColor = UIColorFromHEX(00000, 0);
    blackView.tag = 450;
    [window addSubview:blackView];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [blackView addGestureRecognizer:tapGesture];
    
    UIView *helpView = [[UIView alloc] initWithFrame:CGRectMake(50, MainScreenHeight, Help_Width, Help_Height)];
    helpView.layer.cornerRadius = 5;
    helpView.backgroundColor = [UIColor whiteColor];
    helpView.tag = 451;
    [window addSubview:helpView];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, Help_Width, 40)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:AppFontHelvetica size:16];
    titleLabel.textColor = RGB(51, 51, 51);
    [helpView addSubview:titleLabel];
    
    UIImage *image = nil;
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(titleLabel.frame), Help_Width - 60, 80)];
    [helpView addSubview:textLabel];
    textLabel.font = [UIFont fontWithName:AppFontHelvetica size:14];
    textLabel.numberOfLines = 0;
    textLabel.textColor = RGB(102, 102, 102);
    NSString *textString = @"";
    switch (type) {
        case NEyeHelpViewTypeDefault:
        {
            titleLabel.text = @"如何测试视力";
            textString = @"1:将手机放在距眼前约40cm处\n2:尽量保持实现与屏幕中的""E""平行\n3:选择""E""的朝向\n\n\n\n\n\n\n";
            image = [UIImage imageNamed:@"hepl_eye_window_bg"];
        }
            break;
        case NEyeHelpViewTypeColor:
        {
            titleLabel.text = @"如何测试色盲";
            textString = @"1:选择您在图中看到的数字\n2:确认输入后继续\n3:全部选择完成后得到结果\n\n\n\n\n\n\n";
            image = [UIImage imageNamed:@"hepl_color_bg"];
        }
            break;
            
        default:
            break;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textString length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(0, [textString length])];
    textLabel.attributedText = attributedString;
    
    CGFloat bgWidth = Help_Width-60-30;
    CGFloat bgHeigth = Help_Height-CGRectGetMaxY(textLabel.frame)-25-20;
    if (bgWidth < bgHeigth) {
        bgWidth = bgHeigth;
    }
    UIImageView *helpBG = [[UIImageView alloc] initWithFrame:CGRectMake((Help_Width-bgWidth)/2, CGRectGetMaxY(textLabel.frame)+20, bgWidth, bgWidth)];
    helpBG.image = image;
    [helpView addSubview:helpBG];

    JudgeView *view = [[JudgeView alloc] initWithFrame:CGRectMake((Help_Width-30)/2,Help_Height + 30, 30, 30) status:JudgeViewStatusButton];
    view.backgroundColor = [UIColor clearColor];
    view.layer.shouldRasterize = YES;
    [helpView addSubview:view];
    
    [UIView animateWithDuration:0.35f animations:^{
        CGRect rect = helpView.frame;
        rect.origin.y = (MainScreenHeight-Help_Height)/2;
        helpView.frame = rect;
        blackView.backgroundColor = UIColorFromHEX(00000, 0.85);
    } completion:^(BOOL finished) {
    }];
}

+(void)dismiss
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:450];
    UIView *helpView = [window viewWithTag:451];
    
    //为了弹窗不那么生硬，这里加了个简单的动画
    [UIView animateWithDuration:0.15f animations:^{
        CGRect rect = helpView.frame;
        rect.origin.y = MainScreenHeight;
        helpView.frame = rect;
        blackView.alpha = 0;
    } completion:^(BOOL finished) {
        for (UIView *elem in helpView.subviews) {
            if ([elem isKindOfClass:[UIImageView class]])
            {
                UIImageView *view = (UIImageView *)elem;
                view.image = nil;
            }
            [elem removeFromSuperview];
        }
        [helpView removeFromSuperview];
        [blackView removeFromSuperview];
    }];

}
@end
