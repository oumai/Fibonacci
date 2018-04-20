//
//  DoseTimeViewController.m
//  Fibonacci
//
//  Created by shipeiyuan on 2016/12/21.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "DoseTimeViewController.h"

@interface DoseTimeViewController ()

@end

#define CELLHEIGHT 45.0
@implementation DoseTimeViewController
@synthesize dose = _dose;

- (void)dealloc
{
    _delegate = nil;
    _textField.delegate = nil;
    myTableView.delegate = nil;
    myTableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"剂量时间";
    [self initTableViewData];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initButtonView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initTimeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableViewData
{
    CGFloat minY = 0;
    if (self.navigationController.navigationBar.translucent&&!self.extendedLayoutIncludesOpaqueBars) {
        minY = kStatusAndNavHeight;
    }
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, minY, MainScreenWidth, MainScreenHeight-minY)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.scrollEnabled = NO;
    myTableView.rowHeight = CELLHEIGHT;
    myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundView = [[UIView alloc] init];
    myTableView.backgroundView.backgroundColor = [UIColor clearColor];
    myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTableView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(MainScreenWidth-100, 0, 60, CELLHEIGHT)];
    _textField.font = [UIFont fontWithName:AppFontHelvetica size: 15];
    _textField.tag = 102;
    _textField.textAlignment = NSTextAlignmentRight;
    _textField.delegate = self;
    _textField.keyboardType = UIKeyboardTypeDecimalPad;
    _textField.text = _dose.dose;
    _textField.textColor = AppFontGrayColor;
}

- (void)initButtonView
{

    CGFloat buttonH = 40;
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(MainScreenWidth/3, MainScreenHeight-100, MainScreenWidth/3, buttonH);
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [saveButton setTitle: @"保存" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButton:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"btn"];
    [saveButton setBackgroundImage: image forState:UIControlStateNormal];
    [self.view addSubview:saveButton];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteButton.frame = CGRectMake(MainScreenWidth/3, MainScreenHeight- 50, MainScreenWidth/3, buttonH);
    [deleteButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [deleteButton setTitle: @"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:AppFontGrayColor forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];
}

- (void)initTimeView
{
    birthDayPickerView = [[BATBirthDayPickerView alloc] initWithFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, 256) type:EBirthDayTypeDateTime];
    birthDayPickerView.delegate = self;
    [self.view addSubview: birthDayPickerView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, CELLHEIGHT)];
        titlelabel.font = [UIFont fontWithName:@"Helvetica-Light" size: 14];
        titlelabel.tag = 100;
        titlelabel.textColor = AppFontColor;
        [cell.contentView addSubview:titlelabel];
        
        UILabel *rigthLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth-180, 2, 150, CELLHEIGHT-4)];
        rigthLabel.font = [UIFont fontWithName:@"Helvetica-Light" size: 14];
        rigthLabel.tag = 101;
        rigthLabel.textAlignment = NSTextAlignmentRight;
        rigthLabel.textColor = AppFontGrayColor;
//        rigthLabel.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:rigthLabel];
    }
    UILabel *label = [cell.contentView viewWithTag: 100];
    UILabel *rigthLabel = [cell.contentView viewWithTag: 101];
    switch (indexPath.row) {
        case 0:
        {
            if (![cell.contentView.subviews containsObject:_textField]) {
                [cell.contentView addSubview:_textField];
            }
            label.text = @"用药剂量";
            rigthLabel.text = @"U";
        }
            break;
        case 1:
        {
            label.text = @"用药时间";
            rigthLabel.text = _dose.time;
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            [birthDayPickerView hide];
        }
            break;
        case 1:
        {
            [birthDayPickerView show];
        }
            
        default:
            break;
    }
}

#pragma mark - TextViewEditChanged
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGFloat value = [textField.text floatValue];
    if (value > 100)
    {
        [self showText:@"亲,这是吃药哦"];
        textField.text = @"1";
    }
    else if (value == 0)
    {
        textField.text = @"1";
    }
    _dose.dose = textField.text;
}

#pragma mark - BATBirthDayPickerViewDelegate
- (void)BATBirthDayPickerView:(BATBirthDayPickerView *)birthDayPickerView didSelectDateString:(NSString *)dateString
{
    _dose.time = dateString;
    NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:1 inSection:0];
    [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Action
- (void)saveButton:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(DoseTimeViewController:changeModel:)]) {
        [self.delegate DoseTimeViewController:self changeModel:_dose];
    }
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 *NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)deleteButton:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(DoseTimeViewController:deleteModel:)]) {
        [self.delegate DoseTimeViewController:self deleteModel:_dose ];
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
