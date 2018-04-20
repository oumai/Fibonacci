//
//  FeedbackViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 16/10/9.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "FeedbackViewController.h"
#import "BATUploadImageModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
@interface FeedbackViewController ()

@end

@implementation FeedbackViewController
- (void)dealloc
{
    [imageUrlArray removeAllObjects];
    [imagePicArray removeAllObjects];
    [imageAssetsArray removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self setPagesView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TextViewEditChanged:)
                                                name:@"UITextViewTextDidChangeNotification"
                                              object:myTextView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self stautsBarHidde];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (!Pickering) {
        [self removeUpdataViewImage];
    }
}

- (void)setPagesView
{
    if (once) {
        return;
    }
    once = YES;
    imagePicArray = [NSMutableArray new];
    imageUrlArray = [NSMutableArray new];
    imageAssetsArray = [NSMutableArray new];
    CGFloat buttonH = 40;
    CGFloat labelH = 35;
    CGFloat minY = 0;
    if (self.navigationController.navigationBar.translucent&&!self.extendedLayoutIncludesOpaqueBars) {
        minY = kStatusAndNavHeight;
    }
    
    GBLayer = [CALayer layer];
    GBLayer.frame = CGRectMake(10, 10+minY, MainScreenWidth-20, (MainScreenHeight-minY-10)/2);
    GBLayer.backgroundColor = RGBA(245, 246, 247, 0.1).CGColor;
    [self.view.layer addSublayer:GBLayer];
    
    UIFont *font = [UIFont fontWithName:AppFontHelvetica size: 15];
    myTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10+minY, MainScreenWidth-20, CGRectGetHeight(GBLayer.frame)/2)];
    myTextView.backgroundColor = [UIColor clearColor];
    myTextView.font = font;
    myTextView.textColor = AppFontGrayColor;
    [self.view addSubview:myTextView];
    
    myLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth-100, CGRectGetMaxY(myTextView.frame), 60, labelH)];
    myLabel.font = font;
    myLabel.textAlignment = NSTextAlignmentLeft;
    NSString * str = [NSString stringWithFormat:@"%li/200",(long)myTextView.text.length];
    [self setLabelAttributedText:str];
    [self.view addSubview:myLabel];
    
    [self setUpdateImageView:NO];
    
    myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = CGRectMake( MainScreenWidth/3, CGRectGetMaxY(GBLayer.frame)+20, MainScreenWidth/3, buttonH);
    [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [myButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [myButton setTitle: @"提交" forState:UIControlStateNormal];
    [myButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"btn"];
    [myButton setBackgroundImage: image forState:UIControlStateNormal];
    [self.view addSubview:myButton];
}

-(void)setUpdateImageView:(BOOL)animate
{
    if (updateImageView == nil)
    {
        updateImageView = [[UIView alloc] init];
//        updateImageView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:updateImageView];
    }
    else
    {
        [self removeUpdataViewImage];
    }
    CGFloat imageWidth = 70;
    CGFloat imageY = 0;
    CGFloat viewY = CGRectGetMaxY(updateImageView.frame);
    CGFloat imageX = 0;
    NSUInteger arrayCount = [imageAssetsArray count];
    if (arrayCount<9)
    {
        arrayCount++;
    }
    for (int i = 0; i < arrayCount; i++)
    {
        imageX = (MainScreenWidth-20-imageWidth*3)/3;
        imageX = imageX/2+(i%3)*imageX+((i%3)*imageWidth);
        imageY = 10+(i/3)*(imageWidth + 10);
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageWidth, imageWidth)];
        imageView.tag = 100+i;
        imageView.userInteractionEnabled = YES;
        [updateImageView addSubview:imageView];
        if (i == arrayCount-1&& [imageAssetsArray count]!=9)
        {
            imageView.image = [UIImage imageNamed:@"Add-pictures"];
            if (arrayCount==1)
            {
                if (titleLabel == nil)
                {
                    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+20, imageY, imageWidth, 30)];
                    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+20, CGRectGetMaxY(titleLabel.frame), imageWidth*3, 30)];
                    titleLabel.text = @"添加照片";
                    titleLabel.textColor = AppFontColor;
                    titleLabel.font = [UIFont fontWithName:AppFontHelvetica size:15];
                    textLabel.font = [UIFont fontWithName:AppFontHelvetica size:13];
                    textLabel.text = @"具体反馈页面和其他图片";
                    textLabel.textColor = AppFontGrayColor;
                    [updateImageView addSubview:titleLabel];
                    [updateImageView addSubview:textLabel];
                }
                titleLabel.hidden = NO;
                textLabel.hidden = NO;
            }
            else
            {
                titleLabel.hidden = YES;
                textLabel.hidden = YES;
            }
        }
        else
        {
            if (i>0) {
                titleLabel.hidden = YES;
                textLabel.hidden = YES;
            }
            imageView.image = imagePicArray[i];
        }
        UITapGestureRecognizer *addGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImageTap:)];
        [imageView addGestureRecognizer:addGesture];
        viewY = CGRectGetMaxY(imageView.frame);
    }
    imageX = (MainScreenWidth-20-imageWidth*3)/3;
    updateImageView.frame = CGRectMake(10, CGRectGetMaxY(myLabel.frame), MainScreenWidth-20, viewY+imageX/2);
    CGRect layeFrame = GBLayer.frame;
    layeFrame.size.height = CGRectGetMaxY(updateImageView.frame)-20-kStatusAndNavHeight;
    
    if (animate) {
        [UIView animateWithDuration:0.35f animations:^{
            GBLayer.frame = layeFrame;
            CGRect buttonFrame = myButton.frame;
            buttonFrame.origin.y = CGRectGetMaxY(GBLayer.frame)+20;
            myButton.frame = buttonFrame;
        } completion:^(BOOL finished) {
            CGRect buttonFrame = myButton.frame;
            buttonFrame.origin.y = CGRectGetMaxY(GBLayer.frame)+20;
            myButton.frame = buttonFrame;
        }];
    }
    else
    {
        GBLayer.frame = layeFrame;
    }
}

