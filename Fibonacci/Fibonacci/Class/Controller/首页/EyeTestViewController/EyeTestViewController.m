//
//  EyeTestViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 16/9/20.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "EyeTestViewController.h"
#import "EyeTestResultViewController.h"
#import "ColorBlindResultViewController.h"
#import "HelpViewController.h"
#import "EView.h"
#import "TXHRrettyRuler.h"
#import "EyeButton.h"
#import "JudgeView.h"
#import "EyeHelpCustom.h"

@interface EyeTestViewController ()

@end

@implementation EyeTestViewController
-(void)dealloc
{
    colorBlindPicker.delegate = nil;
    rulerView.rulerDeletate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视力测量";
    [self initHelpButton:@selector(goHelpVC)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getFirstOpenValue];
    [self creatSegment];
    if (IS_IPHONE_X)
    {
        buttonViewTopConstraint.constant = 74;
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initEyeTestViewData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!onceHelp) {
        [EyeHelpCustom presentEyeHelpView:NEyeHelpViewTypeDefault];
        [self setFisrtOpenValue:0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)creatSegment
{
    colorBlindView.hidden = YES;
    judgeX = MainScreenWidth;
    [eyeTestButton addTarget:self action:@selector(btnsendClick:) forControlEvents:UIControlEventTouchUpInside];
    [colorBlindButton addTarget:self action:@selector(btnsendClick:) forControlEvents:UIControlEventTouchUpInside];
    [eyeListButton addTarget:self action:@selector(btnsendClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [colorBlindButton setTitleColor:AppFontColor forState: UIControlStateNormal];
    [eyeListButton setTitleColor:AppFontColor forState: UIControlStateNormal];

    eyeTestView.hidden = NO;
    colorBlindView.hidden = YES;
    eyeListView.hidden = YES;
    
    lineLayer = [CALayer layer];
    buttonWidth = MainScreenWidth/4;
    buttonX = (MainScreenWidth/3-buttonWidth)/2;
    lineLayer.frame = CGRectMake( buttonX, 42, buttonWidth, 3);
    lineLayer.backgroundColor = [RGB(219, 155, 57) CGColor];
    [buttonView.layer addSublayer:lineLayer];
    
}

-(void)initEyeTestViewData
{
    if (once) {
        return;
    }
    once = YES;
    
    EWidth = MainScreenWidth/3;
    eView = [[EView alloc] initWithFrame:CGRectMake(EWidth, 40, EWidth, EWidth)];
    ECenter = eView.center;
    eView.backgroundColor = [UIColor clearColor];
    randomNumber = 3;
    [eView setEViewTransform:[self getRandomNumbeWithExclude:randomNumber]];
    [eyeTestView addSubview:eView];
    
    CGFloat scrollY = CGRectGetMaxY(eView.frame)+50;
    rulerView = [[TXHRrettyRuler alloc] initWithFrame:CGRectMake(0, scrollY, [UIScreen mainScreen].bounds.size.width, 100)];
    rulerView.rulerDeletate = self;
    scrollRulerValue = 3.0f;
    
    [rulerView showRulerScrollViewWithCount:520 start:300 average:[NSNumber numberWithFloat:0.01] currentValue:scrollRulerValue smallMode:YES];
    [eyeTestView addSubview:rulerView];
    
    eyeButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(rulerView.frame), MainScreenWidth, 150)];
    eyeButtonView.backgroundColor = [UIColor clearColor];
    [eyeTestView addSubview:eyeButtonView];
    
    CGPoint yeButtonCenter = CGPointMake(MainScreenWidth/2, CGRectGetHeight(eyeButtonView.frame)/2);
    CGFloat eyebuttonW = 65;
    CGFloat eyebuttonH = 40;
    CGFloat eyeButtonX = 0.f;
    CGFloat eyeButtonY = 0.f;
    for (int i = 0; i <4; i++)
    {
        EyeButton *button = [EyeButton buttonWithType: UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, eyebuttonW, eyebuttonH);
        switch (i) {
            case 0:
            {
                eyeButtonX = yeButtonCenter.x;
                eyeButtonY = yeButtonCenter.y-eyebuttonH;
            }
                break;
            case 1:
            {
                eyeButtonY = yeButtonCenter.y;
                eyeButtonX = yeButtonCenter.x+eyebuttonW*1.3;
            }
                break;
            case 2:
            {
                eyeButtonX = yeButtonCenter.x;
                eyeButtonY = yeButtonCenter.y+eyebuttonH;
                
            }
                break;
            case 3:
            {
                eyeButtonY = yeButtonCenter.y;
                eyeButtonX = yeButtonCenter.x-eyebuttonW*1.3;
            }
                break;
                
            default:
                break;
        }
        button.layer.cornerRadius = eyebuttonH/4;
        button.layer.masksToBounds = YES;
        button.center = CGPointMake(eyeButtonX, eyeButtonY);
        [button eyeButtonTransform:i];
        button.tag = i;
        [button addTarget:self action:@selector(eyeViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.backgroundColor = RGB(87, 165, 239);
        [eyeButtonView addSubview:button];
    }
}

-(void)initcolorBlindViewData
{
    if (onceColor) {
        return;
    }
    onceColor = YES;
    imageNameArray = [NSMutableArray new];
    colorResultArray = [NSMutableArray new];
    
    colorBlindScroll =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 196)];
//    colorBlindScroll.backgroundColor = [UIColor whiteColor];
    colorBlindScroll.scrollEnabled = NO;
    colorBlindScroll.showsHorizontalScrollIndicator = YES;
    colorBlindScroll.showsVerticalScrollIndicator = YES;
    [colorBlindView addSubview:colorBlindScroll];
    
    colorBlindArray = @[@"color_3", @"color_6", @"color_7", @"color_9", @"color_12", @"color_26", @"color_29", @"color_45"];
    colorBlindCacheArray = [[NSMutableArray alloc] initWithArray:colorBlindArray];
    singleDigitArray = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
    tensDigitArray = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
    singleDigitString = @"0";
    tensDigitString = @"0";
    
    [self reloadSetImageValue];
    
    colorBlindPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(colorBlindScroll.frame), MainScreenWidth, 216)];
    // 显示选中框
//    colorBlindPicker.backgroundColor = [UIColor whiteColor];
    colorBlindPicker.showsSelectionIndicator=YES;
    colorBlindPicker.dataSource = self;
    colorBlindPicker.delegate = self;
    [colorBlindView addSubview:colorBlindPicker];
    
    CGFloat hieghtSpacing;
    if([UIScreen mainScreen].bounds.size.height >= 667 ){
        hieghtSpacing = 50;
    }else{
        hieghtSpacing = 0;
    }
    
    dimnessButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dimnessButton.frame = CGRectMake( 44, CGRectGetMaxY(colorBlindPicker.frame)+hieghtSpacing, (MainScreenWidth - 88 - 55)/2, 45);
    [dimnessButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dimnessButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [dimnessButton setTitle:@"看不清楚" forState:UIControlStateNormal];
    [dimnessButton addTarget:self action:@selector(colorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"btn"];
    [dimnessButton setBackgroundImage: image forState:UIControlStateNormal];
    [colorBlindView addSubview: dimnessButton];
    
    confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake( CGRectGetMaxX(dimnessButton.frame) + 55, CGRectGetMinY(dimnessButton.frame), CGRectGetWidth(dimnessButton.frame), 45);
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [confirmButton setTitle:@"确认输入" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(colorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setBackgroundImage: image forState:UIControlStateNormal];
    [colorBlindView addSubview: confirmButton];
    
    [colorBlindPicker reloadAllComponents];
}

//视力表
-(void)initEyeListViewData
{
    if (onceList) {
        return;
    }
    onceList = YES;
    eyeListScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, CGRectGetHeight(eyeListView.frame))];
//    eyeListScrollView.backgroundColor = [UIColor whiteColor];
    eyeListScrollView.showsHorizontalScrollIndicator = YES;
    eyeListScrollView.showsVerticalScrollIndicator = YES;
    [eyeListView addSubview:eyeListScrollView];
    
    NSArray *leftArray = @[@"0.01",@"0.012",@"0.015",@"0.02",@"0.025",@"0.03",@"0.04",@"0.05",@"0.06",@"0.08",@"0.1",@"0.12",@"0.15",@"0.2",@"0.25",@"0.3",@"0.4",@"0.5",@"0.6",@"0.8",@"1.0",@"1.2",@"1.5",];
    NSArray *rightArray = @[@"3.0",@"3.1",@"3.2",@"3.3",@"3.4",@"3.5",@"3.6",@"3.7",@"3.8",@"3.9",@"4.0",@"4.1",@"4.2",@"4.3",@"4.4",@"4.5",@"4.6",@"4.7",@"4.8",@"4.9",@"5.0",@"5.1",@"5.2",];

    CGFloat intervaWidth = 40;
    CGFloat intervaX = 15;
    CGFloat initialWidth = MainScreenWidth/3;;
    CGFloat areaWidth = MainScreenWidth-intervaWidth*2;
    CGFloat eViewX = 0;
    CGFloat eViewY = 0;
    CGFloat eViewInitialY = 30;
    CGFloat eViewLastX = 0;
    CGFloat eViewLastY = 0;
    CGFloat eViewLastMaxY = 0;
    NSInteger viewNumber;
    NSInteger lastI = 0;
    for (int i = 0; i <[leftArray count]; i++)
    {
        if (i == 0) {
            viewNumber = 1;
        }
        else
        {
            viewNumber = areaWidth/(initialWidth+intervaX);
        }
        lastI = 0;
        for (int j = 0; j< viewNumber; j++)
        {
            if (j==lastI) {
                eViewX = intervaWidth+(areaWidth-viewNumber*initialWidth-((viewNumber-1)*intervaX))/2;
                eViewY = eViewInitialY+eViewLastMaxY;
            }
            else
            {
                eViewX = eViewLastX+intervaX;
                eViewY = eViewLastY;
                lastI = j;
            }
            EView *view = [[EView alloc] initWithFrame:CGRectMake(eViewX, eViewY, initialWidth, initialWidth) withFillColorType:EViewColorTypeAppFontColor];
            [view setEViewTransform:[self getRandomNumbeFromList:randomNumberList]];
            [eyeListScrollView addSubview:view];
            view.backgroundColor = [UIColor clearColor];
            eViewLastX = CGRectGetMaxX(view.frame);
            eViewLastY = CGRectGetMinY(view.frame);
            eViewLastMaxY = CGRectGetMaxY(view.frame);
        }
        CGFloat labelY = eViewLastMaxY-initialWidth/2-15;
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, labelY , intervaWidth, 30)];
        leftLabel.text = leftArray[i];
        leftLabel.font = [UIFont systemFontOfSize:10];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.textColor = AppFontColor;
        [eyeListScrollView addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth-intervaWidth, labelY , intervaWidth, 30)];
        rightLabel.text = rightArray[i];
        rightLabel.font = [UIFont systemFontOfSize:10];
        rightLabel.textAlignment = NSTextAlignmentCenter;
        rightLabel.textColor = AppFontColor;
        [eyeListScrollView addSubview:rightLabel];
        
        initialWidth *=0.8;
    }
    [eyeListScrollView setContentSize:CGSizeMake(0, eViewLastY + 30)];
    
    CALayer *leftLineLayer = [CALayer layer];
    leftLineLayer.frame = CGRectMake( intervaWidth, 0, 1, eViewLastY+ 30);
    leftLineLayer.backgroundColor = [AppFontGrayColor CGColor];
    [eyeListScrollView.layer addSublayer:leftLineLayer];
    
    CALayer *rightLineLayer = [CALayer layer];
    rightLineLayer.frame = CGRectMake( MainScreenWidth-intervaWidth, 0, 1, eViewLastY+ 30);
    rightLineLayer.backgroundColor = [AppFontGrayColor CGColor];
    [eyeListScrollView.layer addSublayer:rightLineLayer];
}

