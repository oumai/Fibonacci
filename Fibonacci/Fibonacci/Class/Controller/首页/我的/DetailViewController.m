//
//  DetailViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 16/10/9.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "DetailViewController.h"
#import "BATUploadImageModel.h"
#import "BATPerson.h"
#import "HTTPTool+HeartDataRequst.h"
@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize defaultImage = _defaultImage;

static CGFloat AvatarCellWidth = 55;
static CGFloat OtherCellWidth = 45;

static CGFloat AvatarViewWidth = 40;
static CGFloat OtherLabelWidth = 45;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self initPagesViewAndData];
    [self requestGetPersonInfoListPhysicalRecoid:NO];
    if(IS_IPHONE_X)
    {
        myTablewView.estimatedSectionHeaderHeight = 0;
        myTablewView.estimatedSectionFooterHeight = 0;
    }
//    myTablewView.rowHeight = 50;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self stautsBarHidde];
}

- (void)initPagesViewAndData
{
    titleArray = @[@"头像", @"昵称", @"性别", @"出生日期", @"手机号码", @"身份证号"];
    CGFloat minY = kStatusAndNavHeight;
    if (self.navigationController.navigationBar.translucent&&!self.extendedLayoutIncludesOpaqueBars) {
        minY = 0;
    }
    sexPickerView = [[BATSexPickerView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - minY, MainScreenWidth, 256)];
    sexPickerView.delegate = self;
    [self.view addSubview: sexPickerView];
    
    birthDayPickerView = [[BATBirthDayPickerView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - minY, MainScreenWidth, 256)];
    birthDayPickerView.delegate = self;
    [self.view addSubview: birthDayPickerView];
    
    myTablewView.backgroundView = [[UIView alloc] init];
    myTablewView.backgroundView.backgroundColor = [UIColor clearColor];
    myTablewView.backgroundColor = [UIColor clearColor];
    myTablewView.separatorColor = RGB(41, 41, 88);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
        switch (indexPath.row) {
            case 0:
            {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth-20-AvatarViewWidth, 5, AvatarViewWidth, AvatarViewWidth)];
                imageView.tag = 100;
                imageView.layer.cornerRadius = AvatarViewWidth/2;
                imageView.backgroundColor = [UIColor whiteColor];
                imageView.clipsToBounds = YES;
                imageView.image = _defaultImage;
                [cell.contentView addSubview:imageView];
            }
                break;
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth-180, 0, 155, OtherLabelWidth)];
                label.font = [UIFont fontWithName:@"Helvetica-Light" size: 15];
                label.tag = 101;
                label.textAlignment = NSTextAlignmentRight;
                label.textColor = AppFontGrayColor;
                [cell.contentView addSubview:label];
            }
                break;
                
                
            default:
                break;
        }
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size: 15];
        cell.textLabel.textColor = AppFontColor;
    }
    cell.textLabel.text = titleArray[indexPath.row];
    UILabel *label = [cell.contentView viewWithTag: 101];
    UIImageView *imageBG = [cell.contentView viewWithTag: 100];
    UITextField *textField = [cell.contentView viewWithTag: 102];
    UITextField *idNumberField = [cell.contentView viewWithTag: 103];
    [textField removeFromSuperview];
    textField = nil;
    [idNumberField removeFromSuperview];
    idNumberField = nil;
    label.hidden = NO;
    switch (indexPath.row) {
        case 0:
        {
            [imageBG sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", person.Data.PhotoPath]] placeholderImage:_defaultImage];
        }
            break;
        case 1:
        {
            label.text = person.Data.UserName;

        }
            break;
        case 2:
        {
            if ([person.Data.Sex isEqualToString:@"1"]) {
                label.text = @"男性";
            }
            else {
                label.text = @"女性";
            }
        }
            break;
        case 3:
        {
            NSString *ageStr = [person.Data.Birthdays substringToIndex:10];
            label.text = ageStr;
        }
            break;
        case 4:
        {
            label.text = person.Data.PhoneNumber;
        }
            break;
        case 5:
        {
            label.text = person.Data.IDNumber;
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row) {
        return OtherCellWidth;
    }
    return AvatarCellWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            [self.view endEditing:YES];
            [sexPickerView hide];
            [birthDayPickerView hide];
            //头像
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"头像" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self getPhotosFromCamera];
            }];
            
            UIAlertAction *photoGalleryAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self getPhotosFromLocal];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:cameraAction];
            [alertController addAction:photoGalleryAction];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
        case 1:
        {
            [sexPickerView hide];
            [birthDayPickerView hide];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UILabel *label = [cell.contentView viewWithTag: 101];
            label.hidden = YES;
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(MainScreenWidth-150, 0, 125, 45)];
            textField.placeholder = @"请输入昵称(1-8位)";
            textField.tag = 102;
            textField.font = [UIFont fontWithName:@"Helvetica-Light" size: 15];
            textField.delegate = self;
            textField.textColor = AppFontGrayColor;
            [cell.contentView addSubview:textField];
            [textField becomeFirstResponder];
        }
            break;
        case 2:
        {
            [self.view endEditing:YES];
            [sexPickerView show];
            [birthDayPickerView hide];
        }
            break;
        case 3:
        {
            [self.view endEditing:YES];
            [birthDayPickerView show];
            [sexPickerView hide];
        }
            break;
        case 4:
        {
            [self.view endEditing:YES];
            [birthDayPickerView hide];
            [sexPickerView hide];
        }
            break;
        case 5:
        {
            [birthDayPickerView hide];
            [sexPickerView hide];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UILabel *label = [cell.contentView viewWithTag: 101];
            label.hidden = YES;
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(MainScreenWidth-150, 0, 125, 45)];
            textField.placeholder = @"请输入身份证号码";
            textField.tag = 103;
            textField.font = [UIFont fontWithName:@"Helvetica-Light" size: 15];
            textField.delegate = self;
            textField.textColor = AppFontGrayColor;
            [cell.contentView addSubview:textField];
            [textField becomeFirstResponder];
        }
            break;
        default:
            break;
    }
}

