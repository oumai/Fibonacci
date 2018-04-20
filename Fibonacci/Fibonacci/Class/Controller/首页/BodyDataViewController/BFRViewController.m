//
//  BFRViewController.m
//  Fibonacci
//
//  Created by shipeiyuan on 2017/2/ .
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import "BFRViewController.h"

@interface BFRViewController ()

@end

#ifdef iPhone5
#define labelH  40
#else
#define labelH  45
#endif

@implementation BFRViewController

- (void)dealloc
{
    verticalScreenScrollView.delegate = nil;
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];


    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initBFRChartView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deviceOrientationDidChange
{
    NSLog(@"deviceOrientationDidChange:%ld",(long)[UIDevice currentDevice].orientation);
    if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        [self orientationChange:NO];
        //注意： UIDeviceOrientationLandscapeLeft 与 UIInterfaceOrientationLandscapeRight
    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
        [self orientationChange:YES];
    }
}

- (void)orientationChange:(BOOL)landscapeRight
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (landscapeRight) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        verticalScreenScrollView.hidden = NO;
        pageControl.hidden = NO;
        myScrollView.hidden = YES;
        [UIView animateWithDuration:0.2f animations:^{
            verticalScreenScrollView.transform = CGAffineTransformMakeRotation(M_PI_2);
            verticalScreenScrollView.bounds = CGRectMake(0, 0, width, height);
            pageControl.transform = CGAffineTransformMakeRotation(M_PI_2);
            pageControl.bounds = CGRectMake(0, 0, MainScreenHeight, 10);
            
        }];
    } else {
        pageControl.hidden = YES;
        [UIView animateWithDuration:0.2f animations:^{
            verticalScreenScrollView.transform = CGAffineTransformMakeRotation(0);
            pageControl.transform = CGAffineTransformMakeRotation(0);
            verticalScreenScrollView.bounds = CGRectMake(0, 0, width, height);
            pageControl.bounds = CGRectMake(0, 0, MainScreenHeight, 10);
        }completion:^(BOOL finished) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            verticalScreenScrollView.hidden = YES;
            myScrollView.hidden = NO;
        }];
    }
}


- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    // 如果该界面需要支持横竖屏切换
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait;
}

#pragma mark - init
- (void)initBFRChartView
{
    if (myScrollView) {
        return;
    }
    CGFloat minY = 0;
    if (self.navigationController.navigationBar.translucent&&!self.extendedLayoutIncludesOpaqueBars) {
        minY = kStatusAndNavHeight;
    }
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, minY, MainScreenWidth, MainScreenHeight-minY)];
    [self.view addSubview:myScrollView];
    [myScrollView setContentSize:CGSizeMake(0, labelH*13+10+10+10)];
    
    verticalScreenScrollView = [[UIScrollView alloc] initWithFrame: self.view.bounds];
    verticalScreenScrollView.hidden = YES;
    verticalScreenScrollView.pagingEnabled = YES;
    verticalScreenScrollView.delegate = self;
    [verticalScreenScrollView setContentSize:CGSizeMake(MainScreenHeight*2, 0)];
    [self.view addSubview:verticalScreenScrollView];
    
    
    UIView *view = [self setFirstChart:CGPointMake(10, 10) width:MainScreenWidth addToView: myScrollView];
    UIView *labelView = [self setHudLabel:CGPointMake(10, CGRectGetMaxY(view.frame)) width:MainScreenWidth addToView: myScrollView];
    [self setSecondChart: CGPointMake(10, CGRectGetMaxY(labelView.frame)) width:MainScreenWidth addToView: myScrollView];
    
    CGFloat secondViewY = (MainScreenWidth -labelH*6)/2;
    UIView *secondView = [self setFirstChart:CGPointMake(10, secondViewY) width:MainScreenHeight addToView: verticalScreenScrollView];
    UIView *secondlabelView = [self setHudLabel:CGPointMake(10, CGRectGetMaxY(secondView.frame)) width:MainScreenHeight addToView: verticalScreenScrollView];
    secondlabelView.backgroundColor = [UIColor clearColor];
    
    secondViewY = (MainScreenWidth -labelH*7)/2;
    [self setSecondChart: CGPointMake(CGRectGetMaxX(secondView.frame)+ 20, secondViewY) width:MainScreenHeight addToView: verticalScreenScrollView];
  
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(20, (MainScreenHeight-10)/2, 0, 10)];
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = AppFontYellowColor;
    pageControl.pageIndicatorTintColor = AppFontGrayColor;
    pageControl.hidden = YES;
    [self.view addSubview:pageControl];
}