-(void)lineAnimation:(UIButton *)sender{
    UIView *view = sender.superview;
    for (UIButton *btn in view.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.selected = NO;
        }
    }
    sender.selected = YES;
    
    [UIView beginAnimations:nil context:nil];
    lineLayer.frame = CGRectMake(sender.frame.origin.x+buttonX , eyeTestButton.frame.size.height, buttonWidth, 3);
    [UIView commitAnimations];
}

#pragma mark - Action
-(void)btnsendClick:(UIButton *)sender{
    [self lineAnimation:sender];
    for (UIButton *elem in buttonView.subviews) {
        if ([elem isEqual:sender]) {
            [elem setTitleColor:RGB(219, 155, 57) forState: UIControlStateNormal];
        }
        else
        {
            [elem setTitleColor:AppFontColor forState: UIControlStateNormal];
        }
    }
    if (sender == eyeTestButton) {
        [TalkingData trackEvent:@"210000501" label:@"视力测试>视力检查"];
        eyeTestView.hidden = NO;
        colorBlindView.hidden = YES;
        eyeListView.hidden = YES;
    }
    else if(sender == colorBlindButton)
    {
        [TalkingData trackEvent:@"210000502" label:@"视力测试>色盲测试"];
        [self initcolorBlindViewData];
        eyeTestView.hidden = YES;
        colorBlindView.hidden = NO;
        eyeListView.hidden = YES;
        if (!onceColorHelp) {
            [EyeHelpCustom presentEyeHelpView:NEyeHelpViewTypeColor];
            [self setFisrtOpenValue:1];
        }
    }
    else if(sender == eyeListButton)
    {
        colorBlindView.hidden = YES;
        eyeTestView.hidden = YES;
        eyeListView.hidden = NO;
        [self initEyeListViewData];
    }
}