#pragma mark - BATSexPickerViewDelegate
- (void)BATSexPickerView:(BATSexPickerView *)sexPickerView didSelectRow:(NSInteger)row titleForRow:(NSString *)title
{
    person.Data.Sex = [NSString stringWithFormat:@"%ld",(long)row];
    
   [self dealWithUploadParamas];
}

- (void)BATBirthDayPickerView:(BATBirthDayPickerView *)birthDayPickerView didSelectDateString:(NSString *)dateString
{
    person.Data.Birthdays = dateString;
    [self dealWithUploadParamas];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [[info objectForKey:UIImagePickerControllerEditedImage] copy];
    
    [self requestChangePersonHeadIcon:image];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self stautsBarHidde];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [self stautsBarHidde];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    switch (textField.tag) {
        case 102:
        {
            if (textField.text.length < 1||textField.text.length > 8) {
                [myTablewView reloadData];
                [self showText:@"昵称长度为1-8"];
            }
            else
            {
                person.Data.UserName = textField.text;
                [self dealWithUploadParamas];
            }
        }
            break;
        case 103:
        {
            if (![KMTools judgeIdentityStringValid:textField.text]) {
                [myTablewView reloadData];
                [self showText:@"请输入正确的身份证号码"];
            }
            else
            {
                person.Data.IDNumber = textField.text;
                [self dealWithUploadParamas];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 从本地相册获取图片
- (void)getPhotosFromLocal
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //只可以选择图片，不能选择视频
    NSArray *temp_MediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage,nil];
    picker.mediaTypes = temp_MediaTypes;
    [self presentViewController:picker animated:YES completion:^{
        [self stautsBarHidde];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }];
    
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请在iPhone的“设置->隐私->相机”选项中，允许访问您的相机。"  message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
}

#pragma mark - 拍照
- (void)getPhotosFromCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //        //只可以选择图片，不能选择视频
        NSArray *temp_MediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage,nil];
        picker.mediaTypes = temp_MediaTypes;
        picker.allowsEditing = YES;
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:^{
            [self stautsBarHidde];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }];
    }
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input)
    {
       // NSLog(@"AAA%@", [error localizedDescription]);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请在iPhone的“设置->隐私->相机”选项中，允许访问您的相机。" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return ;
    }
}

