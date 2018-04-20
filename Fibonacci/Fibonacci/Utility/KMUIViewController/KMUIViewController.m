//
//  KMUIViewController.m
//  Fibonacci
//
//  Created by shipeiyuan on 16/9/1.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "KMUIViewController.h"
#import "AppDelegate+BATShare.h"


@interface KMUIViewController ()

@end

@implementation KMUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBackButton];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"indexbg"];
    imageView.tag = 2018007;
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    // Called when the view is about to made visible. Default does nothing
    [super viewWillAppear:animated];
    if (IS_IOS10) {
        UIImage *image = [KMTools createImageWithColor:[UIColor clearColor]];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:image];
    }
    else
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 自定义按钮
//返回
- (void) initBackButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 40);
    [btn setImage:[UIImage imageNamed:@"nav_back_bg"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barItem;
}

- (void)deleteBackButton
{
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)btnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//帮助
-(void)initHelpButton:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 40);
    [btn setImage:[UIImage imageNamed:@"nav_help_bg"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -20)];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barItem;
}

//刷新
-(void)initRefreshButton:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 40);
    [btn setImage:[UIImage imageNamed:@"nav_refresh_bg"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -20)];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barItem;
}

//返回上一个web页面
-(void)initBackLastWebButton:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 40);
    [btn setImage:[UIImage imageNamed:@"nav_back_bg"] forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barItem;
}

-(void)addRightButton:(SEL)action image:(UIImage *)image
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 40);
    [rightBtn setImage:image forState:UIControlStateNormal];
    [rightBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -20)];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = barItem;
}

-(void)addRightButton:(SEL)action titile:(NSString *)str titleColor:(UIColor *)color
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 40);
    [rightBtn setTitle:str forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:AppFontHelvetica size:17];
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -20)];

    if (color) {
        [rightBtn setTitleColor:color forState:UIControlStateNormal];
    }
    [rightBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = barItem;
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