-(void)eyeViewButtonClick:(EyeButton *)sender
{
    if ([eView eViewTransformDirection:sender.tag] )
    {
        errorCount = 0;
        rightCount ++;
        [eView setEViewTransform:[self getRandomNumbeWithExclude:randomNumber]];
        if (rightCount > 2) {
            rightCount = 0;
            [rulerView moveScrollView];
            [self setEViewWidth: [self getEViewEnlargeValue:[rulerView getRulerScrollView]]];
            [self removeJudgeView];
        }
        else
        {
            [self addJudgeView:JudgeViewStatusRight];
        }
    }
    else
    {
        rightCount = 0;
        errorCount ++;
        if (errorCount > 2 || judgeX<MainScreenWidth/2)
        {
            [self goEyeTestResultView];
        }
        else
        {
            [self addJudgeView:JudgeViewStatusError];
        }
    }
}

- (void)goEyeTestResultView
{
    UIStoryboard *sboard = [KMTools getStoryboardInstance];
    EyeTestResultViewController *eyeTestResultViewController = [sboard instantiateViewControllerWithIdentifier:@"EyeTestResultViewController"];
    eyeTestResultViewController.value = scrollRulerValue;
    [self.navigationController pushViewController:eyeTestResultViewController animated:YES];
    
    errorCount = 0;
    judgeX = MainScreenWidth;
    [self removeJudgeView];
    [rulerView moveScrollViewToZero];
    scrollRulerValue = 3.0f;
    [self setEViewWidth: EWidth];
}

