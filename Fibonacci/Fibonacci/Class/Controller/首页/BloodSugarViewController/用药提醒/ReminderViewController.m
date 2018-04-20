//
//  ReminderViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/12/20.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "ReminderViewController.h"
#import "DoseTimeViewController.h"
@interface ReminderViewController ()

@end

#define CELLHEIGHT 45.0

@implementation ReminderViewController

@synthesize model = _model;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    noteView.delegate = nil;
    myTableView.delegate = nil;
    doseAndTimeTableView.dataSource = nil;
    birthDayPickerView.delegate = nil;
    insulinPickerView.delegate = nil;
    _delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用药提醒";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextViewEditChanged:)
                                                 name:@"UITextViewTextDidChangeNotification"
                                               object:noteView];
    [self addRightButton:@selector(saveReminderData) titile:@"保存" titleColor: AppFontColor];
    
    [self initTableViewData];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self pagesLayout];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self viewDidAppearLoadData];
}

- (void)initTableViewData
{
    CGFloat minY = 0;
    if (self.navigationController.navigationBar.translucent&&!self.extendedLayoutIncludesOpaqueBars) {
        minY = kStatusAndNavHeight;
    }
    reminderSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(MainScreenWidth - 50-20, (CELLHEIGHT-28)/2, 50, 28)];
    doseAndTimeArray = @[@"08:00", @"12:30", @"18:00", @"19:00", @"20:00", @"21:00"];
    titleArray = @[@"药品信息",@"药品类型", @"药品名称", @"备注信息", @"", @"服药时间",@"", @"开始时间",@"",@"提醒我"];
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, minY, MainScreenWidth, MainScreenHeight- minY)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundView = [[UIView alloc] init];
    myTableView.backgroundView.backgroundColor = [UIColor clearColor];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorColor = RGB(41, 41, 88);
    if (_model) {
        reminderSwitch.on = _model.isReminder;
        [self initTableViewFootView];
    }
    else
    {
        _model = [[ReminderModel alloc] init];
        reminderSwitch.on = YES;
    }
    [self.view addSubview:myTableView];
    
}

- (void)initTableViewFootView
{
    UIView *footer =[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, CELLHEIGHT*2)];
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(MainScreenWidth/3, CELLHEIGHT*0.5, MainScreenWidth/3, CELLHEIGHT);
    [deleteButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [deleteButton setTitle: @"删除" forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"btn"];
    [deleteButton setBackgroundImage: image forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteReminderButton:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:deleteButton];
    myTableView.tableFooterView = footer;
}