- (UIView *)setFirstChart:(CGPoint)origin width:(CGFloat)width addToView:(UIView *)addToView
{
    CGFloat viewX = origin.x;
    CGFloat viewW = width - viewX*2;
    NSArray *textArray = @[@"理想的体脂脂肪率",
                           @"性别",
                           @"理想体脂率范围",
                           @"肥胖",
                           @"",
                           @"30岁以下",
                           @"30岁以上",
                           @"",
                           @"男性",
                           @"14 - 20%",
                           @"17 - 23%",
                           @"> 25%",
                           @"女性",
                           @"17 - 24%",
                           @"20 - 27%",
                           @"> 30%",
                           ];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(viewX, origin.y, viewW, labelH*5)];
    [addToView addSubview:view];
    CGFloat lastX = 0.f;
    CGFloat lastY = 0.f;
    CGFloat labelW = viewW/4;
    for (int i = 0; i < 16; i++) {
        UILabel *label = [[UILabel alloc] init];
        if (i == 0) {
            label.frame = CGRectMake(lastX, lastY, viewW, labelH);
            lastY = labelH;
        }
        else if (i == 2)
        {
            label.frame = CGRectMake(lastX, lastY, labelW*2, labelH);
            lastX = CGRectGetMaxX(label.frame);
        }
        else
        {
            label.frame = CGRectMake(lastX, lastY, labelW, labelH);
            lastX = CGRectGetMaxX(label.frame);
            lastY = CGRectGetMinY(label.frame);
            switch (i) {
                case 3:
                case 7:
                case 11:
                {
                    lastY = CGRectGetMaxY(label.frame);
                    lastX = 0.f;
                }
                    break;
                    
                default:
                    break;
            }
        }
        label.layer.borderColor = AppFontGrayColor.CGColor;
        label.layer.borderWidth = 0.5f;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%@",textArray[i]];
        label.font = [UIFont fontWithName:AppFontHelvetica size:15];
        label.textColor = AppFontGrayColor;
        [view addSubview:label];
    }
    return view;
}

- (UIView *)setHudLabel:(CGPoint)origin width:(CGFloat)width addToView:(UIView *)addToView
{
    CGFloat viewX = origin.x;
    CGFloat viewW = width - viewX*2;
    UILabel *hudLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewX, origin.y+5, viewW, labelH)];
    hudLabel.numberOfLines = 2;
    hudLabel.text = @"理想的体脂肪率,男性体脂肪若超过25%,女性若超过30%则可判定为肥胖";
    hudLabel.font = [UIFont fontWithName:AppFontHelvetica size:13];
    hudLabel.textColor = AppFontColor;
    [addToView addSubview:hudLabel];
    return hudLabel;
}

- (void)setSecondChart:(CGPoint)origin width:(CGFloat)width addToView:(UIView *)addToView
{
    CGFloat viewX = origin.x;
    CGFloat viewW = width - 20;
    CGFloat labelW = viewW/3;
    UIView *taxonomyView = [[UIView alloc] initWithFrame:CGRectMake(viewX, origin.y+10, viewW, labelH*7)];
    [addToView addSubview: taxonomyView];
    NSArray *taxonomyTexts = @[@"身体脂肪率分类表",
                               @"分类",
                               @"女性(体脂肪%)",
                               @"男性(体脂肪%)",
                               @"必要脂肪",
                               @"10 - 13%",
                               @"2 - 5%",
                               @"运动员",
                               @"14 - 20%",
                               @"6 - 13%",
                               @"健康",
                               @"21 - 24%",
                               @"14 - 17%",
                               @"可接受",
                               @"25 - 31%",
                               @"18 - 25%",
                               @"肥胖",
                               @"32%+",
                               @"26%+",];
    for (int i = 0; i < [taxonomyTexts count]; i ++) {
        UILabel *label = [[UILabel alloc] init];
        label.tag = i;
        label.layer.borderColor = AppFontGrayColor.CGColor;
        label.layer.borderWidth = 0.5f;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%@",taxonomyTexts[i]];
        label.font = [UIFont fontWithName:AppFontHelvetica size:15];
        label.textColor = AppFontGrayColor;
        if (i>0) {
            label.frame = CGRectMake(labelW*((i-1)%3), labelH+labelH*((i-1)/3), labelW, labelH);
            NSLog(@"%d",i%3);
        }
        else
        {
            label.frame = CGRectMake(0, 0, viewW, labelH);
        }
        
        [taxonomyView addSubview:label];
    }
}

#pragma mark -
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    NSLog(@"%f",x);
    if ([scrollView isEqual:verticalScreenScrollView]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger pageInt = x / (MainScreenHeight/3);
            [pageControl setCurrentPage:pageInt];
        });
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
