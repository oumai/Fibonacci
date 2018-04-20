//
//  ManuallyEnteredViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/10/13.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "ManuallyEnteredViewController.h"

@interface ManuallyEnteredViewController ()
@property (nonatomic, strong) UIPickerView *valuePickerView;
@property (nonatomic, strong) UIPickerView *lowPickerView;
@property (nonatomic, strong) UILabel *hudLabel;
@property (nonatomic, strong) UILabel *heightHudLabel;
@property (nonatomic, strong) UILabel *lowHudLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@end

@implementation ManuallyEnteredViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"不准";
    [self pagesLayout];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout
- (void)pagesLayout {
    /**
     *  判断手机型号，调整整体布局
     */
    CGFloat lineSpa;
    if(iPhone4){
        lineSpa = 20;
    }
    else if (iPhone5)
    {
        lineSpa = 50;
    }
    else
    {
        lineSpa = 100;
    }
    WEAK_SELF(self);
    //是否血压
    BOOL isBloodPressure = NO;
    if (_enteredType == 1)
    {
        isBloodPressure = YES;
    }
    
    [self.view addSubview:self.hudLabel];
    [self.hudLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.view.mas_top).offset(85);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(MainScreenWidth);
    }];
    
    if (isBloodPressure)
    {
        [self.view addSubview:self.heightHudLabel];
        [self.heightHudLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.hudLabel.mas_bottom).offset(25);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(MainScreenWidth);
        }];
    }
    
    [self.view addSubview:self.valuePickerView];
    [self.valuePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isBloodPressure) {
            make.top.equalTo(self.heightHudLabel.mas_bottom);
        }
        else
        {
            make.top.equalTo(self.hudLabel.mas_bottom).offset(95);
        }
        make.height.mas_equalTo(isBloodPressure?130.0:162.0);
        make.width.mas_equalTo(MainScreenWidth);
    }];
    
    if (_enteredType == 1)
    {
        [self.view addSubview:self.lowHudLabel];
        [self.lowHudLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.valuePickerView.mas_bottom);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(MainScreenWidth);
        }];
        
        [self.view addSubview:self.lowPickerView];
        [self.lowPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lowHudLabel.mas_bottom);
            make.height.mas_equalTo(isBloodPressure?130.0:162.0);
            make.width.mas_equalTo(MainScreenWidth);
        }];
    }
    
    [self.view addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-lineSpa);
        make.height.mas_equalTo(45);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(MainScreenWidth/3);
    }];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    switch (_enteredType) {
        case EEnteredHeartRateType:
        case EEnteredBloodPressureType:
        case EEnteredHealthStepType:
        case EEnteredVisionDataType:
            return 3;
            break;
        case EEnteredBloodOxygenType:
            return 2;
            break;
        case EEnteredVitalCapacityType:
            return 4;
            break;
//        case EEnteredVisionDataType:
//            return 3;
//            break;
        default:
            break;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_enteredType == EEnteredVisionDataType &&component ==1) {
        return 1;
    }
    return 10;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_enteredType == EEnteredVisionDataType &&component ==1) {
        return @".";
    }
    NSString *str = [NSString stringWithFormat:@"%li",row];
    return str;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component

{
    if (_enteredType == EEnteredVisionDataType &&component ==1) {
        return 20;
    }
    return 50;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lbl = (UILabel *)view;
    if (lbl == nil) {
        lbl = [[UILabel alloc]init];
        //在这里设置字体相关属性
        lbl.font = [UIFont systemFontOfSize:20];
        lbl.textColor = RGB(99,177,249);
        [lbl setTextAlignment: NSTextAlignmentCenter];
        [lbl setBackgroundColor:[UIColor clearColor]];
    }
    //重新加载lbl的文字内容
    lbl.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return lbl;
}


#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    NSLog(@"%li",pickerView.numberOfComponents);
}

