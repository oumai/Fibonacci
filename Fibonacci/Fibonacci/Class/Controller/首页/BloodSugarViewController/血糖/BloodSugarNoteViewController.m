//
//  BloodSugarNoteViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 2016/12/15.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "BloodSugarNoteViewController.h"

@interface BloodSugarNoteViewController ()

@end

@implementation BloodSugarNoteViewController
@synthesize noteString = _noteString;
@synthesize isPreviewType = _isPreviewType;

-(void)dealloc
{
    _delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextViewEditChanged:)
                                                name:@"UITextViewTextDidChangeNotification"
                                              object:myTextView];
    self.title = @"血糖备注";
    [self pagesLayout];
    if (!_isPreviewType) {
        [self addRightButton:@selector(saveBloodSugarNote) titile:@"保存" titleColor: AppFontColor];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pagesLayout
{
    CGFloat minY = 0;
    if (self.navigationController.navigationBar.translucent&&!self.extendedLayoutIncludesOpaqueBars) {
        minY = kStatusAndNavHeight;
    }
    WEAK_SELF(self);

    myTextView = [[UITextView alloc] init];
    myTextView.backgroundColor = [UIColor clearColor];
    myTextView.font = [UIFont fontWithName:AppFontHelvetica size: 15];
    myTextView.text = _noteString;
    myTextView.textColor = AppFontGrayColor;
    [self.view addSubview:myTextView];

    [myTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.view.mas_top).offset(15+minY);
        make.height.mas_equalTo(150);
    }];

    label = [[UILabel alloc] init];
    label.textColor = AppFontGrayColor;
    label.font = [UIFont fontWithName:AppFontHelvetica size: 15];
    label.text = @"说点什么吧";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myTextView.mas_left).offset(5);
        make.top.equalTo(myTextView.mas_top);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(100);
    }];
    if (_noteString.length > 0) {
        if (_isPreviewType) {
            myTextView.editable = NO;
        }
        label.hidden = YES;
    }
}

#pragma mark -
- (void)saveBloodSugarNote
{
    if(myTextView.text.length == 0)
    {
        [self showText:@"您没有填写备注"];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(BloodSugarNoteViewController:noteString:)]) {
        [self.delegate BloodSugarNoteViewController:self noteString:myTextView.text];
    }
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 *NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark - UITextViewDelegate
-(void)TextViewEditChanged:(NSNotification *)obj
{
    if (myTextView.text.length >0) {
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
