//
//  BodyDataViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 2017/2/9.
//  Copyright © 2017年 woaiqiu947. All rights reserved.
//

#import "BodyDataViewController.h"
#import "InputBodyDataView.h"
#import "ZFGenericAxis.h"
#import "ZFCircle.h"
#import "BFRViewController.h"
#import "BodyHudView.h"
#import "BATLoginViewController.h"
@interface BodyDataViewController ()

@end

#define keyArray  @[@"Waist", @"Height", @"Weight", @"Fat"]

@implementation BodyDataViewController

- (void)dealloc
{
    inputView.delegate = nil;
    sexAgeView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"体脂率";
    dataDict = [NSMutableDictionary new];
    valueDict = [NSMutableDictionary new];
    dateDict = [NSMutableDictionary new];
    if (IS_IPHONE_X)
    {
        segmentedConstraint.constant = 89;
    }
//    myScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [mySegmentedView addTarget:self action:@selector(chartSegmentAction:)
            forControlEvents:UIControlEventValueChanged];
    //[self getBodyDataList:EBodyDataTimePeriodStatusWeek];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self stautsBarHidde];
    [self judgeLoginStation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    isGoBFRView = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self dismissProgress];
    if (!isGoBFRView) {
        [inputView removeAllSubview];
        [sexAgeView removeAllSubview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initPagesChart
{
    CGFloat chartHeigth = 130.f;
    CGFloat intervalHeigth = 35.f;
    CGFloat chartWidth = MainScreenWidth-10;
    CGFloat chartMaxY = 0.f;
    CGFloat chartMinX = 5.f;
    NSArray *titleArray = @[@"腰围", @"身高", @"体重", @"体脂率"];
    CGFloat maskButtonW = 80.f;
    CGFloat maskButtonX = (chartWidth - maskButtonW)/2;
    for (int i = 0; i < [titleArray count]; i++)
    {
        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, chartHeigth*i+i*(intervalHeigth+10), MainScreenWidth, chartHeigth+intervalHeigth)];
        cellView.backgroundColor = RGBA(66, 179, 255, 0.2);
        cellView.tag = 200+i;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(chartMinX, 0, 60, 30)];
        label.text = titleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = AppFontYellowColor;
        label.hidden = YES;
        label.tag = 11;
        [cellView addSubview:label];
        
        ZFLineChart *lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(chartMinX,30, chartWidth, chartHeigth)];
        lineChart.backgroundColor = [UIColor clearColor];
        lineChart.dataSource = self;
        lineChart.delegate = self;
        lineChart.isResetAxisLineMinValue = NO;
        lineChart.isShowAxisLineValue = NO;
//        lineChart.isShowSeparate = YES;
        lineChart.tag = i;
        lineChart.clipsToBounds = YES;
        lineChart.isDefaulfShow = NO;
        lineChart.isShowAxisLineValue = YES;
        lineChart.isShadowForValueLabel = NO;
        lineChart.axisLineNameColor = AppFontGrayColor;
        lineChart.axisLineValueColor = AppFontColor;
        lineChart.hidden = YES;
        [lineChart strokePath];
        [cellView addSubview:lineChart];
        [myScrollView addSubview: cellView];
        chartMaxY = CGRectGetMaxY(cellView.frame);
        
        UIView *maskView = [[UIView alloc] initWithFrame:cellView.bounds];
