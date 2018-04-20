//
//  ZFGenericAxis.m
//  ZFChartView
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFGenericAxis.h"
#import "ZFConst.h"
#import "ZFLabel.h"
#import "NSString+Zirkfied.h"
#import "ZFColor.h"
#import "ZFCircle.h"

@interface ZFGenericAxis()<UIScrollViewDelegate>

/** 动画时间 */
@property (nonatomic, assign) CGFloat animationDuration;
/** y轴单位Label */
@property (nonatomic, strong) ZFLabel * unitLabel;
/** 存储分段线的数组 */
@property (nonatomic, strong) NSMutableArray * sectionArray;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation ZFGenericAxis

- (NSMutableArray *)sectionArray{
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
    }
    
    return _sectionArray;
}

/**
 *  初始化默认变量
 */
- (void)commonInit{
    _yLineMinValue = 0;
    _yLineSectionCount = 5;
    _xLineNameFontSize = 10.f;
    _yLineValueFontSize = 10.f;
    _animationDuration = 1.f;
    _groupWidth = ZFAxisLineItemWidth;
    _groupPadding = ZFAxisLinePaddingForGroupsLength;
    _unitColor = ZFWhite;
    _xLineNameColor = ZFWhite;
    _yLineValueColor = ZFWhite;
    _axisLineBackgroundColor = ZFWhite;
    _axisColor = ZFWhite;
    _isShowSeparate = NO;
    _isDefaulfShow = YES;
    _separateColor = ZFWhite;
    
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    
}

- (void)drawBG
{
    _gradientLayer = [[CAGradientLayer alloc] init];
    _gradientLayer.colors = @[ (__bridge id)AppChartBGColor.CGColor, (__bridge id)RGB(13,180,135).CGColor];
    _gradientLayer.locations = @[@(0.40)];
    _gradientLayer.startPoint = CGPointMake(1, 0);
    _gradientLayer.endPoint = CGPointMake(1, 1);
    _gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer addSublayer: _gradientLayer];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        [self drawBG];
        [self commonInit];
        [self drawAxisLine];
    }
    
    return self;
}

#pragma mark - 坐标轴

/**
 *  画坐标轴
 */
- (void)drawAxisLine{
    //x轴 日期
    if (_isDefaulfShow) {
        self.xAxisLine = [[ZFXAxisLine alloc] initWithFrame:self.bounds direction:kAxisDirectionVertical];
    }
    else
    {
        self.xAxisLine = [[ZFXAxisLine alloc] initWithFrame:self.bounds direction:kAxisDirectionVertical defaulfShow:_isDefaulfShow];
    }
//
    self.xAxisLine.backgroundColor = _axisLineBackgroundColor;
    [self addSubview:self.xAxisLine];
    
    //y轴 数值
    self.yAxisLine = [[ZFYAxisLine alloc] initWithFrame:CGRectMake(0, 0, ZFAxisLineStartXPos, self.bounds.size.height) direction:kAxisDirectionVertical];
    self.yAxisLine.backgroundColor = _axisLineBackgroundColor;
    [self addSubview:self.yAxisLine];
}

#pragma mark - y轴单位Label

/**
 *  y轴单位Label
 */
