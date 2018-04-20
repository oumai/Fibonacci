//
//  AddBloodSugarViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/12/14.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "AddBloodSugarViewController.h"
#import "BloodSugarNoteViewController.h"
#import "BloodSugarValueHUD.h"
@interface AddBloodSugarViewController ()

@end

@implementation AddBloodSugarViewController
@synthesize previewModel = _previewModel;

- (void)dealloc
{
    myTableView.delegate = nil;
    birthDayPickerView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HidePickerView)
                                                 name:@"HidePickerView"
                                               object:nil];
    if (_previewModel) {
        isPreview = YES;
        noteStr = _previewModel.note;
    }
    else
    {
        [self addRightButton:@selector(saveBloodSugarData) titile:@"保存" titleColor:AppFontColor];
    }
    [self pagesLayout];
    self.title = @"胰岛素";
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self viewDidAppearViewData];
    NSString *FirstGoBloodSugarValue = [[NSUserDefaults standardUserDefaults] valueForKey:@"FirstGoAddBloodSugar"];
    if (FirstGoBloodSugarValue.length == 0)
    {
        [self fristOpenVC];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
-(void)pagesLayout
{
    CGFloat minY = 0;
    if (self.navigationController.navigationBar.translucent&&!self.extendedLayoutIncludesOpaqueBars) {
        minY = kStatusAndNavHeight;
    }
    WEAK_SELF(self);
    
    
    segmentScrollView = [[UIScrollView alloc] init];
    segmentScrollView.showsVerticalScrollIndicator = NO;
    segmentScrollView.showsHorizontalScrollIndicator = NO;
    segmentScrollView.bounces = YES;
    segmentScrollView.backgroundColor = RGBA(21, 34, 100, 0.2);
    CGFloat buttonW = MainScreenWidth/6;
    NSInteger type = [_previewModel.timeScale integerValue];
    NSArray *segmentTitleArray = @[@"早餐前",@"早餐后",@"午餐前",@"午餐后",@"晚餐前",@"晚餐后", @"睡前", @"凌晨", @"随机"];
    if (type > [segmentTitleArray count])
    {
        type = [segmentTitleArray count];
    }
    [segmentScrollView setContentSize:CGSizeMake(buttonW *[segmentTitleArray count], 0)];
    for (int i = 0; i < [segmentTitleArray count]; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonW*i, 0, buttonW, 43);
        [button setTitle:segmentTitleArray[i] forState:UIControlStateNormal];
        if (isPreview)
        {
            if (i == type-1) {
                button.selected = YES;
                [button setTitleColor:AppFontYellowColor forState:UIControlStateNormal];
            }
            else
            {
                [button setTitleColor:AppFontColor forState:UIControlStateNormal];
            }
            if (type >6) {
                [segmentScrollView setContentOffset:CGPointMake(buttonW *3, 0) animated:NO];
            }
            else
            {
                [segmentScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            }
        }
        else
        {
            if (i==  [segmentTitleArray count]-1)
            {
                button.selected = YES;
                [button setTitleColor:AppFontYellowColor forState:UIControlStateNormal];
            }
            else
            {
                [button setTitleColor:AppFontColor forState:UIControlStateNormal];
            }
            button.tag = i+1;
            [segmentScrollView setContentOffset:CGPointMake(buttonW *i, 0) animated:NO];
            [button addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        timeScale = [NSString stringWithFormat:@"9"];
        [segmentScrollView addSubview:button];
    }
    CGFloat buttonCount = 0.f;
    if (isPreview) {
        buttonCount = type-1;
    }
    else
    {
        buttonCount = [segmentTitleArray count]-1;
    }
    lineLayer = [CALayer layer];
    lineW = buttonW/2;
    lineX = (buttonW-lineW)/2;
    lineLayer.frame = CGRectMake(buttonW *buttonCount+lineX, 42, lineW, 3);
    lineLayer.backgroundColor = [AppFontYellowColor CGColor];
    [segmentScrollView.layer addSublayer:lineLayer];
    
    [self.view addSubview:segmentScrollView];
    [segmentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(minY);
        make.height.mas_equalTo(45);
    }];
    
    CGFloat waterW = MainScreenWidth/1.45;
    bloodSugarSlider = [[BloodSugarSlider alloc]init];
    if (isPreview) {
        CGFloat value = [_previewModel.value_id floatValue];
        bloodSugarSlider.angle = value;
    }
    bloodSugarSlider.backgroundColor = [UIColor clearColor];
    bloodSugarSlider.tag = 1001;
    bloodSugarSlider.colorType = EBloodSugarSliderColorTypeHeight;
    [self.view addSubview:bloodSugarSlider];
    [bloodSugarSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(segmentScrollView.mas_bottom).offset(60);
        make.height.mas_equalTo(waterW);
        make.width.mas_equalTo(waterW);
    }];

    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth,150 ) style:UITableViewStylePlain];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.rowHeight = 50;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.scrollEnabled = NO;
    [myTableView setBackgroundView:nil];
    [myTableView setBackgroundView:[[UIView alloc]init]];
    myTableView.backgroundView.backgroundColor = [UIColor clearColor];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorColor = RGB(41, 41, 88);
    [self.view addSubview:myTableView];
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(150);
    }];
}

