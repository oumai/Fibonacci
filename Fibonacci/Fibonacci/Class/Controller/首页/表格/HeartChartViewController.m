//
//  HeartChartViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/29.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "HeartChartViewController.h"
#import "HeartRateDataModel.h"
#import "BloodPressureDataModel.h"
#import "BloodOxygenDataModel.h"
#import "VisionDataModel.h"
#import "VitalCapacityDataModel.h"
#import "HealthKitManage.h"
#import "BloodSugarDataModel.h"
#import <objc/message.h>

@interface HeartChartViewController ()

@end

@implementation HeartChartViewController

- (void)dealloc
{
    lineChartView.dataSource = nil;
    lineChartView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    valueArray = [NSMutableArray new];
    dateArray = [NSMutableArray new];
    numberArray = [NSMutableArray new];
    modelArray = [NSMutableArray new];
    
    myChartView.backgroundColor = [UIColor clearColor];

    if (IS_IPHONE_X)
    {
        segmentConstraint.constant = 89;
    }
    [mySegmentView addTarget:self action:@selector(mySegmentAction:)
            forControlEvents:UIControlEventValueChanged];
    myTableView.rowHeight = 50;
    myTableView.backgroundView = [[UIView alloc]init];
    myTableView.backgroundView.backgroundColor = [UIColor clearColor];
    myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    myTableView.separatorColor = RGB(41, 41, 88);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setChartViewAndGetDate];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self dismissProgress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setChartViewAndGetDate
{
    if (onceInit) {
        return;
    }
    CGFloat chartHeight = 225.f;
    
    onceInit = YES;
    valueHudView.clipsToBounds = YES;
    valueHudView.layer.cornerRadius = 5;
    valueHudView.backgroundColor = [UIColor clearColor];
    lineChartView = [[ZFLineChart alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(valueHudView.frame)+5, MainScreenWidth-30, chartHeight)];
    lineChartView.backgroundColor = [UIColor clearColor];
    lineChartView.dataSource = self;
    lineChartView.delegate = self;
    lineChartView.isResetAxisLineMinValue = NO;
    lineChartView.isShowSeparate = YES;
    lineChartView.clipsToBounds = YES;
    lineChartView.isShowAxisLineValue = NO;
    lineChartView.axisLineNameColor = AppFontGrayColor;
    lineChartView.axisLineValueColor = AppFontGrayColor;
    //    lineChartView.isDefaulfShow = YES;
    [myChartView addSubview: lineChartView];
    [self getChartType];
}

-(void)getChartType
{
    switch (_type) {
        case EChartDataHeartRateType:
        {
            self.title = @"心率值";
        }
            break;
        case EChartDataBloodPressureType:
        {
            self.title = @"血压值";
        }
            break;
        case EChartDataHealthStepType:
        {
            self.title = @"步行值";
        }
            break;
        case EChartDataBloodOxygenType:
        {
            self.title = @"血氧值";
        }
            break;
        case EChartDataVitalCapacityType:
        {
            self.title = @"肺活量值";
        }
            break;
        case EChartDataVisionDataType:
        {
            self.title = @"视力值";
        }
            break;
        case  EChartDataBloodSugarDataType:
        {
            self.title = @"血糖";
        }
            break;
            
        default:
            break;
    }
    [self getChartDate: EDataTimePeriodStatusDay];
}

-(void)getChartDate:(EDataTimePeriod)_timerType
{
    [modelArray removeAllObjects];
    if (EDataTimePeriodStatusYear == _timerType) {
        [self showProgressWithText:@"请稍后"];
    }
    switch (_type) {
        case EChartDataHeartRateType:
        {
            modelArray = [[KMDataManager sharedDatabaseInstance] getHeartRateDataModels:_timerType forDate: nil];
        }
            break;
        case EChartDataBloodPressureType:
        {
            modelArray = [[KMDataManager sharedDatabaseInstance] getBloodPressureDataModels:_timerType forDate: nil];
        }
            break;
        case EChartDataHealthStepType:
        {
#if TARGET_OS_IPHONE//真机
            if (IS_IOS8) {
                NSInteger type = _timerType;
                [[HealthKitManage shareInstance] getStepCountFromPeriod:type completion:^(NSMutableArray *valueArr,NSMutableArray *dateArr, NSError *error) {
                    valueArray = [valueArr mutableCopy];
                    numberArray = valueArray;
                    dateArray = [dateArr mutableCopy];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self reloadDataDrawChart];
                    });
                }];
            }