- (void)removeUpdataViewImage
{
    for (UIView *elem in updateImageView.subviews)
    {
        if ([elem isKindOfClass:[UIImageView class]])
        {
            UIImageView *imageView = (UIImageView *)elem;
            imageView.image = nil;
            [imageView removeFromSuperview];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextView
-(void)TextViewEditChanged:(NSNotification *)obj
{
    NSUInteger kLength = 200;
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
    NSString *str = [NSString stringWithFormat:@"%ld/200",(unsigned long)textView.text.length];
    [self setLabelAttributedText:str];
}

-(void)rightButtonAction:(UIButton *)sender
{
    [self.view endEditing: YES];
    if (myTextView.text.length == 0) {
        [self showText:@"请输入意见"];
        return;
    }
    [self updataRequestFeedbackImages];
}

#pragma mark - 手势
- (void)addImageTap:(UITapGestureRecognizer *)tap
{
    UITapGestureRecognizer *tempTap = (UITapGestureRecognizer *)tap;
    UIImageView *view = (UIImageView *)tempTap.view;
    if (view.tag == 100+[imagePicArray count])
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        
        WEAK_SELF(self);
        //        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //            STRONG_SELF(self);
        //            [self getPhotosFromCamera];
        //        }];
        
        UIAlertAction *photoGalleryAction = [UIAlertAction actionWithTitle:@"上传图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF(self);
            [self getPhotosFromLocal];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        //        [alertController addAction:cameraAction];
        [alertController addAction:photoGalleryAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"操作" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        
        WEAK_SELF(self);
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF(self);
            [self deleteImage:view.tag-100];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:deleteAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)deleteImage:(NSInteger)index
{
    [imagePicArray removeObjectAtIndex:index];
    [imageAssetsArray removeObjectAtIndex:index];
    [self setUpdateImageView:YES];
}

#pragma mark - 从本地相册获取图片
- (void)getPhotosFromLocal
{
    Pickering = YES;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto = NO;
    imagePickerVc.selectedAssets = imageAssetsArray; // 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    //    imagePickerVc.showSelectBtn = NO;
    [self presentViewController:imagePickerVc animated:YES completion:^{
        [self stautsBarHidde];
    }];
}

- (void)stautsBarHidde
{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 *NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    });
}

#pragma mark - TZImagePickerController
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    picker.delegate = nil;
    imagePicArray = [NSMutableArray arrayWithArray:photos];
    imageAssetsArray = [NSMutableArray arrayWithArray:assets];
    [self setUpdateImageView:YES];
}

#pragma mark - NET

- (void)updataRequestFeedbackImages
{
    [HTTPTool requestUploadImageConstructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //        UIImage * compressImg  = [KMTools compressImageWithImage:image ScalePercent:0.1];
        //在此之前就已经压缩
        for (int i = 0; i < [imagePicArray count]; i++) {
            UIImage *image = [imagePicArray objectAtIndex:i];
            UIImage *scaleImage  = [KMTools compressImageWithImage:image ScalePercent:0.001];
            NSData *imageData = UIImagePNGRepresentation(scaleImage);
            [formData appendPartWithFileData:imageData
                                        name:[NSString stringWithFormat:@"dynamic_picture%d",i]
                                    fileName:[NSString stringWithFormat:@"dynamic_picture%d.jpg",i]
                                    mimeType:@"multipart/form-data"];
        }
    } progress:^(NSProgress *uploadProgress) {
        [self showProgres:uploadProgress.fractionCompleted];
    } success:^(NSArray *imageArray) {
        [self dismissProgress];
        NSLog(@"image URL %@",imageArray);
        NSMutableArray *imageModelArray = [BATImage mj_objectArrayWithKeyValuesArray:imageArray];
        [imageUrlArray addObjectsFromArray:imageModelArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self feedBackRequest];
        });
    } failure:^(NSError *error) {
        [self showText:ErrorText];
        
    }];
}

- (void) feedBackRequest {
    [self showText:@"请稍后"];
    NSMutableArray *imgs = [[NSMutableArray alloc] init];
    for (BATImage *batImage in imageUrlArray) {
        [imgs addObject:batImage.url];
    }
    [HTTPTool requestWithURLString:@"/api/FeedBack/InsertFeedBack"
                        parameters:@{
                                     @"OpinionsContent":myTextView.text,
                                     @"MenuName":@"",
                                     @"Source":@"iOS",
                                     @"Title":@"",
                                     @"MenuId":@"2",
                                     @"Version":[KMTools getVersionNumber],
                                     @"PictureUrl":[imgs componentsJoinedByString:@","]
                                     }
                        showStatus:YES
                              type:kPOST
                           success:^(id responseObject) {
                               [self showSuccessWithText:responseObject[@"ResultMessage"]];
                               NSString *code = [responseObject objectForKey:@"ResultCode"];
                               if ([code integerValue] == 0)
                               {
                                   [self backLastPages];
                               }
                               else
                               {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self dismissProgress];
                                   });
                               }
                           } failure:^(NSError *error) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [self dismissProgress];
                               });
                           }];
}

- (void)backLastPages
{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 *NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self dismissProgress];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

-(void)setLabelAttributedText:(NSString *)text
{
    NSInteger redLength = text.length-4;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentRight;
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:AppFontYellowColor range:NSMakeRange(0, redLength)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:AppFontColor range:NSMakeRange(redLength, text.length - redLength)];
    myLabel.attributedText = attributedString;
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