- (void)viewDidAppearViewData
{
//    if (isPreview) {
//        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, waterW, waterW)];
//        [bloodSugarSlider addSubview:maskView];
//    }
    if (birthDayPickerView) {
        return;
    }
    birthDayPickerView = [[BATBirthDayPickerView alloc] initWithFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, 256) type:EBirthDayTypeDateAndTime];
    birthDayPickerView.delegate = self;
    [self.view addSubview: birthDayPickerView];
}
#pragma mark - Action
-(void)segmentAction:(UIButton *)button
{
    for (UIView *elem in segmentScrollView.subviews) {
        if ([elem isKindOfClass:[UIButton class]])
        {
            UIButton *elemButton = (UIButton *)elem;
            [elemButton setTitleColor: AppFontColor forState:UIControlStateNormal];
            button.selected = NO;
        }
    }
    button.selected = YES;
    [button setTitleColor:AppFontYellowColor forState:UIControlStateNormal];
    
    [UIView beginAnimations:nil context:nil];
    lineLayer.frame = CGRectMake(button.frame.origin.x+lineX , 42, lineW, 3);
    [UIView commitAnimations];
    
    if (button.tag == 1 || button.tag == 3 ||button.tag == 5) {
        bloodSugarSlider.colorType = EBloodSugarSliderColorTypeDefault;
    }
    else
    {
        bloodSugarSlider.colorType = EBloodSugarSliderColorTypeHeight;
    }
    timeScale = nil;
    timeScale = [NSString stringWithFormat:@"%li",button.tag];
}

- (void)saveBloodSugarData
{
    if (bloodSugarSlider.angle == 0)
    {
        [self showText:@"请输入血糖值"];
        return;
    }
    NSNumber *valueNumber = [NSNumber numberWithFloat:bloodSugarSlider.angle];
    NSString *timerString  = @"";
    if (dateStr.length <17) {
        timerString = [NSString stringWithFormat:@"%@:%@",dateStr,secondStr];
    }
    else
    {
        timerString = dateStr;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL result = [[KMDataManager sharedDatabaseInstance] insertBloodSugarDataModelFromNumber:valueNumber note:noteStr timeScale:timeScale timer:timerString upload:NO];
        if (result) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AddBloodSugar" object:nil];
            });
            
            
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 *NSEC_PER_SEC));
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [BloodSugarValueHUD presentViewFromValue:bloodSugarSlider.angle type:bloodSugarSlider.colorType];

                //[self.navigationController popViewControllerAnimated:YES];
            });
            
        }
    });
    
}