#pragma mark - 对号和X号
/** 添加对号和X号*/
- (void)addJudgeView:(JudgeViewStatus)status
{
    JudgeView *view = [[JudgeView alloc] initWithFrame:CGRectMake(judgeX-30-5,5, 30, 30) status:status removeCircle:YES];
    view.backgroundColor = [UIColor clearColor];
    view.layer.shouldRasterize = YES;
    [eyeTestView addSubview:view];
    judgeX = CGRectGetMinX(view.frame);
}

/** 删除对号和X号*/
- (void)removeJudgeView
{
    for (UIView * elem in eyeTestView.subviews) {
        if ([elem isKindOfClass:[JudgeView class]])
        {
            [elem removeFromSuperview];
        }
    }
    judgeX = MainScreenWidth;
}

#pragma mark - TXHRulerScrollView Delegate
- (void)txhRrettyRuler:(TXHRulerScrollView *)rulerScrollView {
    [self setEViewWidth: [self getEViewEnlargeValue:rulerScrollView]];
    if (scrollRulerValue!=rulerScrollView.rulerValue) {
        [eView setEViewTransform: [self getRandomNumbeWithExclude:randomNumber]];
    }
    scrollRulerValue = rulerScrollView.rulerValue;
}

#pragma mark -
-(CGFloat)getEViewEnlargeValue:(TXHRulerScrollView *)rulerScrollView
{
    scrollRulerValue = rulerScrollView.rulerValue;
    CGFloat startEviewFloat = MainScreenWidth/3;
    CGFloat rulerStartFloat = rulerScrollView.rulerStart/100;
    NSNumber *number = [NSNumber numberWithFloat:(rulerScrollView.rulerValue -rulerStartFloat)*10];
    NSUInteger base = [number integerValue] ;
    if (base >0) {
        for (int i = 0; i < base; i++) {
            startEviewFloat *=0.8;
        }
    }
    return startEviewFloat;
}