#pragma mark - 组装上传参数
- (void)dealWithUploadParamas
{
    [myTablewView reloadData];
    NSDictionary * dic = @{@"PhotoPath":person.Data.PhotoPath == nil?@"0":person.Data.PhotoPath,
                           @"UserName":person.Data.UserName == nil?@"0":person.Data.UserName,
                           @"Sex":person.Data.Sex == nil?@"0":person.Data.Sex,
                           @"Birthdays":person.Data.Birthdays == nil?@"1970-01-01":[person.Data.Birthdays substringToIndex:10],
                           @"PatientID":[NSNumber numberWithInteger:person.Data.PatientID],
                           @"PhoneNumber":person.Data.PhoneNumber == nil?@"":person.Data.PhoneNumber,
                           @"IDNumber":person.Data.IDNumber == nil?@"0":person.Data.IDNumber,
//                           @"Signature":person.Data.Signature == nil?@"这家伙很懒，什么都没留下":person.Data.Signature,
//                           @"GeneticDisease":person.Data.GeneticDisease == nil?@"无家族遗传病":person.Data.GeneticDisease,
//                           @"Allergies":person.Data.Allergies == nil?@"无过敏史":person.Data.Allergies,
//                           @"Anamnese":person.Data.Anamnese == nil?@"无已往病史":person.Data.Anamnese
                           };
    
    [self requestChangePersonAllInfo:dic];
}

#pragma mark - NET
- (void)requestChangePersonAllInfo:(NSDictionary *)dictParamas
{
    DDLogDebug(@"dictParamas ==== %@",dictParamas);
    [HTTPTool requestWithURLString:@"/api/Patient/Info" parameters:dictParamas showStatus:YES type:kPOST success:^(id responseObject) {
        [self requestGetPersonInfoListPhysicalRecoid:YES];
    } failure:^(NSError *error) {
        [self requestGetPersonInfoListPhysicalRecoid:NO];
    }];
}

#pragma mark - 获取个人信息请求
- (void)requestGetPersonInfoListPhysicalRecoid:(BOOL)get
{
    [HTTPTool requestWithURLString:@"/api/Patient/Info" parameters:nil showStatus:NO type:kGET success:^(id responseObject) {
        person = [BATPerson mj_objectWithKeyValues:responseObject];
        NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"];
        [NSKeyedArchiver archiveRootObject:person toFile:file];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATA_LOGIN_STATION" object:nil];
        [myTablewView reloadData];
        if (get) {
            [HTTPTool getPhysicalRecoidCompletion:^(BOOL success,NSMutableDictionary * dict, NSError *error){
            }];
        }
    } failure:^(NSError *error) {
    }];
}

#pragma mark - 更新头像
- (void)requestChangePersonHeadIcon:(UIImage *)img
{
    [HTTPTool requestUploadImageConstructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage * compressImg  = [KMTools compressImageWithImage:img ScalePercent:0.01];
        NSData *imageData = UIImagePNGRepresentation(compressImg);
        [formData appendPartWithFileData:imageData
                                    name:[NSString stringWithFormat:@"person_headicon"]
                                fileName:[NSString stringWithFormat:@"person_headicon.jpg"]
                                mimeType:@"multipart/form-data"];
    } progress:^(NSProgress *uploadProgress) {
        [self showProgres:uploadProgress.fractionCompleted];
        
    } success:^(NSArray *imageArray) {
        [self showSuccessWithText:@"上传头像成功"];
        
        NSMutableArray *imageModelArray = [BATImage mj_objectArrayWithKeyValuesArray:imageArray];
        BATImage *imageModel = [imageModelArray firstObject];
        person.Data.PhotoPath = imageModel.url;
        [self dealWithUploadParamas];
        
    } failure:^(NSError *error) {
        [self showText:ErrorText];
        
    }];
}

//计算日期str与现在相差多少年
- (NSString *)ageFromBirthStr:(NSString *)birth
{
    NSString *ageStr = @"";

    if (birth.length < 8) {
        return ageStr;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:birth];
    
    //用来得到详细的时差
#if __IPHONE_8_0
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
#else
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
#endif
    NSDateComponents *date = [calendar components:unitFlags fromDate:birthDay toDate:nowDate options:0];
    
    if([date year] >0)
    {
        ageStr = [NSString stringWithFormat:@"%li",[date year]];
    }
    return ageStr;
}

- (NSString *)dateStringFormat:(NSString *)str
{
    NSString *newStr = @"";
    if (str.length < 8) {
        return newStr;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *strDate = [dateFormatter dateFromString:str];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    newStr = [dateFormatter stringFromDate:strDate];
    return newStr;
}
@end
