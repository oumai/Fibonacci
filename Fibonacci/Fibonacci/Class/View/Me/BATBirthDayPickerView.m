//
//  BATAgePickerView.m
//  Fibonacci
//
//  Created by woaiqiu947 on 16/10/10.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "BATBirthDayPickerView.h"
@interface BATBirthDayPickerView ()

@property (nonatomic,strong) NSMutableArray *yearSource;
@property (nonatomic,strong) NSMutableArray *monthSource;
@property (nonatomic,strong) NSMutableArray *datySource;
@property (nonatomic,strong) NSString *selectSex;

@property (nonatomic,assign) NSInteger selectIndex;

@end

@implementation BATBirthDayPickerView

- (instancetype)initWithFrame:(CGRect)frame type:(EBirthDayType)type
{
    birthDayType = type;
    return [self initWithFrame:frame ];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _selectSex = @"18";
        _selectIndex = 17;
        
        _toolBar = [[UIToolbar alloc] init];
        [self addSubview:_toolBar];
        
        WEAK_SELF(self);
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStylePlain handler:^(id sender) {
            STRONG_SELF(self);
            [self hide];
        }];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        
        _pickerView = [[UIDatePicker alloc] init];
        switch (birthDayType) {
            case EBirthDayTypeDefault:
            {
                [comps setYear:-100];
                NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
                
                _pickerView.minimumDate = minDate;
                _pickerView.maximumDate = [NSDate date];
                _pickerView.datePickerMode = UIDatePickerModeDate;
            }
                break;
            case EBirthDayTypeDateAndTime:
            {
                [comps setYear:-100];
                NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
                
                _pickerView.minimumDate = minDate;
                _pickerView.maximumDate = [NSDate date];
                _pickerView.datePickerMode = UIDatePickerModeDateAndTime;
            }
                break;
            case EBirthDayTypeDateWeek:
            {
                _pickerView.datePickerMode = UIDatePickerModeDate;
                [comps setDay:7];
                NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
                _pickerView.minimumDate = [NSDate date];
                _pickerView.maximumDate = maxDate;
            }
                break;
            case EBirthDayTypeDateTime:
            {
                _pickerView.datePickerMode = UIDatePickerModeTime;
//                _pickerView.minimumDate = [NSDate dateWithTimeIntervalSinceNow:72 * 60 * 60 * -1];
//                _pickerView.maximumDate = [NSDate dateWithTimeIntervalSinceNow:72 * 60 * 60 * -1];
            }
                break;
                
                
            default:
                break;
        }
        //NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _pickerView.locale = [NSLocale currentLocale];
        [self addSubview:_pickerView];
        
        UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *confirmBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"确定" style:UIBarButtonItemStylePlain handler:^(id sender) {
            STRONG_SELF(self);
            [self hide];
            NSDate *date = _pickerView.date;
            NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
            if (birthDayType == EBirthDayTypeDateAndTime)
            {
                fmt.dateFormat = @"yyyy-MM-dd HH:mm";
            }
            else if(birthDayType == EBirthDayTypeDateTime)
            {
                fmt.dateFormat = @"HH:mm";
            }
            else
            {
                fmt.dateFormat = @"yyyy-MM-dd";
            }
            NSString *dateStr = [fmt stringFromDate:date];
            if (self.delegate && [self.delegate respondsToSelector:@selector(BATBirthDayPickerView:didSelectDateString:)]) {
                [self.delegate BATBirthDayPickerView:self didSelectDateString:dateStr ];
            }
        }];
        _toolBar.items = @[cancelBarButtonItem,fix,confirmBarButtonItem];
        
        [self setupConstraints];
        
    }
    return self;
}

- (NSMutableArray *)yearSource
{
    if (!_yearSource) {
        _yearSource = [NSMutableArray new];
        int i = 1;
        while ([_yearSource count]<99) {
            [_yearSource addObject: [NSString stringWithFormat:@"%d",i]];
            i++;
        }
    }
    return _yearSource;
}

- (NSMutableArray *)monthSource
{
    if (!_yearSource) {
        _yearSource = [NSMutableArray new];
        int i = 1;
        while ([_yearSource count]<99) {
            [_yearSource addObject: [NSString stringWithFormat:@"%d",i]];
            i++;
        }
    }
    return _yearSource;
}

- (NSMutableArray *)datySource
{
    if (!_datySource) {
        _datySource = [NSMutableArray new];
        int i = 1;
        while ([_datySource count]<30) {
            [_datySource addObject: [NSString stringWithFormat:@"%d",i]];
            i++;
        }
    }
    return _datySource;
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_yearSource count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _yearSource[row];
}


#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectIndex = row;
    _selectSex = _yearSource[row];
}

#pragma mark private

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(_toolBar.mas_bottom);
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