//        maskView.backgroundColor = [UIColor whiteColor];
//        maskView.hidden = YES;
        maskView.tag = 10;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, chartWidth, 30)];
        titleLabel.text = titleArray[i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = AppFontYellowColor;
        [maskView addSubview:titleLabel];
        
        UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), chartWidth, 50)];
        detailsLabel.text = [NSString stringWithFormat:@"你还没有%@记录,从今天开始记录吧",titleArray[i]];
        detailsLabel.numberOfLines = 2;
        detailsLabel.textAlignment = NSTextAlignmentCenter;
        detailsLabel.textColor = AppFontColor;
        [maskView addSubview:detailsLabel];
        
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(MainScreenWidth-60, 0, 60, 30);
        button.tag = i;
        [button addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:button];
        
        if (i< [titleArray count]-1) {
            [button setImage:[UIImage imageNamed:@"addright_normal_icon"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"addright_selected_icon"] forState:UIControlStateHighlighted];
            
            UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
            addButton.frame = CGRectMake(maskButtonX, CGRectGetMaxY(detailsLabel.frame), maskButtonW, maskButtonW);
            [addButton setImage:[UIImage imageNamed:@"addcenter_normal_icon"] forState:UIControlStateNormal];
            [addButton setImage:[UIImage imageNamed:@"addcenter_selected_icon"] forState:UIControlStateHighlighted];
            addButton.tag = i;
            [addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [maskView addSubview:addButton];
        }
        else
        {
            [button setImage:[UIImage imageNamed:@"info_prompt_icon"] forState:UIControlStateNormal];
            
            detailsLabel.text = @"体脂率与体重和身高有关\n请添加体重和身高数据";
            CGRect titleRect = titleLabel.frame;
            titleRect.origin.y = titleRect.origin.y + 30;
            titleLabel.frame = titleRect;
            
            CGRect detailsRect = detailsLabel.frame;
            detailsRect.origin.y = detailsRect.origin.y + 30;
            detailsLabel.frame = detailsRect;
            
            UIButton *hudButton = [UIButton buttonWithType:UIButtonTypeCustom];
            hudButton.frame = CGRectMake(CGRectGetMaxX(label.frame), 0, 60, 30);
            [hudButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
            [hudButton setImage:[UIImage imageNamed:@"info_tips_icon"] forState:UIControlStateNormal];
            [hudButton addTarget:self action:@selector(showHudAction:) forControlEvents:UIControlEventTouchUpInside];
            hudButton.tag = 15;
            [cellView addSubview:hudButton];            
        }
        [cellView addSubview:maskView];
    }
    [myScrollView setContentSize:CGSizeMake(0, chartMaxY+10)];
    sexAgeView = [[SexAndAgeInputView alloc] init];
    sexAgeView.delegate = self;
    inputView = [[InputBodyDataView alloc] init];
    inputView.delegate = self;
}

- (void)reloadStrokePath
{
    for (UIView *elem in myScrollView.subviews)
    {
        if (elem.tag > 199)
        {
            for (UIView *view in elem.subviews)
            {
                if ([view isKindOfClass:[ZFLineChart class] ])
                {
                    ZFLineChart *chartView = (ZFLineChart *)view;
                    NSString  *key = keyArray[chartView.tag];
                    NSArray *array = valueDict[key];
                    UIView *maskView = [elem viewWithTag:10];
                    UIView *label = [elem viewWithTag:11];
                    UIView *hud = [elem viewWithTag:15];
                    UIView *button = nil;

                    for (UIView *view in elem.subviews) {
                        if ([view isKindOfClass:[UIButton class]] && view.tag != 15) {
                            button = view;
                        }
                    }
                    if ([array count]==0) {
                        maskView.hidden = NO;
                        label.hidden = YES;
                        chartView.hidden = YES;
                        hud.hidden = YES;
                        button.hidden = YES;
                    }
                    else
                    {
                        maskView.hidden = YES;
                        label.hidden = NO;
                        chartView.hidden = NO;
                        hud.hidden = NO;
                        button.hidden = NO;
                    }
                    [chartView strokePath];
                }
            }
        }
    }
}

#pragma mark - UISegmentedControl
-(void)chartSegmentAction:(UISegmentedControl *)segmented{
//    [sexAgeView presentSexAndAgeInputView];
    NSInteger Index = segmented.selectedSegmentIndex;
    segmented.enabled = NO;
     [self getBodyDataList:Index+1];
}

#pragma mark - Add Button
- (void)showHudAction:(UIButton *)button
{
    UIView *view = [myScrollView viewWithTag:203];
    CGFloat rectY = CGRectGetMinY(view.frame)+CGRectGetHeight(button.frame)-myScrollView.contentOffset.y + kStatusAndNavHeight + 15+CGRectGetHeight(mySegmentedView.frame);
    [BodyHudView presentBodyHudView:rectY];
}

- (void)addButtonAction:(UIButton *)sender
{
    if (sender.tag < [keyArray count]-1) {
        NSString  *key = keyArray[sender.tag];
        NSArray *array = dateDict[key];
        NSString *lastDateStr = [array lastObject];
        NSString *dateValue = [KMTools getStringFromDate:[NSDate date]];
        NSString * dateStr = [dateValue substringWithRange:NSMakeRange(5, 5)];
        if ([lastDateStr isEqualToString:dateStr])
        {
            isChangeData = YES;
        }
        else
        {
            isChangeData = NO;
        }
        [inputView presentInputView:sender.tag];
    }
    else
    {
        isGoBFRView = YES;
        UIStoryboard *sboard = [KMTools getStoryboardInstance];
        BFRViewController *workGradeViewController = [sboard instantiateViewControllerWithIdentifier:@"BFRViewController"];
        [self.navigationController pushViewController:workGradeViewController animated:YES];
    }
}