#pragma mark - 
- (void)BloodSugarNoteViewController:(BloodSugarNoteViewController *)birthDayPickerView noteString:(NSString *)noteString
{
    noteStr = nil;
    noteStr = noteString;
    NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:2 inSection:0];
    [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - BATBirthDayPickerViewDelegate
- (void)BATBirthDayPickerView:(BATBirthDayPickerView *)birthDayPickerView didSelectDateString:(NSString *)dateString
{
    dateStr = dateString;
    NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:1 inSection:0];
    [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:AppFontHelvetica size:14];
        cell.textLabel.textColor = AppFontColor;
        cell.backgroundColor = [UIColor clearColor];
    }
    switch (indexPath.row) {
        case 1:
        {
            NSString *strTime = @"";
            if (isPreview) {
                strTime = [KMTools getStringFromInterval:[_previewModel.timeInterval doubleValue]];
            }
            else
            {
                if (dateStr.length > 0)
                {
                    strTime = dateStr;
                }
                else
                {
                    NSTimeZone *zone = [NSTimeZone systemTimeZone];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setTimeZone:zone];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    strTime = [formatter stringFromDate:[NSDate date]];
                    dateStr = strTime;
                }
            }

            cell.textLabel.text = [self stringFormatterStr:strTime];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 2:
        {
            
            if (noteStr.length == 0)
            {
                cell.textLabel.text = @"添加备注";
            }
            else
            {
                cell.textLabel.text = noteStr;
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 设置需要的偏移量,这个UIEdgeInsets左右偏移量不要太大，不然会titleLabel也会偏移的。
    UIEdgeInsets inset = UIEdgeInsetsMake(0, -20, 0, 20);
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) { // iOS8的方法
            // 设置边界为0，默认是{8,8,8,8}
        [cell setLayoutMargins:inset];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:inset];

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 1:
        {
            if (!isPreview) {
                [birthDayPickerView show];
            }
        }
            break;
        case 2:
        {
            UIStoryboard *sboard = [KMTools getStoryboardInstance];
            BloodSugarNoteViewController *bloodSugarViewController = [sboard instantiateViewControllerWithIdentifier:@"BloodSugarNoteViewController"];
            bloodSugarViewController.hidesBottomBarWhenPushed = YES;
            bloodSugarViewController.delegate = self;
            bloodSugarViewController.noteString = noteStr;
            bloodSugarViewController.isPreviewType = isPreview;
            [self.navigationController pushViewController:bloodSugarViewController animated:YES];
            [birthDayPickerView hide];
        }
            
        default:
            break;
    }
}

- (NSString *)stringFormatterStr:(NSString *)str
{
    NSCharacterSet *setSeparate = [NSCharacterSet characterSetWithCharactersInString:@" "];
    NSArray *array = [str componentsSeparatedByCharactersInSet:setSeparate];
    if ([array count] >1) {
        NSString *timeStr = array[1];
        NSCharacterSet *separate = [NSCharacterSet characterSetWithCharactersInString:@":"];
        NSArray *timerArray = [timeStr componentsSeparatedByCharactersInSet:separate];
        if ([timerArray count] >2) {
            secondStr = timerArray[2];
        }
        NSString *addStr = @"上午";
        int b= [[timeStr substringWithRange:NSMakeRange(0,2)] intValue];
        if (b > 12)
        {
            addStr = @"下午";
        }
        NSString *returnStr =[NSString stringWithFormat:@"%@ %@ %@:%@",array[0], addStr, timerArray[0],timerArray[1]];
        return returnStr;
    }
    return str;
}

- (void)HidePickerView
{
    [birthDayPickerView hide];
}