- (void)addUnitLabel{
    if (_unit) {
        ZFLabel * lastLabel = (ZFLabel *)[self.yAxisLine viewWithTag:ZFAxisLineValueLabelTag + _yLineSectionCount];
    
        CGFloat width = self.yAxisLine.yLineStartXPos;
        CGFloat height = self.yAxisLine.yLineSectionHeightAverage;
        CGFloat xPos = 0;
        CGFloat yPos = CGRectGetMinY(lastLabel.frame) - height;
    
        self.unitLabel = [[ZFLabel alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
        self.unitLabel.text = [NSString stringWithFormat:@"(%@)",_unit];
        self.unitLabel.textColor = _unitColor;
        self.unitLabel.font = [UIFont boldSystemFontOfSize:9.f];
        [self.yAxisLine addSubview:self.unitLabel];
    }
}

#pragma mark - 设置x轴标题Label

/**
 *  设置x轴标题Label
 */
- (void)setXLineNameLabel{
    if (self.xLineNameArray.count > 0) {
        for (NSInteger i = 0; i < self.xLineNameArray.count; i++) {
            CGFloat width = _groupWidth;
            CGFloat height = self.frame.size.height - self.xAxisLine.xLineStartYPos - _xLineNameLabelToXAxisLinePadding;
            CGFloat center_xPos = self.xAxisLine.xLineStartXPos + _groupPadding + (_groupWidth + _groupPadding) * i + width * 0.5;
            CGFloat center_yPos = self.yAxisLine.yLineStartYPos + _xLineNameLabelToXAxisLinePadding + height * 0.5;

            //label的中心点
            CGPoint label_center = CGPointMake(center_xPos, center_yPos);
            CGRect rect = [self.xLineNameArray[i] stringWidthRectWithSize:CGSizeMake(width + _groupPadding * 0.5, height) fontOfSize:_xLineNameFontSize isBold:NO];
            ZFLabel * label = [[ZFLabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
            label.text = self.xLineNameArray[i];
            label.textColor = _xLineNameColor;
            label.font = [UIFont systemFontOfSize:_xLineNameFontSize];
            label.center = label_center;
            [self.xAxisLine addSubview:label];
        }
    }
    _gradientLayer.frame = CGRectMake(0, 0, self.xAxisLine.frame.size.width, self.frame.size.height);
    self.contentSize = CGSizeMake(self.xAxisLine.frame.size.width, self.bounds.size.height);
}

#pragma mark - 设置y轴valueLabel

/**
 *  设置y轴valueLabel
 */
- (void)setYLineValueLabel{
    CGFloat width = self.yAxisLine.yLineStartXPos;
    CGFloat height = self.yAxisLine.yLineSectionHeightAverage;
    if (self.isDefaulfShow) {
        for (NSInteger i = 0; i <= _yLineSectionCount; i++) {
            CGFloat yStartPos = self.yAxisLine.yLineStartYPos - height / 2 - height * i;
            
            ZFLabel * label = [[ZFLabel alloc] initWithFrame:CGRectMake(0, yStartPos, width, height)];
            //平均值
            float valueAverage = (_yLineMaxValue - _yLineMinValue) / _yLineSectionCount;
//            NSLog(@"%f",valueAverage);
            if (_axisLineValueType == kAxisLineValueTypeInteger) {
                if (valueAverage<1) {
                    valueAverage = 0.5;
                    label.text = [NSString stringWithFormat:@"%.1f", valueAverage * i + _yLineMinValue];
                }
                else
                {
                    label.text = [NSString stringWithFormat:@"%.0f", valueAverage * i + _yLineMinValue];
                }
                
            }else if (_axisLineValueType == kAxisLineValueTypeDecimal){
                label.text = [NSString stringWithFormat:@"%@", @(valueAverage * i + _yLineMinValue)];
                
            }
            
            label.textColor = _yLineValueColor;
            label.font = [UIFont systemFontOfSize:_yLineValueFontSize];
            label.tag = ZFAxisLineValueLabelTag + i;
            [self.yAxisLine addSubview:label];
        }
    }
    else
    {
        for (NSInteger i = 0; i <= 2; i++)
        {
            CGFloat yStartPos = self.yAxisLine.yLineStartYPos - height / 2 - height *i*_yLineSectionCount;
            ZFLabel * label = [[ZFLabel alloc] initWithFrame:CGRectMake(0, yStartPos, width, height)];
            //平均值
            float valueAverage = (_yLineMaxValue - _yLineMinValue) / _yLineSectionCount;
//            NSLog(@"%f",valueAverage);
            if (_axisLineValueType == kAxisLineValueTypeInteger) {
                if (valueAverage<1) {
                    valueAverage = 0.5;
                    label.text = [NSString stringWithFormat:@"%.1f", valueAverage * i*_yLineSectionCount + _yLineMinValue];
                }
                else
                {
                    label.text = [NSString stringWithFormat:@"%.0f", valueAverage * i*_yLineSectionCount + _yLineMinValue];
                }
                
            }else if (_axisLineValueType == kAxisLineValueTypeDecimal){
                label.text = [NSString stringWithFormat:@"%@", @(valueAverage * i*_yLineSectionCount + _yLineMinValue)];
                
            }
            
            label.textColor = _yLineValueColor;
            label.font = [UIFont systemFontOfSize:_yLineValueFontSize];
            label.tag = ZFAxisLineValueLabelTag + i;
            [self.yAxisLine addSubview:label];

        }
    }
}

#pragma mark - 灰色分割线

/**
 *  灰色分割线起始位置 (未填充)
 *
 *  @param i 下标
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)yAxisLineSectionNoFill:(NSInteger)i {
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    CGFloat yStartPos = self.yAxisLine.yLineStartYPos - (self.yAxisLine.yLineHeight - ZFAxisLineGapFromAxisLineMaxValueToArrow) / _yLineSectionCount * (i + 1);
    [bezier moveToPoint:CGPointMake(self.yAxisLine.yLineStartXPos, yStartPos)];
    [bezier addLineToPoint:CGPointMake(self.yAxisLine.yLineStartXPos, yStartPos)];
    
    return bezier;
}

/**
 *  画灰色分割线
 *
 *  @param i 下标
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawYAxisLineSection:(NSInteger)i sectionLength:(CGFloat)sectionLength{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    CGFloat yStartPos = self.yAxisLine.yLineStartYPos - (self.yAxisLine.yLineHeight - ZFAxisLineGapFromAxisLineMaxValueToArrow) / _yLineSectionCount * (i + 1);
    [bezier moveToPoint:CGPointMake(self.yAxisLine.yLineStartXPos, yStartPos)];
    [bezier addLineToPoint:CGPointMake(self.yAxisLine.yLineStartXPos + sectionLength, yStartPos)];
    
    return bezier;
}

/**
 *  灰色分割线CAShapeLayer
 *
 *  @param i 下标
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)yAxisLineSectionShapeLayer:(NSInteger)i sectionLength:(CGFloat)sectionLength sectionColor:(UIColor *)sectionColor{
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.strokeColor = _separateColor.CGColor;
    layer.path = [self drawYAxisLineSection:i sectionLength:sectionLength].CGPath;
    
    return layer;
}

#pragma mark - y轴分段线

/**
 *  y轴分段线
 */
- (UIView *)sectionView:(NSInteger)i{
    CGFloat yStartPos = self.yAxisLine.yLineStartYPos - (self.yAxisLine.yLineHeight - ZFAxisLineGapFromAxisLineMaxValueToArrow) / _yLineSectionCount * (i + 1);
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(self.yAxisLine.yLineStartXPos + self.contentOffset.x, yStartPos, ZFAxisLineSectionLength, ZFAxisLineSectionHeight)];
    view.backgroundColor = _axisColor;
    view.alpha = 0.f;
    
    if (_isAnimated) {
        [UIView animateWithDuration:_animationDuration animations:^{
            view.alpha = 1.f;
        }];
    }else{
        view.alpha = 1.f;
    }
    
    return view;
}

#pragma mark - 清除控件

/**
 *  清除之前所有控件
 */
- (void)removeAllSubviews{
    NSArray * subviews1 = [NSArray arrayWithArray:self.xAxisLine.subviews];
    for (UIView * view in subviews1) {
        if ([view isKindOfClass:[ZFLabel class]]) {
            [(ZFLabel *)view removeFromSuperview];
        }
    }
    
    NSArray * subviews2 = [NSArray arrayWithArray:self.yAxisLine.subviews];
    for (UIView * view in subviews2) {
        if ([view isKindOfClass:[ZFLabel class]]) {
            [(ZFLabel *)view removeFromSuperview];
        }
    }
    
    NSArray * sublayers = [NSArray arrayWithArray:self.layer.sublayers];
    for (CALayer * layer in sublayers) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
    
    for (UIView * view in self.sectionArray) {
        [view removeFromSuperview];
    }
    [self.sectionArray removeAllObjects];
}

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    [self removeAllSubviews];
    [self.sectionArray removeAllObjects];
    self.yAxisLine.yLineSectionCount = _yLineSectionCount;
    
    if (self.xLineValueArray.count > 0) {
        //根据item个数,设置x轴长度
        if ([self.xLineValueArray[0] isKindOfClass:[NSArray class]]) {
            NSUInteger maxCount = 0 ;
            for (int i = 0; i < [self.xLineValueArray count]; i++)
            {
                NSArray *iArray = self.xLineValueArray[i];
                if ([iArray count]>maxCount) {
                    maxCount = [iArray count];
                }
            }
            self.xAxisLine.xLineWidth = maxCount * (_groupWidth + _groupPadding) + _groupPadding;
        }
        else
        {
            self.xAxisLine.xLineWidth = self.xLineValueArray.count * (_groupWidth + _groupPadding) + _groupPadding;
        }
    }
    else
    {
        self.xAxisLine.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    self.xAxisLine.isDefaulfShow = self.isDefaulfShow;
    self.xAxisLine.isAnimated = _isAnimated;
    self.yAxisLine.isAnimated = _isAnimated;
    
    [self.xAxisLine strokePath];
    [self.yAxisLine strokePath];
    [self setXLineNameLabel];
    [self setYLineValueLabel];
    [self addUnitLabel];
    if (_isDefaulfShow) {
        for (NSInteger i = 0; i < _yLineSectionCount; i++) {
            if (_isShowSeparate)
            {
                [self.layer addSublayer:[self yAxisLineSectionShapeLayer:i sectionLength:self.xLineWidth sectionColor:ZFLightGray]];
            }
            else{
                UIView * sectionView = [self sectionView:i];
                [self addSubview:sectionView];
                [self.sectionArray addObject:sectionView];
            }
        }
    }
}

/**
 *  把分段线放的父控件最上面
 */
- (void)bringSectionToFront{
    if (!_isShowSeparate) {
        for (NSInteger i = 0; i < self.sectionArray.count; i++) {
            UIView * sectionView = self.sectionArray[i];
            [self bringSubviewToFront:sectionView];
        }
    }
}

- (void)bringCircleToFront
{
    for (UIView *elem in self.subviews) {
        if([elem isKindOfClass:[ZFCircle class]])
        {
            [self bringSubviewToFront:elem];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //滚动时重设y轴的frame
    self.yAxisLine.frame = CGRectMake(scrollView.contentOffset.x, self.yAxisLine.frame.origin.y, self.yAxisLine.frame.size.width, self.yAxisLine.frame.size.height);
    
    if (!_isShowSeparate) {
        for (NSInteger i = 0; i < self.sectionArray.count; i++) {
            UIView * sectionView = self.sectionArray[i];
            sectionView.frame = CGRectMake(self.yAxisLine.yLineStartXPos + self.contentOffset.x, sectionView.frame.origin.y, sectionView.frame.size.width, sectionView.frame.size.height);
        }
    }
}

#pragma mark - 重写setter,getter方法

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.xAxisLine.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);    
    self.yAxisLine.frame = CGRectMake(self.contentOffset.x, 0, ZFAxisLineStartXPos, frame.size.height);
}

/** y轴背景颜色 */
- (void)setAxisLineBackgroundColor:(UIColor *)axisLineBackgroundColor{
    _axisLineBackgroundColor = axisLineBackgroundColor;
    self.yAxisLine.backgroundColor = _axisLineBackgroundColor;
    self.xAxisLine.backgroundColor = _axisLineBackgroundColor;
}

/** 设置坐标轴颜色 */
- (void)setAxisColor:(UIColor *)axisColor{
    _axisColor = axisColor;
    self.xAxisLine.axisColor = _axisColor;
    self.yAxisLine.axisColor = _axisColor;
}

/**
 *  获取坐标轴起点x值
 */
- (CGFloat)axisStartXPos{
    return self.xAxisLine.xLineStartXPos;
}

/**
 *  获取坐标轴起点Y值
 */
- (CGFloat)axisStartYPos{
    return self.xAxisLine.xLineStartYPos;
}

/**
 *  获取y轴最大上限值y值
 */
- (CGFloat)yLineMaxValueYPos{
    return self.yAxisLine.yLineEndYPos + ZFAxisLineGapFromAxisLineMaxValueToArrow;
}

/**
 *  获取y轴最大上限值与0值的高度
 */
- (CGFloat)yLineMaxValueHeight{
    return self.yAxisLine.yLineStartYPos - (self.yAxisLine.yLineEndYPos + ZFAxisLineGapFromAxisLineMaxValueToArrow);
}

/** 
 *  获取x轴宽度 
 */
- (CGFloat)xLineWidth{
    return self.xAxisLine.xLineWidth;
}

- (void)setIsDefaulfShow:(BOOL)isDefaulfShow
{
    _isDefaulfShow = isDefaulfShow;
    self.xAxisLine.isDefaulfShow = isDefaulfShow;
}
@end