#endif
        }
            break;
        case EChartDataBloodOxygenType:
        {
            modelArray =  [[KMDataManager sharedDatabaseInstance] getBloodOxygenDataModels:_timerType forDate: nil];
        }
            break;
        case EChartDataVitalCapacityType:
        {
            modelArray = [[KMDataManager sharedDatabaseInstance] getVitalCapacityDataModels:_timerType forDate: nil];
            
        }
            break;
        case EChartDataVisionDataType:
        {
            modelArray =[[KMDataManager sharedDatabaseInstance] getVisionDataModels:_timerType forDate: nil];
        }
            break;
        case EChartDataBloodSugarDataType:
        {
            modelArray =[[KMDataManager sharedDatabaseInstance] getBloodSugarDataModels:_timerType forDate: nil];
        }
            break;
        default:
            break;
    }
    if (_type!=EChartDataHealthStepType) {
        [self orderedArray:modelArray type:_type];
        [self getModelValueFromModelArray:modelArray modelType:_type];
    }
}

#pragma mark -排序
- (void)orderedArray:(NSMutableArray *)orderedArray type:(NSInteger)type
{
    id peopleClass;
    switch (type) {
        case 0:
        {
            peopleClass = objc_getClass("HeartRateDataModel");
        }
            break;
        case 1:
        {
            peopleClass = objc_getClass("BloodPressureDataModel");
        }
            break;
        case 3:
        {
            peopleClass = objc_getClass("BloodOxygenDataModel");
        }
            break;
        case 4:
        {
            peopleClass = objc_getClass("VitalCapacityDataModel");
        }
            break;
        case 5:
        {
            peopleClass = objc_getClass("VisionDataModel");
        }
            break;
        case 6:
        {
            peopleClass = objc_getClass("BloodSugarDataModel");
        }
            break;
            
        default:
            break;
    }
    const char *name = @"timeInterval".UTF8String;
    //获得这个类的名称
    objc_property_t properties = class_getProperty(peopleClass, name);
    //获得这个类的timeInterval属性
    NSString *propertyName = @(property_getName(properties));
    NSArray *array = [orderedArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                      {
                          NSTimeInterval objInterval1;
                          NSTimeInterval objInterval2;
                          NSString *valueStr1 = [obj1 valueForKey:propertyName];
                          NSString *valueStr2 = [obj2 valueForKey:propertyName];
                          objInterval1 = [valueStr1 doubleValue];
                          objInterval2 = [valueStr2 doubleValue];
                          if (objInterval2 > objInterval1)
                          {
                              return NSOrderedAscending;
                          }
                          return NSOrderedDescending;
                      }];
    [orderedArray removeAllObjects];
    [array enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         [orderedArray addObject:obj];
     }];
}