#pragma mark - InputBodyDataView Delegate
- (void)inputViewType:(InputBodyDataView *)inputBodyDataView inputViewType:(EInputViewType)type saveValue:(NSString *)value
{
    NSString *typeStr = [NSString stringWithFormat:@"%li",type+1];

    if (isChangeData) {
        NSString  *key = keyArray[type];
        NSArray *valueArray = valueDict[key];
        NSArray *dataArray = dataDict[key];
        NSString *lastValueStr = [valueArray lastObject];
        NSDictionary *dic = [dataArray lastObject];
        __block NSString *idStr = [NSString stringWithFormat:@"%@",dic[@"ID"]];
        NSArray *titleArray = @[@"腰围", @"身高", @"体重", @"体脂率"];
        NSString *titleStr = titleArray[type];
        NSString *messageStr = [NSString stringWithFormat:@"是否替换%@数据%@", titleStr, lastValueStr];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:messageStr preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self editBodyFatDataID:idStr dataTypeId:typeStr dataValue:value];
            }];
            [alertController addAction:sureAction];
            UIAlertAction *canleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:canleAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
    else
    {
        [self editBodyFatDataID:IDStr dataTypeId:typeStr dataValue:value];
    }
}

#pragma mark - SexAndAgeInputView Delegate
- (void)sexAndAgeInputView:(SexAndAgeInputView *)sexAndAgeInputView sexValue:(NSString *)sexValue ageValue:(NSString *)ageValue
{
    sexStr = sexValue;
    NSString *dateStr = [KMTools getStringFromDate:[NSDate date]];
    NSString *yearStr = [dateStr substringToIndex:4];
    NSInteger birthDayYear = [yearStr integerValue] - [ageValue integerValue];
    birthdayStr = [NSString stringWithFormat:@"%li-01-01",birthDayYear];
    [self editBodyFatDataID:@"" dataTypeId:@"5" dataValue:@""];
}

#pragma mark - ZFGenericChartDataSource
- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    NSString  *key = keyArray[chart.tag];
    NSArray *array = valueDict[key];
//    return @[@"37", @"35", @"40"];
    return array;
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    NSString  *key = keyArray[chart.tag];
    NSArray *array = dateDict[key];
//    return @[@"37", @"35", @"40"];
    return array;
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[AppChartBGColor];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 200;
}

- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart{
    return 0;
}

- (NSUInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 5;
}

#pragma mark - ZFLineChartDelegate

- (CGFloat)groupWidthInLineChart:(ZFLineChart *)lineChart{
    return 30.f;
}

- (CGFloat)paddingForGroupsInLineChart:(ZFLineChart *)lineChart{
    return 5.f;
}

- (CGFloat)circleRadiusInLineChart:(ZFLineChart *)lineChart{
    return 5.f;
}

- (CGFloat)lineWidthInLineChart:(ZFLineChart *)lineChart{
    return 2.f;
}

- (NSArray *)valuePositionInLineChart:(ZFLineChart *)lineChart{
    return @[@(kChartValuePositionOnTop)];
}

- (void)lineChart:(ZFLineChart *)lineChart didSelectCircleAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex{
    for (UIView *elem in lineChart.subviews) {
        if ([elem isKindOfClass: [ZFGenericAxis class]])
        {
            for (UIView *view in elem.subviews) {
                if ([view isKindOfClass:[ZFPopoverLabel class]]) {
                    ZFPopoverLabel *label = (ZFPopoverLabel *)view;
                    if (label.labelIndex == circleIndex) {
                        label.hidden = NO;
                    }
                    else
                    {
                        label.hidden = YES;
                    }
                }
                else if([view isKindOfClass:[ZFCircle class]])
                {
                    ZFCircle *circle = (ZFCircle *)view;
                    if (circle.circleIndex == circleIndex) {
                        circle.circleColor = [UIColor whiteColor];
                    }
                    else
                    {
                        circle.circleColor = AppChartBGColor;
                    }
                    circle.strokeColor = AppChartBGColor;
                    [circle strokePath];
                }
            }
        }
    }
}

