
//
//  InsulinRecordViewController.m
//  Fibonacci
//
//  Created by shipeiyuan on 2016/12/17.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "InsulinRecordViewController.h"
#import "RecordTableViewCell.h"
#import "BloodSugarDataModel.h"
#import "InsulinDataModel.h"
#import "AddBloodSugarViewController.h"
#import "AddInsulinViewController.h"
#import <objc/message.h>

@interface InsulinRecordViewController ()

@end

#define HeaderInSectionHeight 44.0

@implementation InsulinRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史记录";
    dateArray = [NSMutableArray new];
    userDataDic = [NSMutableDictionary new];
    [self pagesLayout];
    [self getUserData:0];
    // Do any additional setup after loading the view.
}

- (void)pagesLayout
{
    WEAK_SELF(self);
    segmentView = [[UIView alloc] init];
    [self.view addSubview:segmentView];
    CGFloat minY = 0;
    if (self.navigationController.navigationBar.translucent&&!self.extendedLayoutIncludesOpaqueBars) {
        minY = kStatusAndNavHeight;
    }
    [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(minY);
        make.height.mas_equalTo(45);
    }];
    
    CGFloat buttonW = MainScreenWidth/3;
    NSArray *segmentTitleArray = @[@"所有",@"血糖",@"胰岛素"];
    for (int i = 0; i < [segmentTitleArray count]; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonW*i, 0, buttonW, 43);
        [button setTitle:segmentTitleArray[i] forState:UIControlStateNormal];
        if (i==  0)
        {
            button.selected = YES;
            [button setTitleColor:AppFontYellowColor forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:AppFontColor forState:UIControlStateNormal];
        }
        button.titleLabel.font = [UIFont fontWithName:AppFontHelvetica size:14.0];
        button.tag = i;
        [button addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
        [segmentView addSubview:button];
    }
    segmentLine = [CALayer layer];
    segmentLine.frame = CGRectMake(0, 42, buttonW, 3);
    segmentLine.backgroundColor = [AppFontYellowColor CGColor];
    [segmentView.layer addSublayer:segmentLine];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth,150 ) style:UITableViewStylePlain];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.rowHeight = 50;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundView = [[UIView alloc] init];
    myTableView.backgroundView.backgroundColor = [UIColor clearColor];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorColor = RGB(41, 41, 88);
    [self.view addSubview:myTableView];
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(segmentView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}

- (void)getUserData:(NSInteger)type
{
    [userDataDic removeAllObjects];
    [dateArray removeAllObjects];
    @autoreleasepool {
        //获取所有数据
        NSMutableArray *userDataArray = [NSMutableArray new];
        switch (type) {
            case 0:
            {
                NSArray *array = [[KMDataManager sharedDatabaseInstance] getBloodSugarDataModels:EDataTimePeriodStatusAll forDate:nil];
                [array enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [userDataArray addObject:obj];
                }];
                NSArray *insulinArray = [[KMDataManager sharedDatabaseInstance] getInsulinDataModels];
                [insulinArray enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [userDataArray addObject:obj];
                }];
            }
                break;
            case 1:
            {
                NSArray *array = [[KMDataManager sharedDatabaseInstance] getBloodSugarDataModels:EDataTimePeriodStatusAll forDate:nil];
                [array enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [userDataArray addObject:obj];
                }];
            }
                break;
            case 2:
            {
                NSArray *insulinArray = [[KMDataManager sharedDatabaseInstance] getInsulinDataModels];
                [insulinArray enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [userDataArray addObject:obj];
                }];
            }
                break;
            default:
                break;
        }
        __block NSString *dateStr = @"";
        __block NSTimeInterval currentInterval;
        
        [userDataArray enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray * elemArray = [NSMutableArray new];
            if ([obj isKindOfClass:[BloodSugarDataModel class]])
            {
                BloodSugarDataModel * model = (BloodSugarDataModel *)obj;
                dateStr = [NSString stringWithFormat:@"%@-%@-%@",model.year, model.month, model.day];
                currentInterval = [model.timeInterval doubleValue];
            }
            else
            {
                InsulinDataModel * model = (InsulinDataModel *)obj;
                dateStr = [NSString stringWithFormat:@"%@-%@-%@",model.year, model.month, model.day];
                currentInterval = [model.timeInterval doubleValue];
            }
            if ([userDataDic.allKeys containsObject:dateStr])
            {
                elemArray = [userDataDic objectForKey: dateStr];
            }

            [elemArray addObject:obj];

            if (![dateArray containsObject:dateStr]) {
                [dateArray addObject:dateStr];
            }
            
            [userDataDic setObject:elemArray forKey: dateStr];
        }];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSArray *dateElem = [dateArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDate *date1 = [dateFormatter dateFromString:(NSString *)obj1];
            NSTimeInterval interval1= [date1 timeIntervalSince1970];
            NSDate *date2 = [dateFormatter dateFromString:(NSString *)obj2];
            NSTimeInterval interval2= [date2 timeIntervalSince1970];
            if (interval2 > interval1) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];
        [dateArray removeAllObjects];
        [dateElem enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [dateArray addObject:obj];
        }];
        
        [dateArray enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            NSArray *array = userDataDic[dateArray[idx]];
            NSArray *newArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSTimeInterval objInterval1;
                NSTimeInterval objInterval2;
                if ([obj1 isKindOfClass:[BloodSugarDataModel class]])
                {
                    BloodSugarDataModel * model = (BloodSugarDataModel *)obj1;
                    objInterval1 = [model.timeInterval doubleValue];
                }
                else
                {
                    InsulinDataModel * model = (InsulinDataModel *)obj1;
                    objInterval1 = [model.timeInterval doubleValue];
                }
                if ([obj isKindOfClass:[BloodSugarDataModel class]])
                {
                    BloodSugarDataModel * model = (BloodSugarDataModel *)obj2;
                    objInterval2 = [model.timeInterval doubleValue];
                }
                else
                {
                    InsulinDataModel * model = (InsulinDataModel *)obj2;
                    objInterval2 = [model.timeInterval doubleValue];
                }
                if (objInterval2 > objInterval1)
                {
                    return NSOrderedDescending;
                }
                return NSOrderedAscending;
            }];
            [userDataDic setObject:newArray forKey:dateArray[idx]];
        }];
    }
    [myTableView reloadData];
}