-(void)setEViewWidth:(CGFloat)width
{
    [eView setHeigthAndWidth:width center:ECenter];
}

-(NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to
{
    NSInteger value = from + (arc4random() % (to-from + 1));
    return value;
}

-(NSInteger)getRandomNumbeWithExclude:(NSInteger)exclude
{
    NSInteger random = exclude;
    while (randomNumber == random) {
        random = arc4random() % 4;
    }
    randomNumber = random;
    return random;
}


#pragma mark - 色盲
- (void)setImageValue:(NSInteger)i
{
    NSInteger random = [self getRandomNumber:0 to:[colorBlindCacheArray count]-1];
    NSString *imageName = colorBlindCacheArray[random];
    [colorBlindCacheArray removeObjectAtIndex:random];
    imageH = 147;
    CGFloat imagePointY = (CGRectGetHeight(colorBlindScroll.frame)- imageH)/2;
    CGFloat imagePointX = imageX+(MainScreenWidth-imageH)/2;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imagePointX, imagePointY, imageH, imageH)];
    imageX = CGRectGetMaxX(imageView.frame)-imageH/4;
    imageView.image = [UIImage imageNamed:imageName];
    [colorBlindScroll addSubview:imageView];
    [imageNameArray addObject:imageName];
    colorBlindScroll.contentSize = CGSizeMake(CGRectGetMaxX(imageView.frame)+(MainScreenWidth-imageH)/2, 196);
}

- (void)reloadSetImageValue
{
    imageX = 0;
    [imageNameArray removeAllObjects];
    [colorResultArray removeAllObjects];
    [colorBlindCacheArray removeAllObjects];
    colorBlindCacheArray = nil;
    colorBlindCacheArray = [[NSMutableArray alloc] initWithArray:colorBlindArray];
    for (UIView *elem  in colorBlindScroll.subviews) {
        if ([elem isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)elem;
            imageView.image = nil;
            [imageView removeFromSuperview];
        }
    }
    for (int i = 0; i <5; i ++) {
        [self setImageValue:i];
    }
}

- (BOOL)getImageNameString:(NSInteger)index
{
    NSString *string = imageNameArray[index];
    NSArray *array = [string componentsSeparatedByString:@"_"];
    NSString *imageName = array[1];
    NSString *pickerValue = @"";
    if (imageName.length > 1)
    {
        pickerValue= [NSString stringWithFormat:@"%@%@",singleDigitString,tensDigitString];
        [colorBlindPicker selectRow:0 inComponent:0 animated:YES];
        [colorBlindPicker selectRow:0 inComponent:1 animated:YES];
    }
    else
    {
        pickerValue= [NSString stringWithFormat:@"%@",singleDigitString];
        [colorBlindPicker selectRow:0 inComponent:0 animated:YES];
    }
    if ([imageName isEqualToString:pickerValue])
    {
        return YES;
    }
    return NO;
}

- (NSInteger)getImageValueLength:(NSInteger)index
{
    NSString *string = imageNameArray[index];
    NSArray *array = [string componentsSeparatedByString:@"_"];
    NSString *imageName = array[1];
    return imageName.length;
}