- (void)lineChart:(ZFLineChart *)lineChart didSelectPopoverLabelAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex{
    for (UIView *elem in lineChart.subviews) {
        if ([elem isKindOfClass: [ZFGenericAxis class]])
        {
            for (UIView *view in elem.subviews) {
                if ([view isKindOfClass:[ZFPopoverLabel class]]) {
                    ZFPopoverLabel *label = (ZFPopoverLabel *)view;
                    if (label.labelIndex == circleIndex) {
                        label.hidden = NO;
                    }
                    else
                    {
                        label.hidden = YES;
                    }
                }
                else if([view isKindOfClass:[ZFCircle class]])
                {
                    ZFCircle *circle = (ZFCircle *)view;
                    if (circle.circleIndex == circleIndex) {
                        circle.circleColor = [UIColor whiteColor];
                    }
                    else
                    {
                        circle.circleColor = AppChartBGColor;
                    }
                    circle.strokeColor = AppChartBGColor;
                    [circle strokePath];
                }
            }
        }
    }
}

- (void)lineChart:(ZFLineChart *)lineChart didLongPressSelectCircleAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex
{
    for (UIView *elem in lineChart.subviews) {
        if ([elem isKindOfClass: [ZFGenericAxis class]])
        {
            for (UIView *view in elem.subviews) {
                if ([view isKindOfClass:[ZFPopoverLabel class]]) {
                    ZFPopoverLabel *label = (ZFPopoverLabel *)view;
                    if (label.labelIndex == circleIndex && label.hidden == NO)
                    {
                        if (lineChart.tag < [keyArray count]-1) {
                            [self presentAlertController:lineChart.tag circleIndex:circleIndex];
                            return;
                        }
                    }
                }
            }
        }
    }
}

- (void)lineChart:(ZFLineChart *)lineChart didLongPressSelectPopoverLabelAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex
{
    if (lineChart.tag < [keyArray count]-1) {
        [self presentAlertController:lineChart.tag circleIndex:circleIndex];
    }
}

#pragma mark -
- (void)presentAlertController:(NSInteger)tag circleIndex:(NSInteger)circleIndex
{
    NSString  *key = keyArray[tag];
    NSArray *array = dateDict[key];
    NSString *lastDateStr = array[circleIndex];
    NSString *dateValue = [KMTools getStringFromDate:[NSDate date]];
    NSString * dateStr = [dateValue substringWithRange:NSMakeRange(5, 5)];
    if (![lastDateStr isEqualToString:dateStr])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除此条数据,删除后不可恢复" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSString  *key = keyArray[tag];
                NSArray *array = dataDict[key];
                NSDictionary *dic = array[circleIndex];
                NSString * idValue = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ID"]];
                NSString *typeID = [NSString stringWithFormat:@"%li",tag +1];
                [self deleteBodyFatDataID:idValue dataTypeId:typeID];
            }];
            [alertController addAction:sureAction];
            UIAlertAction *canleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:canleAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
}

- (void)stautsBarHidde
{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 *NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    });
}