#pragma mark - 解析数组
-(void)getModelValueFromModelArray:(NSMutableArray *)array modelType:(EChartDataType) dataType
{
    [valueArray removeAllObjects];
    [dateArray removeAllObjects];
    [numberArray removeAllObjects];
    @autoreleasepool {
        switch (dataType) {
            case EChartDataHeartRateType:
                for (HeartRateDataModel * elem in array) {
                    [valueArray addObject:[NSString stringWithFormat:@"%@",elem.value_id]];
                    [numberArray addObject:elem.value_id];
                    [self splitArrayDate:dateArray fromYear:elem.year fromMonth:elem.month fromDay:elem.day];
                }
                break;
            case EChartDataBloodPressureType:
            {
                NSMutableArray *systoliArray = [NSMutableArray new];
                NSMutableArray *diastolicArray = [NSMutableArray new];
                
                NSMutableArray *systoliNumberArray = [NSMutableArray new];
                NSMutableArray *diastolicNumberArray = [NSMutableArray new];
                
                for (BloodPressureDataModel * elem in array) {
                    [systoliArray addObject:[NSString stringWithFormat:@"%@",elem.systolic_pressure_id]];
                    [diastolicArray addObject:[NSString stringWithFormat:@"%@",elem.diastolic_blood_id]];
                    [systoliNumberArray addObject:elem.systolic_pressure_id];
                    [diastolicNumberArray addObject:elem.diastolic_blood_id];
                    [self splitArrayDate:dateArray fromYear:elem.year fromMonth:elem.month fromDay:elem.day];
                }
                if ([systoliArray count] >0) {
                    [valueArray addObject:systoliArray];
                    [valueArray addObject:diastolicArray];
                    [numberArray addObject:systoliNumberArray];
                    [numberArray addObject:diastolicNumberArray];
                }
            }
                break;
            case EChartDataHealthStepType:
            {
            }
                break;
            case EChartDataBloodOxygenType:
                for (BloodOxygenDataModel * elem in array) {
                    [valueArray addObject:[NSString stringWithFormat:@"%@",elem.value_id]];
                    [numberArray addObject:elem.value_id];
                    [self splitArrayDate:dateArray fromYear:elem.year fromMonth:elem.month fromDay:elem.day];
                }
                break;
            case EChartDataVitalCapacityType:
                for (VitalCapacityDataModel * elem in array) {
                    [valueArray addObject:[NSString stringWithFormat:@"%@",elem.value_id]];
                    [numberArray addObject:elem.value_id];
                    [self splitArrayDate:dateArray fromYear:elem.year fromMonth:elem.month fromDay:elem.day];
                }
                break;
            case EChartDataVisionDataType:
                for (VisionDataModel * elem in array) {
                    [valueArray addObject: [NSString stringWithFormat:@"%@",elem.value_id]];
                    [numberArray addObject:elem.value_id];
                    [self splitArrayDate:dateArray fromYear:elem.year fromMonth:elem.month fromDay:elem.day];
                }
                break;
            case EChartDataBloodSugarDataType:
                for (VisionDataModel * elem in array) {
                    [valueArray addObject: [NSString stringWithFormat:@"%@",elem.value_id]];
                    [numberArray addObject:elem.value_id];
                    [self splitArrayDate:dateArray fromYear:elem.year fromMonth:elem.month fromDay:elem.day];
                }
                break;
                
            default:
                break;
        }
        
    }
    [self reloadDataDrawChart];
}

- (void)reloadDataDrawChart
{
    mySegmentView.enabled = YES;
    [self calculateHearthDataValue];
    [lineChartView strokePath];
    [myTableView reloadData];
    [self dismissProgress];
}