-(void)colorButtonClick:(UIButton *)button
{
    if (button == confirmButton&& [self getImageNameString:imageIndex])
    {
        NSNumber *result = [NSNumber numberWithInteger:1];
        [colorResultArray addObject:result];
    }
    else
    {
        NSNumber *result = [NSNumber numberWithInteger:0];
        [colorResultArray addObject:result];
    }
    if (imageIndex < 4)
    {
        [self moveColorScrollView];
        imageIndex ++;
    }
    else
    {
        imageIndex = 0;
        colorBlindScroll.contentOffset = CGPointMake(0, 0);
        UIStoryboard *sboard = [KMTools getStoryboardInstance];
        ColorBlindResultViewController *colorBlindResultViewController = [sboard instantiateViewControllerWithIdentifier:@"ColorBlindResultViewController"];
        colorBlindResultViewController.valueArray = [colorResultArray mutableCopy];
        [self.navigationController pushViewController:colorBlindResultViewController animated:YES];
        [self reloadSetImageValue];
    }

    [colorBlindPicker reloadAllComponents];

}

- (void)moveColorScrollView
{
    CGFloat offX = (((MainScreenWidth-imageH)/2 +(imageH-imageH/4))*imageIndex)+((MainScreenWidth-imageH)/2 +(imageH-imageH/4));
    [UIView animateWithDuration:.15f animations:^{
        colorBlindScroll.contentOffset = CGPointMake(offX, 0);
    }];
}

#pragma mark - 视力表
-(NSInteger)getRandomNumbeFromList:(NSInteger)exclude
{
    NSInteger random = exclude;
    while (randomNumberList == random) {
        random = arc4random() % 4;
    }
    randomNumberList = random;
    //NSLog(@"%li",random);
    return random;
}

#pragma mark - UIPickerView Delegate
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lbl = (UILabel *)view;
    if (lbl == nil) {
        lbl = [[UILabel alloc]init];
        //在这里设置字体相关属性
        lbl.font = [UIFont systemFontOfSize:20];
        lbl.textColor = AppFontColor;
        [lbl setTextAlignment: NSTextAlignmentCenter];
        [lbl setBackgroundColor:[UIColor clearColor]];
    }
    //重新加载lbl的文字内容
    lbl.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return lbl;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [self getImageValueLength:imageIndex];
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [singleDigitArray count];
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return MainScreenWidth/5;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            singleDigitString = singleDigitArray[row];
        }
            break;
        case 1:
        {
            tensDigitString = tensDigitArray[row];
        }
            break;
        default:
            break;
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *string = @"";
    switch (component) {
        case 0:
        {
            string = singleDigitArray[row];
        }
            break;
        case 1:
        {
            string = tensDigitArray[row];
        }
            break;
        default:
            break;
    }
    return string;
}

#pragma mark - 帮助页面
-(void)goHelpVC
{
    UIStoryboard *sboard = [KMTools getStoryboardInstance];
    HelpViewController *helpViewController = [sboard instantiateViewControllerWithIdentifier:@"HelpViewController"];
    helpViewController.helpType = EPageHelpTypeEyeTest;
    if (!colorBlindView.isHidden)
    {
        helpViewController.helpType = EPageHelpTypeColorTest;
    }
    [self.navigationController pushViewController:helpViewController animated:YES];

}

- (void)getFirstOpenValue
{
    NSString *firstEyeValue = [[NSUserDefaults standardUserDefaults] valueForKey:@"FirstGoEye"];
    NSString *firstColorValue = [[NSUserDefaults standardUserDefaults] valueForKey:@"FirstGoColor"];
    if ([firstEyeValue isEqualToString:@""])
    {
        onceHelp = YES;
    }
    if ([firstColorValue isEqualToString:@""])
    {
        onceColorHelp = YES;
    }
}

- (void)setFisrtOpenValue:(NSInteger)type
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    if (type == 0)
    {
        [userDefaults setValue:@"" forKey:@"FirstGoEye"];
        onceHelp = YES;
    }
    else
    {
        [userDefaults setValue:@"" forKey:@"FirstGoColor"];
        onceColorHelp = YES;
    }
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