- (void)judgeLoginStation
{
    if (!LOGIN_STATION) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"本功能需要登录账户才可使用" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [TalkingData trackEvent:@"2200001" label:@"我的>登录/注册"];
                    BATLoginViewController *heartTrendViewController = [[BATLoginViewController alloc] init];
                    heartTrendViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:heartTrendViewController animated:YES];
                });
            }];
            [alertController addAction:sureAction];
            UIAlertAction *canleAction = [UIAlertAction actionWithTitle:@"退出本页面" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
            [alertController addAction:canleAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
    else
    {
        if (!sexAgeView)
        {
            [self initPagesChart];
            [self reloadStrokePath];
            [self IsExistBodyFat];
        }
    }
}
#pragma mark - 接口
// 是否第一次输入
- (void)IsExistBodyFat
{

    dispatch_async(dispatch_get_main_queue(), ^{
        [self showProgressWithText:@"请稍后"];
    });
    [HTTPTool requestWithURLString:@"/api/HealthManager/IsExistBodyFat" parameters:nil showStatus:YES type:kGET success:^(id responseObject) {
        NSString *code = [responseObject objectForKey:@"ResultCode"];
        [self dismissProgress];
        if ([code integerValue] == 0)
        {
            NSDictionary *data = [responseObject objectForKey:@"Data"];
            if([data isKindOfClass:[NSDictionary class]])
            {
                if ([data.allKeys containsObject:@"Sex"]) {
                    sexStr = [data objectForKey:@"Sex"];
                    birthdayStr = [data objectForKey:@"Birthday"];
                    IDStr = [data objectForKey:@"ID"];
                    [self getBodyDataList:EBodyDataTimePeriodStatusWeek];
                }
                else
                {
                    [sexAgeView presentSexAndAgeInputView];
                }
            }
            else
            {
                [sexAgeView presentSexAndAgeInputView];
            }
        }
        else
        {
        }
        mySegmentedView.enabled = YES;
    } failure:^(NSError *error) {
        mySegmentedView.enabled = YES;
    }];
}


//获取 体脂数据列表
- (void)getBodyDataList:(EBodyDataTimePeriod)type
{
   //
    NSString *dateType = @"";
    switch (type) {
        case EBodyDataTimePeriodStatusWeek:
            dateType = @"1";
            break;
        case EBodyDataTimePeriodStatusMonth:
            dateType = @"2";
            break;
        case EBodyDataTimePeriodStatusYear:
            dateType = @"3";
            break;
            
        default:
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showProgressWithText:@"请稍后"];
    });
    NSDictionary *dic = @{@"dateType":dateType};
    [HTTPTool requestWithURLString:@"/api/HealthManager/GetBodyFatList" parameters:dic showStatus:YES type:kGET success:^(id responseObject) {
        NSString *code = [responseObject objectForKey:@"ResultCode"];
        [self dismissProgress];
        [valueDict removeAllObjects];
        [dateDict removeAllObjects];
        if ([code integerValue] == 0)
        {
            dataDict = [responseObject objectForKey:@"Data"];
//            NSLog(@"=== %@",dataDict);
            for (NSString  *key in keyArray) {
                NSArray * array = dataDict[key];
                NSMutableArray *addValueArray = [NSMutableArray new];
                NSMutableArray *addDateArray = [NSMutableArray new];
                for (NSDictionary *elemDic in array)
                {
                    NSString *value = @"";
                    if ([key isEqualToString:@"Fat"]) {
                        value = [NSString stringWithFormat:@"%@",elemDic[@"BodyFat"]];
                    }
                    else
                    {
                        value = [NSString stringWithFormat:@"%@",elemDic[key]];
                        float valueDouble = [value floatValue];
                        value = [NSString stringWithFormat:@"%.1f",valueDouble];
//                        value = [KMTools notRounding:valueDouble  afterPoint:1];
                    }
                    NSString *dateValue = elemDic[@"CreatedTime"];
                    NSString *dateStr = [dateValue substringWithRange:NSMakeRange(5, 5)];
                    [addValueArray addObject:value];
                    [addDateArray addObject:dateStr];
                }
                [valueDict setObject:addValueArray forKey:key];
                [dateDict setObject:addDateArray forKey:key];
            }
            if ([valueDict count] > 0) {
                [self reloadStrokePath];

            }
        }
        mySegmentedView.enabled = YES;
    } failure:^(NSError *error) {
        mySegmentedView.enabled = YES;
    }];
}

//添加和修改
- (void)editBodyFatDataID:(NSString *)dataID dataTypeId:(NSString *)typeId dataValue:(NSString *)dataValue
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showProgressWithText:@"请稍后"];
    });
    NSDictionary *dic = @{@"ID":dataID,
                          @"BodyText":dataValue,
                          @"TypeId":typeId,
                          @"Sex":sexStr,
                          @"Birthdays":birthdayStr
                          };
    
    [HTTPTool requestWithURLString:@"/api/HealthManager/EditBodyFat" parameters:dic showStatus:YES type:kPOST success:^(id responseObject) {
        NSString *code = [responseObject objectForKey:@"ResultCode"];
        [self dismissProgress];
        if ([code integerValue] == 0)
        {
            NSString *Data = [responseObject objectForKey:@"Data"];
            if ([Data integerValue] > 0) {
                IDStr = Data ;
            }
            NSInteger Index = mySegmentedView.selectedSegmentIndex;
            [self getBodyDataList:Index+1];
        }
        else
        {
            [self showText: [dic objectForKey:@"ResultMessage"]];
        }
        mySegmentedView.enabled = YES;
    } failure:^(NSError *error) {
        mySegmentedView.enabled = YES;
    }];
}

//删除
-(void)deleteBodyFatDataID:(NSString *)dataID dataTypeId:(NSString *)typeId
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showProgressWithText:@"请稍后"];
    });
    NSDictionary *dic = @{@"ID":dataID,
                          @"TypeId":typeId,
                          };
    
    [HTTPTool requestWithURLString:@"/api/HealthManager/DeleteBodyFat" parameters:dic showStatus:YES type:kGET success:^(id responseObject) {
        NSString *code = [responseObject objectForKey:@"ResultCode"];
        [self dismissProgress];
        if ([code integerValue] == 0)
        {
            NSInteger Index = mySegmentedView.selectedSegmentIndex;
            [self getBodyDataList:Index+1];
        }
        else
        {
            //[self showText:@"请稍后"];
        }
    } failure:^(NSError *error) {
    }];

}

@end