- (void)calculateHearthDataValue
{
    //最新
    newLabel.text = @"";
    maxLabel.text = @"";
    minLabel.text = @"";
    averageLabel.text = @"";
    if ([numberArray count] == 0)
    {
        return;
    }
    NSNumber *newNumber ;
    NSNumber * maxNumber;
    NSNumber * minNumber;
    NSNumber * averageNumber;
    switch (_type) {
        case 0:
        case 2:
        case 3:
        case 4:
        {
            newNumber = [numberArray lastObject];
            maxNumber = [numberArray valueForKeyPath:@"@max.integerValue"];
            minNumber = [numberArray valueForKeyPath:@"@min.integerValue"];
            NSInteger average = 0;
            for (int i = 0; i < [numberArray count]; i++)
            {
                NSNumber *iNumber = numberArray[i];
                NSInteger integer = [iNumber integerValue];
                average += integer;
            }
            average = average/[numberArray count];
            averageNumber = [NSNumber numberWithInteger:average];
            averageLabel.text = [NSString stringWithFormat:@"%@",averageNumber];
            
            newLabel.text = [NSString stringWithFormat:@"%@",newNumber];
            maxLabel.text = [NSString stringWithFormat:@"%@",maxNumber];
            minLabel.text = [NSString stringWithFormat:@"%@",minNumber];
        }
            break;
        case 1:
        {
            NSNumber *newSPNumber = [numberArray[0] lastObject];
            NSNumber *newDPNumber = [numberArray[1] lastObject];
            newLabel.text = [NSString stringWithFormat:@"%@/%@",newSPNumber,newDPNumber];
            
            NSNumber *maxSPNumber = [numberArray[0] valueForKeyPath:@"@max.integerValue"];
            NSNumber *maxDPNumber = [numberArray[1] valueForKeyPath:@"@max.integerValue"];
            maxLabel.text = [NSString stringWithFormat:@"%@/%@",maxSPNumber,maxDPNumber];
            
            NSNumber *minSPNumber = [numberArray[0] valueForKeyPath:@"@min.integerValue"];
            NSNumber *minDPNumber = [numberArray[1] valueForKeyPath:@"@min.integerValue"];
            minLabel.text = [NSString stringWithFormat:@"%@/%@",minSPNumber,minDPNumber];
            NSInteger averageSP = 0;
            for (int i = 0; i < [numberArray[0] count]; i++)
            {
                NSNumber *iNumber = numberArray[0][i];
                NSInteger integer = [iNumber integerValue];
                averageSP += integer;
            }
            NSInteger averageDP = 0;
            for (int i = 0; i < [numberArray[1] count]; i++)
            {
                NSNumber *iNumber = numberArray[1][i];
                NSInteger integer = [iNumber integerValue];
                averageDP += integer;
            }
            averageSP = averageSP/[numberArray[0] count];
            averageDP = averageDP/[numberArray[1] count];
            NSNumber *averageSPNumber = [NSNumber numberWithInteger:averageSP];
            NSNumber *averagedpNumber = [NSNumber numberWithInteger:averageDP];
            averageLabel.text = [NSString stringWithFormat:@"%@/%@",averageSPNumber,averagedpNumber];
        }
            break;
        case 5:
        case 6:
        {
            newNumber = [numberArray lastObject];
            CGFloat new = [newNumber floatValue];
            NSString * str =[NSString stringWithFormat:@"%.1f",new];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            newNumber = [numberFormatter numberFromString:str];
            
            maxNumber = [numberArray valueForKeyPath:@"@max.floatValue"];
            minNumber = [numberArray valueForKeyPath:@"@min.floatValue"];
            CGFloat average = 0;
            for (int i = 0; i < [numberArray count]; i++)
            {
                NSNumber *iNumber = numberArray[i];
                CGFloat floatValue = [iNumber floatValue];
                average += floatValue;
            }
            average = average/[numberArray count];
            averageLabel.text = [NSString stringWithFormat:@"%.1f", average];
            if (_type == 5) {
                newLabel.text = [NSString stringWithFormat:@"%@",newNumber];
                maxLabel.text = [NSString stringWithFormat:@"%@",maxNumber];
                minLabel.text = [NSString stringWithFormat:@"%@",minNumber];
            }
            else
            {
                double newFloat = [newNumber doubleValue];
                newLabel.text = [NSString stringWithFormat:@"%.1f",newFloat];
                double maxFloat = [maxNumber doubleValue];
                maxLabel.text = [NSString stringWithFormat:@"%.1f",maxFloat];
                double minFloat = [minNumber doubleValue];
                minLabel.text = [NSString stringWithFormat:@"%.1f",minFloat];
            }
            
        }
            break;
            
        default:
            break;
    }
}

-(void)splitArrayDate:(NSMutableArray *)array fromYear:(NSString *)year fromMonth:(NSString *) month fromDay:(NSString *)day
{
    if (timerType<2) {
        NSString *elem = [NSString stringWithFormat:@"%@.%@",month,day];
        [array addObject:elem];
    }
    else
    {
        NSString *elem = @"";
        if ([array count] == 0)
        {
            elem = [NSString stringWithFormat:@"%@.%@.%@",year,month,day];
            [array addObject:elem];
        }
        else
        {
            NSString *lastStr = [array lastObject];
            NSArray *lastArray = [lastStr componentsSeparatedByString:@"."];
            if ([lastArray count]>=2&&[month integerValue]!=12)
            {
                elem = [NSString stringWithFormat:@"%@.%@",month,day];
                [array addObject:elem];
            }
            else
            {
                elem = [NSString stringWithFormat:@"%@.%@.%@",year,month,day];
                [array addObject:elem];
            }
        }
    }
}