- (void)segmentAction:(UIButton *)button
{
    for (UIView *elem in segmentView.subviews)
    {
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
    [UIView setAnimationDuration:0.5];
    segmentLine.frame = CGRectMake(button.frame.origin.x , 42, MainScreenWidth/3, 3);
    [UIView commitAnimations];
    [self getUserData:button.tag];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dateArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [dateArray objectAtIndex:section];
    NSArray *array = [userDataDic objectForKey:key];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"RecordTableViewCell";
    RecordTableViewCell *cell = (RecordTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecordTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    NSString *key = [dateArray objectAtIndex:indexPath.section];
    NSArray *array = [userDataDic objectForKey:key];
    [cell setCellData:array[indexPath.row]];
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, HeaderInSectionHeight)];    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, MainScreenWidth-20, HeaderInSectionHeight)];
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.font = [UIFont fontWithName:AppFontHelvetica size:15];
    labelTitle.textColor = AppFontGrayColor;
    labelTitle.text = dateArray[section];
    [view addSubview:labelTitle];
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HeaderInSectionHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *key = [dateArray objectAtIndex:indexPath.section];
    NSArray *array = [userDataDic objectForKey:key];
    id model = array[indexPath.row];
    
    id peopleClass;
    BOOL isBloodSugar = NO;
    if ([model isKindOfClass:[BloodSugarDataModel class]])
    {
        isBloodSugar = YES;
        peopleClass = objc_getClass("BloodSugarDataModel");

    }
    else if ([model isKindOfClass:[InsulinDataModel class]])
    {
        isBloodSugar = NO;
        peopleClass = objc_getClass("InsulinDataModel");
    }
    const char *name = @"note".UTF8String;
    objc_property_t properties = class_getProperty(peopleClass, name);
    NSString *propertyName = @(property_getName(properties));
    NSString *noteStr = [model valueForKey:propertyName];
    NSLog(@"备注 =%@",noteStr);
    if (noteStr.length >0) {
        id viewController ;
        UIStoryboard *sboard = [KMTools getStoryboardInstance];
        if (isBloodSugar)
        {
            viewController = [sboard instantiateViewControllerWithIdentifier:@"AddBloodSugarViewController"];
        }
        else
        {
            viewController = [sboard instantiateViewControllerWithIdentifier:@"AddInsulinViewController"];
        }
        [viewController setValue:model forKey:@"previewModel"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