#pragma mark - Button
- (void)confirmAciton:(UIButton *)button
{
    NSInteger component = self.valuePickerView.numberOfComponents;
    NSString *numberStr = @"";
    for (int i = 0; i < component; i++)
    {
        NSInteger selectedRow = [self.valuePickerView selectedRowInComponent:i];
        
        if (_enteredType == EEnteredVisionDataType&&i==1) {
            numberStr = [numberStr stringByAppendingFormat:@"."];
        }
        else
        {
            numberStr = [numberStr stringByAppendingFormat:@"%li",selectedRow];
        }

    }

    CGFloat numberFloat = [numberStr floatValue];
    
    NSInteger lowComponent = self.lowPickerView.numberOfComponents;
    NSString *lowNumberStr = @"";
    for (int i = 0; i < lowComponent; i++)
    {
        NSInteger selectedRow = [self.lowPickerView selectedRowInComponent:i];
        lowNumberStr = [lowNumberStr stringByAppendingFormat:@"%li",selectedRow];
    }
    CGFloat lowNumberFloat = [lowNumberStr floatValue];
    
    switch (_enteredType) {
        case EEnteredHeartRateType:
        {
            if (numberFloat>220 ||numberFloat <50) {
                [self showText:@"请选择正确的数值"];
                return;
            }
            else
            {
                NSNumber *number = [NSNumber numberWithFloat:numberFloat];
//                NSLog(@"%@",number);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[KMDataManager sharedDatabaseInstance] insertHeartRateDataModelNumber:number];
                });
            }
        }
            break;
        case EEnteredBloodPressureType:
        {
            if (lowNumberFloat>120||numberFloat<80)
            {
                [self showText:@"请选择正确的数值"];
                return;
            }
            else
            {
                NSNumber *number = [NSNumber numberWithFloat:numberFloat];
                NSNumber *lowNumber = [NSNumber numberWithFloat:lowNumberFloat];
//                NSLog(@"%@",number);
//                NSLog(@"low %@",lowNumber);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[KMDataManager sharedDatabaseInstance] insertBloodPressureDataModelFromSPNumber:number andDPNumber:lowNumber];
                });
            }
        }
            break;
        case EEnteredBloodOxygenType:
        {
            if (numberFloat>110 ||numberFloat <85) {
                [self showText:@"请选择正确的数值"];
                return;
            }
            else
            {
                NSNumber *number = [NSNumber numberWithFloat:numberFloat];
//                NSLog(@"%@",number);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[KMDataManager sharedDatabaseInstance] insertBloodOxygenDataModelFromNumber:number];
                });
            }
        }
            break;
        case EEnteredVitalCapacityType:
        {
            if (numberFloat <1000||numberFloat >6000) {
                [self showText:@"请选择正确的数值"];
                return;
            }
            else
            {
                NSNumber *number = [NSNumber numberWithFloat:numberFloat];
//                NSLog(@"%@",number);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[KMDataManager sharedDatabaseInstance] insertVitalCapacityDataModelFromNumber:number];
                });
            }
        }
            break;
        case EEnteredVisionDataType:
        {
            if (numberFloat >5.2) {
                [self showText:@"请选择正确的数值"];
                return;
            }
            else
            {
                NSNumber *number = [NSNumber numberWithFloat:numberFloat];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[KMDataManager sharedDatabaseInstance] insertVisionDataModelFromNumber:number];
                });
            }
        }
            break;
        default:
            break;
    }
    [self showSuccessWithText:@"已添加数据"];
     [button setUserInteractionEnabled:NO];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 *NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

#pragma mark - setter && getter
- (UILabel *)hudLabel
{
    if (!_hudLabel) {
        _hudLabel = [[UILabel alloc] init];
        _hudLabel.text = @"测试不准，尝试手动输入吧";
        _hudLabel.textAlignment = NSTextAlignmentCenter;
        _hudLabel.textColor = RGB(99,177,249);
        _hudLabel.font = [UIFont fontWithName:@"Helvetica-Light" size: 16];
    }
    return _hudLabel;
}

- (UILabel *)heightHudLabel
{
    if (!_heightHudLabel) {
        _heightHudLabel = [[UILabel alloc] init];
        _heightHudLabel.text = @"      高压/mmHg";
        _heightHudLabel.textAlignment = NSTextAlignmentLeft;
        _heightHudLabel.textColor = AppFontGrayColor;
        _heightHudLabel.backgroundColor = [UIColor clearColor];
        _heightHudLabel.font = [UIFont fontWithName:@"Helvetica-Light" size: 14];
    }
    return _heightHudLabel;
}

- (UILabel *)lowHudLabel
{
    if (!_lowHudLabel) {
        _lowHudLabel = [[UILabel alloc] init];
        _lowHudLabel.text = @"      低压/mmHg";
        _lowHudLabel.textAlignment = NSTextAlignmentLeft;
        _lowHudLabel.textColor = AppFontGrayColor;
        _lowHudLabel.backgroundColor = [UIColor clearColor];
        _lowHudLabel.font = [UIFont fontWithName:@"Helvetica-Light" size: 14];
    }
    return _lowHudLabel;
}

- (UIPickerView *)valuePickerView {
    if (!_valuePickerView) {
        _valuePickerView = [[UIPickerView alloc] init];
        _valuePickerView.delegate = self;
        _valuePickerView.dataSource = self;
        _valuePickerView.tag = 100;
        _valuePickerView.showsSelectionIndicator = YES;
    }
    return _valuePickerView;
}

- (UIPickerView *)lowPickerView
{
    if (!_lowPickerView) {
        _lowPickerView = [[UIPickerView alloc] init];
        _lowPickerView.delegate = self;
        _lowPickerView.dataSource = self;
        _lowPickerView.tag = 101;
        _lowPickerView.showsSelectionIndicator = YES;

    }
    return _lowPickerView;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom Title:@"确定" titleColor:[UIColor whiteColor] backgroundColor:nil backgroundImage:[UIImage imageNamed:@"btn"] Font:[UIFont systemFontOfSize:17]];
        [_confirmButton addTarget:self action:@selector(confirmAciton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