- (void)pagesLayout
{
    if (noteView != nil) {
        return;
    }
    noteView = [[UITextView alloc] initWithFrame:CGRectMake(20, 0, MainScreenWidth-40, 100)];
    noteView.backgroundColor = [UIColor clearColor];
    noteView.font = [UIFont fontWithName:AppFontHelvetica size: 14];
    noteView.textColor = AppFontGrayColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, MainScreenWidth-45, 30)];
    label.textColor = AppFontGrayColor;
    label.font = [UIFont fontWithName:AppFontHelvetica size: 15];
    label.tag = 1000;
    label.text = @"您可以填写相关胰岛素的信息";
    if (_model.note.length > 0)
    {
        noteView.text = _model.note;
        label.hidden = YES;
    }
    [noteView addSubview:label];
    
    CGFloat buttonH = 25.f;
    CGFloat buttonW = (MainScreenWidth - 15*3-20*2)/4;
    weekView = [[UIView alloc] init];
    __block CGFloat maxY = 0.f;
    __block CGFloat buttonX = 0.f;
    __block CGFloat buttonY = 0.f;
    NSArray *array = @[@"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", @"星期日"];
    [array enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonX = 20 + (idx%4)*(buttonW + 15);
        buttonY = 20 + (idx/4)*(buttonH + 20);
        button.frame = CGRectMake( buttonX, buttonY, buttonW, buttonH);
        button.layer.cornerRadius = buttonH/2;
//        button.layer.borderColor = RGB(229, 230, 231).CGColor;
//        button.layer.borderWidth = 0.5;
        button.tag = idx;
        if([_model.weekArray count] > idx)
        {
            NSNumber *number = _model.weekArray[idx];
            BOOL isSelected = [number boolValue];
            if (isSelected) {
                button.backgroundColor = RGB(68, 118, 198);
                button.selected = isSelected;
            }
            else
            {
                button.backgroundColor = RGB(246, 247, 248);
            }
        }
        else
        {
            button.selected = YES;
            button.backgroundColor = RGB(68, 118, 198);
        }
        button.titleLabel.font = [UIFont fontWithName:AppFontHelvetica size:10];
        [button setTitleColor:RGB(147, 148, 149) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitle:array[idx] forState:UIControlStateNormal];
        [button setTitle:array[idx] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(weekAction:) forControlEvents:UIControlEventTouchUpInside];
        [weekView addSubview:button];
        maxY = CGRectGetMaxY(button.frame)+10;
    }];
    doseAndTimeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, maxY, MainScreenWidth, [_model.doseTimeArray count]*CELLHEIGHT)];
    doseAndTimeTableView.delegate = self;
    doseAndTimeTableView.dataSource = self;
    doseAndTimeTableView.scrollEnabled = NO;
    doseAndTimeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    doseAndTimeTableView.backgroundView = [[UIView alloc] init];
    doseAndTimeTableView.backgroundView.backgroundColor = [UIColor clearColor];
    doseAndTimeTableView.backgroundColor = [UIColor clearColor];
    
    [weekView addSubview:doseAndTimeTableView];
    maxY = CGRectGetMaxY(doseAndTimeTableView.frame);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, maxY+30, MainScreenWidth, CELLHEIGHT);
    [button setTitle: @"添加更多用药次数" forState:UIControlStateNormal];
    [button setTitleColor: AppFontGrayColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:AppFontHelvetica size:12];
    [button setImage:[UIImage imageNamed:@"addbutton"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [button addTarget:self action:@selector(addOtherCount) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 10010;
    maxY = CGRectGetMaxY(button.frame);
    weekViewHeight = maxY;
    [weekView addSubview:button];
    weekView.frame = CGRectMake(0, 0, MainScreenWidth, maxY);
}

- (void)viewDidAppearLoadData
{
    if (birthDayPickerView!= nil) {
        return;
    }
    CGFloat minY = kStatusAndNavHeight;
    if (self.navigationController.navigationBar.translucent&&!self.extendedLayoutIncludesOpaqueBars) {
        minY = 0;
    }
    birthDayPickerView = [[BATBirthDayPickerView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - minY, MainScreenWidth, 256) type:EBirthDayTypeDateWeek];
    birthDayPickerView.delegate = self;
    [self.view addSubview: birthDayPickerView];
    
    insulinPickerView = [[BATInsulinPickerView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - minY, MainScreenWidth, 256)];
    insulinPickerView.delegate = self;
    [self.view addSubview: insulinPickerView];
    [myTableView reloadData];
    if ([_model.doseTimeArray count] >0)
    {
        [doseAndTimeTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextViewEditChanged
-(void)TextViewEditChanged:(NSNotification *)obj
{
    UILabel *label = [noteView viewWithTag:1000];
    if (noteView.text.length >0) {
        label.hidden = YES;
    }
    else
    {
        label.hidden = NO;
    }
    NSUInteger kLength = 50;
    UITextView *textView = (UITextView *)obj.object;
    NSString *toBeString = textView.text;
    NSArray *currentar = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currentar firstObject];
    NSString *lang = current.primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"])
    { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > kLength)
            {
                textView.text = [toBeString substringToIndex:kLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kLength) {
            textView.text = [toBeString substringToIndex:kLength];
        }
    }
    //    NSString *str = [NSString stringWithFormat:@"%ld/200",(unsigned long)textView.text.length];
    //    [self setLabelAttributedText:str];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:myTableView])
    {
        return [titleArray count];
    }
    else
    {
        return [_model.doseTimeArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:myTableView])
    {
        if (indexPath.row == 4)
        {
            return CGRectGetHeight(noteView.frame);
        }
        else if(indexPath.row == 6)
        {
            return CGRectGetHeight(weekView.frame);
        }
        return CELLHEIGHT;
    }
    else
    {
        return CELLHEIGHT;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%li%li", [indexPath section], [indexPath row]];//以indexPath来唯一确定cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor clearColor];
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, CELLHEIGHT)];
        titlelabel.font = [UIFont fontWithName:@"Helvetica-Light" size: 14];
        titlelabel.tag = 100;
        titlelabel.textColor = AppFontGrayColor;
        [cell.contentView addSubview:titlelabel];
        
        UILabel *rigthLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth-230, 2, 200, CELLHEIGHT-4)];
        rigthLabel.font = [UIFont fontWithName:@"Helvetica-Light" size: 14];
        rigthLabel.tag = 101;
        rigthLabel.textAlignment = NSTextAlignmentRight;
        rigthLabel.textColor = AppFontGrayColor;
        rigthLabel.hidden = YES;
        [cell.contentView addSubview:rigthLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.5)];
        lineView.tag = 99;
        lineView.hidden = YES;
        lineView.backgroundColor = RGB(41, 41, 88);
        [cell.contentView addSubview:lineView];
    }
    
    UIView *line = [cell.contentView viewWithTag: 99];
    UILabel *label = [cell.contentView viewWithTag: 100];
    UILabel *rigthLabel = [cell.contentView viewWithTag: 101];
    if ([tableView isEqual:myTableView])
    {
        label.text = titleArray[indexPath.row];
        switch (indexPath.row) {
            case 0:
            case 3:
            case 5:
            case 7:
            {
                label.textColor = AppFontColor;
                cell.backgroundColor = RGBA(21, 34, 100, 0.3);
            }
                break;
            case 1:
            {
                rigthLabel.hidden = NO;
                rigthLabel.text = @"胰岛素";
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
                break;
            case 2:
            {
                rigthLabel.hidden = NO;
                if (_model.name.length > 0) {
                    rigthLabel.text = _model.name;
                }
                line.hidden = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 4:
            {
                if (![cell.contentView.subviews containsObject:noteView])
                {
                    [cell.contentView addSubview:noteView];
                }
            }
                break;
            case 6:
            {
                [weekView removeFromSuperview];
                if (![cell.contentView.subviews containsObject:weekView])
                {
                    [cell.contentView addSubview:weekView];
                }
            }
                break;
            case 8:
            {
                line.hidden = NO;
                if (_model.date.length <1)
                {
                    _model.date = [NSString stringWithFormat:@"%@",[KMTools getLocalDateWithTimeString:NO]];
                }
                label.text = _model.date;
            }
                break;
            case 9:
            {
                if (![cell.contentView.subviews containsObject:reminderSwitch]) {
                    [cell.contentView addSubview:reminderSwitch];
                }
                line.hidden = NO;
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        rigthLabel.hidden = NO;
        line.hidden = NO;
        DoseTime *dose = _model.doseTimeArray[indexPath.row];
        label.text = dose.time;
        rigthLabel.text = [NSString stringWithFormat:@"%@ U",dose.dose];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:myTableView])
    {
        if (indexPath.row == 2)
        {
            [insulinPickerView show];
            [birthDayPickerView hide];
        }
        else if (indexPath.row == 8)
        {
            [birthDayPickerView show];
            [insulinPickerView hide];
        }
        else
        {
            [birthDayPickerView hide];
            [insulinPickerView hide];
        }
    }
    else
    {
        UIStoryboard *sboard = [KMTools getStoryboardInstance];
        DoseTimeViewController *doseTimeViewController = [sboard instantiateViewControllerWithIdentifier:@"DoseTimeViewController"];
        doseTimeViewController.delegate = self;
        doseTimeViewController.dose = _model.doseTimeArray[indexPath.row];
        [self.navigationController pushViewController:doseTimeViewController animated:YES];
    }
}

#pragma mark - BATBirthDayPickerViewDelegate
- (void)BATBirthDayPickerView:(BATBirthDayPickerView *)birthDayPickerView didSelectDateString:(NSString *)dateString
{
    _model.date = dateString;
    NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:8 inSection:0];
    [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - BATInsulinPickerViewDelegate
- (void)BATInsulinPickerView:(BATInsulinPickerView *)birthDayPickerView didSelectInsulinString:(NSString *)insulinString
{
    _model.name = insulinString;
    NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:2 inSection:0];
    [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
    NSLog(@"%@",insulinString);
}

#pragma mark - DoseTimeDelegate
- (void)DoseTimeViewController:(DoseTimeViewController *)doseTimeViewController deleteModel:(DoseTime *)model
{
    if ([_model.doseTimeArray containsObject:model]) {
        NSUInteger idx = [_model.doseTimeArray indexOfObject:model];
        [_model.doseTimeArray removeObjectAtIndex:idx];
        
        CGFloat height = CELLHEIGHT;
        CGRect frame = doseAndTimeTableView.frame;
        frame.size.height = frame.size.height - height;
        doseAndTimeTableView.frame = frame;
        
        UIView *button = [weekView viewWithTag:10010];
        CGRect frame1 = button.frame;
        frame1.origin.y = frame1.origin.y - height;
        button.frame = frame1;
        
        CGRect frame2 = weekView.frame;
        frame2.size.height = frame2.size.height -height;
        weekView.frame = frame2;

        NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:6 inSection:0];
        [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [doseAndTimeTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)DoseTimeViewController:(DoseTimeViewController *)doseTimeViewController changeModel:(DoseTime *)model
{
    if ([_model.doseTimeArray containsObject:model])
    {
        NSUInteger idx = [_model.doseTimeArray indexOfObject:model];
        [_model.doseTimeArray removeObjectAtIndex:idx];
        [_model.doseTimeArray insertObject:model atIndex:idx];
        NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:6 inSection:0];
        [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [doseAndTimeTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Action
-(void)addOtherCount
{
    if (_model.name.length < 1) {
        [self showText:@"请选择药品名称"];
        return;
    }
    NSInteger count = [_model.doseTimeArray count];
    if (count > 5) {
        [self showText:@"最多添加六个"];
        return;
    }
    CGFloat height = CELLHEIGHT;
    CGRect frame = doseAndTimeTableView.frame;
    frame.size.height = frame.size.height + height;
    doseAndTimeTableView.frame = frame;
    
    UIView *button = [weekView viewWithTag:10010];
    CGRect frame1 = button.frame;
    frame1.origin.y = frame1.origin.y + height;
    button.frame = frame1;
    
    CGRect frame2 = weekView.frame;
    frame2.size.height = frame2.size.height +height;
    weekView.frame = frame2;
    if (count > 0)
    {
        NSMutableArray *array = [NSMutableArray new];
        [_model.doseTimeArray enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             DoseTime *dose = (DoseTime *)obj;
             [array addObject:dose.time];
         }];
        
        [doseAndTimeArray enumerateObjectsUsingBlock:^(NSObject *obj2, NSUInteger idx2, BOOL * _Nonnull stop2)
         {
             NSString *time = (NSString *)obj2;
             if (![array containsObject:time]) {
                 DoseTime *dose = [[DoseTime alloc] init];
                 dose.time = time;
                 dose.dose = @"1";
                 [_model.doseTimeArray addObject:dose];
                 *stop2 = YES;
             }
         }];
    }
    else
    {
        DoseTime *dose = [[DoseTime alloc] init];
        dose.time = doseAndTimeArray[0];
        dose.dose = @"1";
        [_model.doseTimeArray addObject:dose];
    }

    NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:6 inSection:0];
    [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [doseAndTimeTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

-(void)weekAction:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        button.backgroundColor = RGB(68, 118, 198);
    }
    else
    {
        button.backgroundColor = RGB(246, 247, 248);
    }
}

- (void)saveReminderData
{
    if (_model.name.length < 1)
    {
        [self showText:@"请选择药品名称"];
        return;
    }
    /*
    if (_model.weekArray == nil)
    {
        _model.weekArray = [NSMutableArray new];
    }
    */
    [_model.weekArray removeAllObjects];
    [weekView.subviews enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)obj;
            if (button.tag != 10010) {
                NSNumber *number = [NSNumber numberWithBool:button.selected];
                [_model.weekArray addObject:number];
            }
        }
    }];
    _model.isReminder = reminderSwitch.on;
    _model.note = noteView.text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(ReminderViewController:changeModel:)]) {
        [self.delegate ReminderViewController:self changeModel:_model];
    }
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 *NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)deleteReminderButton:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ReminderViewController:deleteModel:)]) {
        [self.delegate ReminderViewController:self deleteModel:_model];
    }
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 *NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
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