#pragma mark - UISegmentedControl
-(void)mySegmentAction:(UISegmentedControl *)segmented{
    NSInteger Index = segmented.selectedSegmentIndex;
    timerType = Index;
    segmented.enabled = NO;
    [self getChartDate:timerType];
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return valueArray;
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return dateArray;
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    if (_type == 1) {
        return @[AppChartLineColor,
                 AppChartMaskLineColor,
                 ];
    }
    return @[AppFontYellowColor];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 500;
}

- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart{
    return 0;
}

- (NSUInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 10;
}

#pragma mark - ZFLineChartDelegate

- (CGFloat)groupWidthInLineChart:(ZFLineChart *)lineChart{
    return 30;
    
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
    //    NSLog(@"第%ld个", (long)circleIndex);
}

- (void)lineChart:(ZFLineChart *)lineChart didSelectPopoverLabelAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex{
    //    NSLog(@"第%ld个" ,(long)circleIndex);
}

#pragma mark - UITableView

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [modelArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
        //        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        //        cell.separatorInset =
        UILabel *dateLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 5, MainScreenWidth/4, 40)];
        dateLabel.font = [UIFont fontWithName:@"Avenir-Light" size:13];
        dateLabel.textColor = AppFontColor;
        dateLabel.numberOfLines = 2;
        dateLabel.textAlignment = NSTextAlignmentLeft;
        dateLabel.tag = 1;
        [cell.contentView addSubview:dateLabel];
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame: CGRectMake((MainScreenWidth-100)/2, 5, 100, 40)];
        valueLabel.font = [UIFont fontWithName:@"Avenir-Light" size:14];
        valueLabel.textColor = AppFontGrayColor;
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.tag = 2;
        [cell.contentView addSubview:valueLabel];
    }
    UILabel *dateLabel = [cell.contentView viewWithTag:1];
    UILabel *valueLabel = [cell.contentView viewWithTag:2];
    switch (_type) {
        case 0:
        {
            HeartRateDataModel *model = modelArray[indexPath.row];
            dateLabel.text = [self dateStringFromNumber:model.timeInterval];
            valueLabel.text = [NSString stringWithFormat:@"%@", model.value_id];
        }
            break;
        case 1:
        {
            BloodPressureDataModel *model = modelArray[indexPath.row];
            dateLabel.text = [self dateStringFromNumber:model.timeInterval];
            valueLabel.text = [NSString stringWithFormat:@"%@/%@", model.systolic_pressure_id, model.diastolic_blood_id];
        }
            break;
        case 3:
        {
            BloodOxygenDataModel  *model = modelArray[indexPath.row];
            dateLabel.text = [self dateStringFromNumber:model.timeInterval];
            valueLabel.text = [NSString stringWithFormat:@"%@%%", model.value_id];
        }
            break;
        case 4:
        {
            VitalCapacityDataModel *model = modelArray[indexPath.row];
            dateLabel.text = [self dateStringFromNumber:model.timeInterval];
            valueLabel.text = [NSString stringWithFormat:@"%@", model.value_id];
        }
            break;
        case 5:
        {
            VisionDataModel *model = modelArray[indexPath.row];
            dateLabel.text = [self dateStringFromNumber:model.timeInterval];
            float value = [model.value_id floatValue];
            valueLabel.text = [NSString stringWithFormat:@"%.1f", value];
        }
            break;
        case 6:
        {
            BloodSugarDataModel *model = modelArray[indexPath.row];
            dateLabel.text = [self dateNotTimeStringFromNumber:model.timeInterval];
            float value = [model.value_id floatValue];
            valueLabel.text = [NSString stringWithFormat:@"%.1f", value];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
-(NSString *)dateStringFromNumber:(NSNumber *)number
{
    NSTimeInterval time=[number doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

-(NSString *)dateNotTimeStringFromNumber:(NSNumber *)number
{
    NSTimeInterval time=[number doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
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
