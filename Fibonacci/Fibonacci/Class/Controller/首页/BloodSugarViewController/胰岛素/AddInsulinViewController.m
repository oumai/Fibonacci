//
//  AddInsulinViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/12/16.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "AddInsulinViewController.h"

@interface AddInsulinViewController ()

@end

@implementation AddInsulinViewController
@synthesize previewModel = _previewModel;

#define CELLHEIGHT 45.0

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    doseField.delegate = nil;
    myTableView.delegate = nil;
    myTableView.dataSource = nil;
    birthDayPickerView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记胰岛素";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextViewEditChanged:)
                                                 name:@"UITextViewTextDidChangeNotification"
                                               object:noteView];
    if (_previewModel) {
        isPreview = YES;
    }
    else
    {
        [self addRightButton:@selector(saveInsulinData) titile:@"保存" titleColor:AppFontColor];
    }
    
    titleArray = @[@"药品信息", @"胰岛素名称",@"胰岛素剂量",@"备注信息",@"",@"服药时间",@"",@"常用药品(长按药品可删除)",@""];
    CGFloat minY = 0;
    if (self.navigationController.navigationBar.translucent&&!self.extendedLayoutIncludesOpaqueBars) {
        minY = kStatusAndNavHeight;
    }
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, minY, MainScreenWidth, MainScreenHeight - minY)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
//    myTableView.scrollEnabled = NO;
    myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.backgroundView = [[UIView alloc] init];
    myTableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTableView];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pagesLayout
{
    if (doseField!= nil)
    {
        return;
    }
    CGFloat fieldH = CELLHEIGHT-20;
    doseField = [[UITextField alloc] initWithFrame:CGRectMake(MainScreenWidth-80, 10, 60, fieldH)];
    doseField.font = [UIFont fontWithName:AppFontHelvetica size:12];
    doseField.textColor = AppFontGrayColor;
    doseField.backgroundColor = RGB(68, 118, 198);
    doseField.delegate = self;
    doseField.keyboardType = UIKeyboardTypeDecimalPad;
    doseField.placeholder = @"剂量";
    [doseField setValue: AppFontGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    doseField.textAlignment = NSTextAlignmentCenter;
    doseField.delegate = self;
    doseField.layer.cornerRadius = fieldH/2;

    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth-230, 0, 200, CELLHEIGHT)];
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Light" size: 14];
    nameLabel.tag = 101;
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.textColor = AppFontGrayColor;
    
    noteView = [[UITextView alloc] initWithFrame:CGRectMake(20, 0, MainScreenWidth-40, 100)];
    noteView.backgroundColor = [UIColor clearColor];
    noteView.font = [UIFont fontWithName:AppFontHelvetica size: 14];
    noteView.textColor = AppFontGrayColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth-40, 30)];
    label.textColor = AppFontGrayColor;
    label.font = [UIFont fontWithName:AppFontHelvetica size: 15];
    label.tag = 1000;
    label.text = @"您可以填写相关胰岛素的信息";
    [noteView addSubview:label];
    
    if (isPreview) {
        nameLabel.text = _previewModel.name;
        doseField.text = [NSString stringWithFormat:@"%.1f",[_previewModel.dose doubleValue]];
        doseField.enabled = NO;
        noteView.text = _previewModel.note;
        noteView.editable = NO;
        label.hidden = YES;
    }
    else
    {
        [self setButtonView];
    }
}

