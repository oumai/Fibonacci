//
//  SettingViewController.m
//  Fibonacci
//
//  Created by woaiqiu947 on 16/10/9.
//  Copyright © 2016年 woaiqiu947. All rights reserved.
//

#import "SettingViewController.h"
#import "ForgetAndChangeViewController.h"
#import "FeedbackViewController.h"
@interface SettingViewController ()

@end

static CGFloat cellRowHeight = 50;

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
//    titleArray = @[@"修改密码", @"清理缓存"];
    titleArray = @[@"修改密码", @"当前版本", @"清理缓存",@"意见反馈"];
//    titleArray = @[@"修改密码", @"清理缓存"];
    cacheSize = [self filePath];
    myTableView.rowHeight = cellRowHeight;
    myTableView.backgroundView = [[UIView alloc] init];
    myTableView.backgroundView.backgroundColor = [UIColor clearColor];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorColor = RGB(41, 41, 88);
    [self addTableViewFooterView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self dismissProgress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTableViewFooterView
{
    CGFloat buttonH = 40;

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, buttonH)];
    myTableView.tableFooterView = footerView;
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(MainScreenWidth/3, 0, MainScreenWidth/3, buttonH);
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [shareButton setTitle: @"退出登录" forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"btn"];
    [shareButton setBackgroundImage: image forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(logoutAccountAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:shareButton];
    
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
        cell.textLabel.textColor = AppFontColor;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth-150, 0, 125, cellRowHeight)];
        label.font = [UIFont fontWithName:@"Helvetica-Light" size: 15];
        label.tag = 101;
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = AppFontGrayColor;
        [cell.contentView addSubview:label];
    }
    cell.textLabel.text = titleArray[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size: 15];
    UILabel *label = [cell.contentView viewWithTag:101];
    switch (indexPath.row) {
        case 0:
        case 3:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 1:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            label.text = [NSString stringWithFormat:@"%@",[KMTools getVersionNumber]];
//            if (cacheSize >0.1) {
//                label.text = [NSString stringWithFormat:@"%.2fM",cacheSize];
//            }
//            else
//            {
//                label.text = @"";
//            }
        }
            break;
        case 2:
        {
            if (cacheSize >0.1) {
                label.text = [NSString stringWithFormat:@"%.2fM",cacheSize];
            }
            else
            {
                label.text = @"";
            }
        }
            break;
            
        default:
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            UIStoryboard *sboard = [KMTools getStoryboardInstance];
            ForgetAndChangeViewController *forgetAndChangeViewController = [sboard instantiateViewControllerWithIdentifier:@"ForgetAndChangeViewController"];
            forgetAndChangeViewController.type = EViewChangeType;
            [self.navigationController pushViewController:forgetAndChangeViewController animated:YES];
        }
            break;
        case 1:
        {
//            [self removeCacheSDirectory];
        }
            break;
        case 2:
        {
            [self removeCacheSDirectory];
        }
            break;
        case 3:{
            UIStoryboard *sboard = [KMTools getStoryboardInstance];
            FeedbackViewController *heartChartViewController = [sboard instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
            [self.navigationController pushViewController:heartChartViewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)logoutAccountAction:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否退出当前账号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
    [alertView show];
}

#pragma mark -
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        if (buttonIndex == 1)
        {
            [self deleteAccountData];
        }
    }
}

#pragma mark -
- (void)removeCacheSDirectory
{
    dispatch_async (dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        //
        NSString  *cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory, NSUserDomainMask ,YES) objectAtIndex: 0 ];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
//        NSLog ( @"files :%li" ,[files count]);
        for ( NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath  stringByAppendingPathComponent :p];
            if ([[ NSFileManager defaultManager ]  fileExistsAtPath :path]) {
                [[ NSFileManager defaultManager ]  removeItemAtPath :path  error :&error];
            }
        }
        [ self performSelectorOnMainThread : @selector (clearCacheSuccess)  withObject : nil waitUntilDone : YES ];
    });
}

-(void)clearCacheSuccess
{
    [self showSuccessWithText:@"缓存已清除"];
    cacheSize = [self filePath];
    [myTableView reloadData];
}

- (long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath:filePath error: nil]fileSize];
    }
    return 0;
}

-(float)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager * manager = [ NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
}

- (float)filePath
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    return [ self folderSizeAtPath :cachPath];
}

- (void)deleteAccountData
{
    SET_LOGIN_STATION(NO);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@"" forKey: KEY_LOGIN_TOKEN];
    [userDefaults removeObjectForKey: KEY_INSULINNAME_TARRAY];
    [userDefaults removeObjectForKey: KEY_REMINDER_ARRAY];
    [userDefaults removeObjectForKey: KEY_PHYSICALRECORD_DIC];
    [userDefaults synchronize];
    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Person.data"] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/UserLogin.data"] error:nil];
    [[KMDataManager sharedDatabaseInstance] changeDatabaseName];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATA_LOGIN_STATION" object:nil];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 *NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
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
