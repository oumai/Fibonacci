//
//  BATInsulinPickerView.m
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/12/16.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "BATInsulinPickerView.h"

@interface BATInsulinPickerView () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,assign) NSInteger selectIndex;

@end

@implementation BATInsulinPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        _dataSource = [NSMutableArray arrayWithObjects:@"优泌林",@"优泌乐",@"诺和锐",@"诺和灵",@"诺和平",@"来得时",@"重和林",@"艾倍得",@"甘舒霖",@"长秀霖",@"速秀霖", nil];
        
        _dataDic = @{@"优泌林":@[ @"优泌林R 笔芯300IU: 3ml/支", @"优泌林 常规型400IU: 10ml/支", @"优泌林N 笔芯300IU: 3ml/支", @"优泌林 中效型300IU: 10ml/支", @"优泌林70/30 笔芯300IU: 3ml/支"],
                     @"优泌乐":@[ @"优泌乐 笔芯300IU: 3ml/支", @"优泌乐25 笔芯300IU: 3ml/支", @"优泌乐50 笔芯300IU: 3ml/支"],
                     @"诺和锐":@[ @"诺和锐 特充300IU: 3ml/支", @"诺和锐 笔芯300IU: 3ml/支", @"诺和锐30 特充300IU: 3ml/支", @"诺和锐30 笔芯300IU: 3ml/支", @"诺和锐50 笔芯300IU: 3ml/支"],
                     @"诺和灵":@[ @"诺和灵R 400IU: 10ml/支", @"诺和灵R 笔芯1000IU: 10ml/支", @"诺和灵N 400IU: 10ml/支", @"诺和灵N 特充300IU: 3ml/支", @"诺和灵N 笔芯300IU: 3ml/支", @"诺和灵30R 400IU: 10ml/支", @"诺和灵30R 笔芯1000IU: 10ml/支", @"诺和灵50R 笔芯3000IU: 13ml/支"],
                     @"诺和平":@[ @"诺和平R 特充300IU: 3ml/支", @"诺和平 笔芯300IU: 3ml/支"],
                     @"来得时":@[ @"来得时 预填充300IU: 3ml/支"],
                     @"重和林":@[ @"重和林N 笔芯300IU: 3ml/支", @"重和林N 400IU: 10ml/支", @"重和林R 笔芯300IU: 3ml/支", @"重和林R 400IU: 10ml/支", @"重和林M30 笔芯300IU: 3ml/支", @"重和林M30 400IU: 10ml/支", @"重和林M30 1000IU: 10ml/支"],
                     @"艾倍得":@[ @"艾倍得 预填充300IU: 3ml/支"],
                     @"甘舒霖":@[ @"甘舒霖 400IU: 10ml/支", @"甘舒霖R 笔芯300IU: 3ml/支", @"甘舒霖N 400IU: 10ml/支", @"甘舒霖N 笔芯300IU: 3ml/支", @"甘舒霖30R 400IU: 10ml/支", @"甘舒霖30R 笔300IU: 3ml/支", @"甘舒霖50R 笔芯300IU: 4ml/支"],
                     @"长秀霖":@[ @"长秀霖 笔芯300IU: 3ml/支"],
                     @"速秀霖":@[ @"速秀霖 笔芯300IU: 3ml/支"]
                     };
        
        toolBar = [[UIToolbar alloc] init];
        [self addSubview:toolBar];
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [self addSubview:_pickerView];
        
        WEAK_SELF(self);
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStylePlain handler:^(id sender)
                                                {
                                                    STRONG_SELF(self);
                                                    [self hide];
                                                }];
        
        UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *confirmBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"确定" style:UIBarButtonItemStylePlain handler:^(id sender)
                                                 {
                                                     STRONG_SELF(self);
                                                     [self hide];
                                                     NSInteger index = [_pickerView selectedRowInComponent:0];
                                                     NSString *key = _dataSource[index];
                                                     NSArray *array = _dataDic[key];
                                                     NSString *name = array[[_pickerView selectedRowInComponent:1]];
                                                     if (self.delegate && [self.delegate respondsToSelector:@selector(BATInsulinPickerView:didSelectInsulinString:)]) {
                                                         [self.delegate BATInsulinPickerView:self didSelectInsulinString:name];
                                                     }
                                                 }];
        
        toolBar.items = @[cancelBarButtonItem,fix,confirmBarButtonItem];
        

        [self setupConstraints];
    }
    return self;
}

- (BOOL)anySubViewScrolling:(UIView *)view{
    if ([view isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *scrollView = (UIScrollView *)view;
        if (scrollView.dragging || scrollView.decelerating) {
            return YES;
        }
    }
    for (UIView *theSubView in view.subviews)
    {
        if ([self anySubViewScrolling:theSubView])
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark - UIPickerViewDataSource
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return 60;
    }
    return MainScreenWidth-100;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger count = 0;
    switch (component) {
        case 0:
        {
            count = [_dataSource count];
        }
            break;
        case 1:
        {
            NSInteger row = [pickerView selectedRowInComponent:0];
            NSString *key = _dataSource[row];
            NSArray *array = _dataDic[key];
            count = [array count];
        }
            break;
            
        default:
            break;
    }
    return count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *string = @"";
    switch (component) {
        case 0:
        {
            if ([_dataSource count] >row) {
                string = _dataSource[row];
            }
        }
            break;
        case 1:
        {
            NSString *key = @"";
            NSInteger index = [pickerView selectedRowInComponent:0];
            if ([_dataSource count] > index) {
                key = _dataSource[index];
            }
            NSArray *array = _dataDic[key];
            if ([array count] > row) {
                string = array[row];
            }
        }
            break;
            
        default:
            break;
    }

    return string;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        if (component) {
            pickerLabel.textAlignment = NSTextAlignmentCenter;
        }
        else
        {
            pickerLabel.textAlignment = NSTextAlignmentLeft;
        }
        pickerLabel.backgroundColor = [UIColor whiteColor];
        pickerLabel.font = [UIFont fontWithName:AppFontHelvetica size:17];
        pickerLabel.textColor = RGB(78, 79, 81);
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%li === %li", component, row);
    if (component == 0) {
        [pickerView reloadComponent:1];
    }
}

#pragma mark private

- (void)setupConstraints
{
    WEAK_SELF(self);
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(toolBar.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
}

#pragma mark Action
- (void)show
{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.frame));
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