- (void)setButtonView
{
    [buttonView removeFromSuperview];
    buttonView = nil;
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [userDefaults objectForKey: KEY_INSULINNAME_TARRAY];
    buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, MainScreenWidth, 1)];
    __block CGFloat lastY = .0f;
    __block CGFloat lastX = .0f;
    __block CGFloat heigth = 30;
    __block BOOL huanhang = NO;
    [array enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = RGB(68, 118, 198);
        button.layer.cornerRadius = heigth/2;
//        button.layer.borderColor = RGB(229, 230, 231).CGColor;
//        button.layer.borderWidth = 0.5;
        button.titleLabel.font = [UIFont fontWithName:AppFontHelvetica size:10];
        [button setTitleColor: AppFontGrayColor forState:UIControlStateNormal];
        [button setTitle:array[idx] forState:UIControlStateNormal];
        CGFloat width = [self adjustLabelFrameWidth:button.titleLabel.font text:button.titleLabel.text];
        [button addTarget:self action:@selector(addLabelName:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
        longPress.minimumPressDuration = 0.8; //定义按的时间
        [button addGestureRecognizer:longPress];
        width = width+20;
        if (width+lastX+20 > MainScreenWidth-20) {
            huanhang = YES;
            lastY = lastY+heigth+10;
            lastX = 0.f;
        }
        button.frame = CGRectMake(lastX +20, lastY, width, heigth);
        lastX = CGRectGetMaxX(button.frame);
        buttonView.frame =CGRectMake(0, 10, MainScreenWidth, CGRectGetMaxY(button.frame));
        [buttonView addSubview:button];
    }];
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
    birthDayPickerView = [[BATBirthDayPickerView alloc] initWithFrame:CGRectMake(0, MainScreenHeight-minY, MainScreenWidth, 256) type:EBirthDayTypeDateAndTime];
    birthDayPickerView.delegate = self;
    [self.view addSubview: birthDayPickerView];
    
    insulinPickerView = [[BATInsulinPickerView alloc] initWithFrame:CGRectMake(0, MainScreenHeight-minY, MainScreenWidth, 256)];
    insulinPickerView.delegate = self;
    [self.view addSubview: insulinPickerView];
    [myTableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4)
    {
        return 100;
    }
    else if(indexPath.row == [titleArray count]-1)
    {
        return CGRectGetHeight( buttonView.frame) +20;
    }
    
    return CELLHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, CELLHEIGHT)];
        titlelabel.font = [UIFont fontWithName:@"Helvetica-Light" size: 14];
        titlelabel.tag = 100;
        titlelabel.textColor = AppFontColor;
        [cell.contentView addSubview:titlelabel];
    }
    cell.backgroundColor = [UIColor clearColor];
    UILabel *label = [cell.contentView viewWithTag: 100];
    label.text = titleArray[indexPath.row];
    switch (indexPath.row) {
        case 0:
        case 3:
        case 5:
        case 7:
        {
            label.textColor = AppFontGrayColor;
            cell.backgroundColor = RGBA(21, 34, 100, 0.2);
        }
            break;
        case 1:
        {
            if (![cell.contentView.subviews containsObject:nameLabel])
            {
                [cell.contentView addSubview:nameLabel];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 2:
        {
            if (![cell.contentView.subviews containsObject:doseField])
            {
                [cell.contentView addSubview:doseField];
            }
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
            NSString *strTime = @"";

            if (dateStr.length > 0)
            {
                strTime = [self stringDateFormatterStringDate:dateStr];;
            }
            else
            {
                if (isPreview) {
                    double time = [_previewModel.timeInterval  doubleValue];
                    dateStr = [KMTools getStringFromInterval:time];
                }
                else
                {
                    strTime = [self stringDateFormatterStringDate:nil];
                }
            }
            label.text = strTime;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
            break;
            case 8:
        {
            if (![cell.contentView.subviews containsObject:buttonView])
            {
                [cell.contentView addSubview:buttonView];
            }
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
    [self.view endEditing:YES];
    if (isPreview) {
        return;
    }
    if (indexPath.row == 1)
    {
        [insulinPickerView show];
        [birthDayPickerView hide];
    }
    else if (indexPath.row == 6)
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

#pragma mark - UITextViewDelegate
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

#pragma mark - BATBirthDayPickerViewDelegate
- (void)BATBirthDayPickerView:(BATBirthDayPickerView *)birthDayPickerView didSelectDateString:(NSString *)dateString
{
    dateStr = dateString;
    NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:6 inSection:0];
    [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - BATInsulinPickerViewDelegate
- (void)BATInsulinPickerView:(BATInsulinPickerView *)birthDayPickerView didSelectInsulinString:(NSString *)insulinString
{
    NSLog(@"%@",insulinString);
    nameLabel.text = insulinString;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [birthDayPickerView hide];
    [insulinPickerView hide];
    return YES;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [birthDayPickerView hide];
    [insulinPickerView hide];
    return YES;
}
#pragma mark -
- (NSString *)stringDateFormatterStringDate:(NSString *)string
{
    if (string == nil)
    {
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:zone];
        [formatter setDateFormat:@"HH:mm yyyy-MM-dd"];
        string = [formatter stringFromDate:[NSDate date]];
        
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSCharacterSet *separate = [NSCharacterSet characterSetWithCharactersInString:@" "];
        NSArray *array = [str componentsSeparatedByCharactersInSet:separate];
        dateStr = str;
        if ([array count]>1) {
            NSString *timeStr = array[1];
            NSCharacterSet *separate = [NSCharacterSet characterSetWithCharactersInString:@":"];
            NSArray *timerArray = [timeStr componentsSeparatedByCharactersInSet:separate];
            if ([timerArray count] >2)
            {
                secondStr = timerArray[2];
            }
        }
    }
    else
    {
        NSCharacterSet *setSeparate = [NSCharacterSet characterSetWithCharactersInString:@" "];
        NSArray *array = [string componentsSeparatedByCharactersInSet:setSeparate];
        if ([array count] >0) {
            string =[NSString stringWithFormat:@"%@ %@",array[1], array[0]];
        }
    }
    return string;
}

#pragma mark -  Save
- (void)saveInsulinData
{
    if (doseField.text.length < 1||nameLabel.text.length<1)
    {
        [self showText:@"请填写药品名称以及剂量"];
        return;
    }
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *timerString  = @"";
    if (dateStr.length <17) {
        timerString = [NSString stringWithFormat:@"%@:%@",dateStr,secondStr];
    }
    else
    {
        timerString = dateStr;
    }
    
    NSNumber *valueNumber = [numberFormatter numberFromString:doseField.text];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL result = [[KMDataManager sharedDatabaseInstance] insertInsulinDataModelFromNumber:nameLabel.text dose:valueNumber note:noteView.text timeScale:timerString upload:NO];
        if (result) {
            NSArray *allKeys = [[NSUserDefaults standardUserDefaults].dictionaryRepresentation allKeys];
            if (![allKeys containsObject: KEY_INSULINNAME_TARRAY]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:nameLabel.text, nil];
                [userDefaults setObject:array forKey: KEY_INSULINNAME_TARRAY];
            }
            else
            {
                NSMutableArray *array = [NSMutableArray new];
                [[userDefaults objectForKey: KEY_INSULINNAME_TARRAY] enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [array addObject:obj];
                }];
                if (![array containsObject:nameLabel.text]) {
                    [array addObject:nameLabel.text];
                    [userDefaults setObject:array forKey:KEY_INSULINNAME_TARRAY];
                }
            }
            [userDefaults synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    });
}

#pragma mark - Action
- (void)addLabelName:(UIButton *)button
{
    nameLabel.text = button.titleLabel.text;
}

-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    UIButton *button = (UIButton *)gestureRecognizer.view;
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        deleteStr = button.titleLabel.text;
        NSString *message = [NSString stringWithFormat:@"确定删除 %@ 吗?",deleteStr];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message: message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 100;
        [alertView show];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        if (buttonIndex == 1)
        {
            NSMutableArray *array = [NSMutableArray new];
            [[userDefaults objectForKey: KEY_INSULINNAME_TARRAY] enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [array addObject:obj];
            }];
            if ([array containsObject: deleteStr] )
            {
                [array removeObject: deleteStr];
                [userDefaults setObject:array forKey: KEY_INSULINNAME_TARRAY];
                [userDefaults synchronize];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setButtonView];
                [myTableView reloadData];
            });
        }
    }
}

- (CGFloat)adjustLabelFrameWidth:(UIFont *)font text:(NSString *)text
{
    CGFloat width;
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    context.minimumScaleFactor = 1.0;
    CGRect bounds;
    bounds = [text boundingRectWithSize:CGSizeMake(FLT_MAX, 30 )
                                options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:@{NSFontAttributeName:font}
                                context:context];
    width = bounds.size.width;
    return width;
}

#pragma mark
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