#pragma mark -
#pragma mark - fristOpenVC
-(void)fristOpenVC
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *maskview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    maskview.backgroundColor = RGBA(0, 0, 0, 0.5);
    maskview.tag = 3000;
    [window addSubview:maskview];
    
    CGFloat waterW = MainScreenWidth/1.45;
    BloodSugarSlider *waterView = [[BloodSugarSlider alloc]initWithFrame:CGRectMake((MainScreenWidth-waterW)/2, kStatusAndNavHeight+60+45, waterW, waterW)];
    waterView.backgroundColor = [UIColor clearColor];
    [maskview addSubview:waterView];
    
    UIView *waterMaskView = [[UIView alloc] initWithFrame:waterView.frame];
    waterMaskView.backgroundColor = [UIColor clearColor];
    [maskview addSubview:waterMaskView];
    
    UIImageView *arrowBG = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth/2-133/2, CGRectGetMaxY(waterView.frame)-30, 133, 155)];
    arrowBG.image = [UIImage imageNamed:@"slideguide"];
    [maskview addSubview:arrowBG];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissMask:)];
    [maskview addGestureRecognizer:tapGesture];
}

-(void)fristOpenVC2
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *maskview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    maskview.backgroundColor = RGBA(0, 0, 0, 0.5);
    maskview.tag = 3000;
    [window addSubview:maskview];

    CGFloat waterW = MainScreenWidth/1.45;
    CGFloat viewX = waterW/2;
    CGFloat viewY = viewX +kStatusAndNavHeight+60+45;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((MainScreenWidth-viewX)/2,viewY-viewX/2, viewX, viewX)];
    view.layer.cornerRadius = viewX/2;
    view.backgroundColor = RGBA(255, 255, 255, 1);
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.colors = @[(__bridge id)RGB(254, 112, 167).CGColor,(__bridge id)RGB(253, 80, 137).CGColor];
    gradientLayer.startPoint = CGPointMake(1, 1);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = view.bounds;
    gradientLayer.cornerRadius = view.frame.size.height/2;
    [view.layer insertSublayer:gradientLayer atIndex:0];
    
    CGFloat fontSize = 70;
    CGFloat textY = viewX*0.26;
    if (iPhone5) {
        fontSize = 50;
        textY = viewX*0.20;
    }
    UILabel *_textField = [[UILabel alloc] initWithFrame:CGRectMake(0, textY, viewX, 60)];
    _textField.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    _textField.text = @"0.0";
    _textField.textColor = [UIColor whiteColor];
    _textField.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_textField];
    
    CGFloat mmolY = CGRectGetMaxY(_textField.frame);
    CGFloat mmolH = 30;
    if (iPhone5) {
        mmolY = mmolY-10;
        mmolH = 20;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, mmolY, viewX, mmolH)];
    label.text = @"mmol/L";
    label.font = [UIFont fontWithName:@"Helvetica" size:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    [maskview addSubview:view];
    
    UIImageView *arrowBG = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth/2-210/2, CGRectGetMaxY(view.frame)-30, 210, 113)];
    arrowBG.image = [UIImage imageNamed:@"imputguide"];
    [maskview addSubview:arrowBG];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissMask2:)];
    [maskview addGestureRecognizer:tapGesture];
}

- (void)dismissMask:(id)sender
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (UIView *elem in window.subviews) {
        if (elem.tag == 3000) {
            [UIView animateWithDuration:0.3
                             animations:^(void) {
                                 elem.alpha = 0.f;
                             } completion:^(BOOL completed) {
                                 while ([elem.subviews lastObject] != nil) {
                                     [(UIView*)[elem.subviews lastObject] removeFromSuperview];
                                 }
                                 [elem removeFromSuperview];
                                 [self fristOpenVC2];
                             }];
        }
    }
}

- (void)dismissMask2:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"FirstGoAddBloodSugar"];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (UIView *elem in window.subviews) {
        if (elem.tag == 3000) {
            [UIView animateWithDuration:0.3
                             animations:^(void) {
                                 elem.alpha = 0.f;
                             } completion:^(BOOL completed) {
                                 while ([elem.subviews lastObject] != nil) {
                                     [(UIView*)[elem.subviews lastObject] removeFromSuperview];
                                 }
                                 [elem removeFromSuperview];
                             }];
        }
    }
}
//#pragma mark -
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    CGFloat value = [textField.text floatValue];
//    bloodSugarSlider.angle = value; 
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
