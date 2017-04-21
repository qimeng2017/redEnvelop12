//
//  MeTableViewController.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "MeTableViewController.h"
#import "EditUserInfoViewController.h"
#import "UserInfoCells.h"
#import "HRDataTool.h"
#import "HelpViewController.h"
#import "WithdrawalViewController.h"
#import "HRUtilts.h"
#import "IncomeDetailsViewController.h"
#import "EnterTheInvitationCodeVC.h"
#import "WithdrawalRecordVCTableViewController.h"
static NSString *const UserInfoCellIdentifier = @"UserInfoCells";
static NSString *const NormalCellIdentifier = @"NormalCell";
static NSString *const SwitchCellIdentifier = @"SwitchCell";
static NSString *const TwoLabelCellIdentifier = @"TwoLabelCell";
static NSString *const DisclosureCellIdentifier = @"DisclosureCell";
@interface MeTableViewController ()<UINavigationControllerDelegate>
@property (nonatomic, copy)   NSString     *userName;
@property (nonatomic, weak)   UISwitch     *shakeCanChangeSkinSwitch;
@property (nonatomic, weak)   UISwitch     *imageDownLoadModeSwitch;
@property (nonatomic, assign) CGFloat       cacheSize;
@property (nonatomic, copy)   NSString     *currentSkinModel;
@property (nonatomic, strong) NSArray      *titleItems;
@property (nonatomic, strong) NSString     *all_gold;
@property (nonatomic, strong) NSArray      *incomeArr;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, copy)   NSDictionary *userInfo;
@end
CGFloat const footViewHeight = 30;
@implementation MeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
     self.navigationController.delegate = self;
    self.view.backgroundColor = RGBA(246, 246, 246, 1);
    _userInfo = UserDefaultObjectForKey(USERINFO);
    
    _titleItems = @[@{@"type":@"0",
                      @"array":@[@"用户信息"]
                      },
                      @{@"type":@"1",
                      @"array":
                        @[@{@"image":@"mine_shourumingxi",@"title":@"收入明细"},
                        @{@"image":@"mine_tikuan_jilv",@"title":@"提现记录"},
                        @{@"image":@"mine_tixian",@"title":@"兑换&提现"},
                        @{@"image":@"mine_yaoqingma",@"title":@"输入邀请码"}
                          ]
                      },
                    @{@"type":@"2",
                      @"array":
                          @[@{@"image":@"mine_yejianmoshi",@"title":@"夜间模式"},
                            @{@"image":@"mine_qingjchuhuancun",@"title":@"清除缓存"},
                            @{@"image":@"mine_bangzhu_xinxi",@"title":@"帮助信息"}
                            ]
                      }
                    ];
    
    [self caculateCacheSize];
     [self setupBasic];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
  
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark -- tabview 设置
-(void)setupBasic{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserInfoCells class]) bundle:nil] forCellReuseIdentifier:UserInfoCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NormalCellIdentifier];
    
}
#pragma  mark--获取金币及收入明细数据
- (void)reloadData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    HRUtilts *utilts = [[HRUtilts alloc]init];
    NSString *idfa = [utilts idfa];
    NSString *verify = [utilts verify];
    NSDictionary *userInfo = UserDefaultObjectForKey(USERINFO);
    NSString *unionid = [userInfo objectForKey:@"unionid"];
    NSString *openid = [userInfo objectForKey:@"openid"];
    
    NSString *weixinId = unionid ?unionid:openid;
    NSString *urlStr = [NSString stringWithFormat:@"%@/hongbao_system/mygold",RED_ENVELOP_HOST_NAME];
    __weak MeTableViewController *weakSelf = self;
    NSDictionary *parameters = @{@"idfa":idfa,@"verify":verify,@"weixin_id":weixinId};
    [manager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            weakSelf.dataDic = responseObject;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                
            });
           
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _titleItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSDictionary *rowDic = [_titleItems objectAtIndex:section];
    NSArray *rows = [rowDic objectForKey:@"array"];
    return rows.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return footViewHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return 250;
    
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] init];
    footView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, footViewHeight);
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1);
    [footView addSubview:lineView1];
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.frame = CGRectMake(0, footViewHeight - 1, [UIScreen mainScreen].bounds.size.width, 1);
    [footView addSubview:lineView2];
    
    if (section==2) {
        [lineView2 removeFromSuperview];
    }
    return footView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //cell 设置
   
   
    NSDictionary *rowDic = [_titleItems objectAtIndex:indexPath.section];
    NSArray *rows = [rowDic objectForKey:@"array"];
    if(indexPath.section == 0) {
        UserInfoCells *cell = [tableView dequeueReusableCellWithIdentifier:UserInfoCellIdentifier];
        cell.backgroundColor = [UIColor colorWithHexString:@"#df3121"];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        NSNumber *goldAllNum = [_dataDic objectForKey:@"all_gold"];
        NSString *gold_all = [NSString stringWithFormat:@"%@",goldAllNum];
        [cell setUserInfo:_userInfo gold:gold_all money:nil];
//        [cell setAvatarImage:image Name:name Signature:content];
        
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalCellIdentifier];
        
        cell.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.section == 1){
            
            NSDictionary *dic = [rows objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:[dic objectForKey:@"image"]];
            cell.textLabel.text = [dic objectForKey:@"title"];
            cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            NSDictionary *dict = [rows objectAtIndex:indexPath.row];
            cell.textLabel.text = [dict objectForKey:@"title"];
            cell.imageView.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
            cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
            if (indexPath.row==0) {
        
                UISwitch *theSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth - 60, 6, 50, cell.frame.size.height)];
                theSwitch.on = [self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]?YES:NO;
                self.changeSkinSwitch = theSwitch;
                [theSwitch addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = theSwitch;
            }else if(indexPath.row == 1){
//                UISwitch *theSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth - 60, 6, 50, cell.frame.size.height)];
//                self.shakeCanChangeSkinSwitch = theSwitch;
//                cell.accessoryView = theSwitch;
//                BOOL status = [[NSUserDefaults standardUserDefaults] boolForKey:IsShakeCanChangeSkinKey];
//                theSwitch.on = status;
//                [theSwitch addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView.hidden = NO;
                UILabel *lable = [[UILabel alloc]init];
                lable.text = [NSString stringWithFormat:@"%.2fM",_cacheSize];
                lable.dk_textColorPicker = DKColorPickerWithKey(TEXT);
                [lable sizeToFit];
                cell.accessoryView = lable;
            }else if(indexPath.row==2){
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        
        return cell;
    }
    
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //编辑用户信息
//        [self.navigationController pushViewController:[[EditUserInfoViewController alloc] init] animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row ==1) {
        //清理缓存
        [self clearFile];
        
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
//        收入明细
        IncomeDetailsViewController *income = [[IncomeDetailsViewController alloc]init];
        [self pushViewsViewController:income animated:YES];
    }
    else if (indexPath.section==1&&indexPath.row==1){
//       提现记录
        WithdrawalRecordVCTableViewController *wrVC = [[WithdrawalRecordVCTableViewController alloc]init];
        [self pushViewsViewController:wrVC animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 2) {
//        兑换&提现
        WithdrawalViewController *with = [[WithdrawalViewController alloc]init];
        NSNumber *goldAllNum = [_dataDic objectForKey:@"all_gold"];
        NSString *gold_all = [NSString stringWithFormat:@"%@",goldAllNum];
        with.cash_gold = gold_all;
        [self pushViewsViewController:with animated:YES];
    }
    else if (indexPath.section==1&&indexPath.row==3){
//        输入邀请码
        EnterTheInvitationCodeVC *eneter = [[EnterTheInvitationCodeVC alloc]init];
        [self pushViewsViewController:eneter animated:YES];
    }
    else if (indexPath.section== 2&&indexPath.row ==2){
//        帮助
        HelpViewController *help = [[HelpViewController alloc]init];
        [self pushViewsViewController:help animated:YES];
    }
}
- (void)pushViewsViewController:(UIViewController *)viewController animated:(BOOL)flag{
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    //    [self presentViewController:viewController animated:YES completion:nil];
}
#pragma mark -- 夜间模式切换
-(void)switchDidChange:(UISwitch *)theSwitch {
    if (theSwitch == self.changeSkinSwitch) {
        if (theSwitch.on == YES) {//切换至夜间模式
            self.dk_manager.themeVersion = DKThemeVersionNight;
            self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
            
        } else {
            self.dk_manager.themeVersion = DKThemeVersionNormal;
            self.tabBarController.tabBar.barTintColor = [UIColor whiteColor];
            
        }
        
    } else if (theSwitch == self.shakeCanChangeSkinSwitch) {//摇一摇夜间模式
        BOOL status = self.shakeCanChangeSkinSwitch.on;
        [[NSUserDefaults standardUserDefaults] setObject:@(status) forKey:IsShakeCanChangeSkinKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if([self.delegate respondsToSelector:@selector(shakeCanChangeSkin:)]) {
            [self.delegate shakeCanChangeSkin:status];
        }
    }
}
#pragma mark --缓存
-(void)caculateCacheSize {
    float imageCache = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
    self.cacheSize = imageCache;
}
#pragma mark --清理缓存
- (void)clearFile{
    [SVProgressHUD showWithStatus:@"清理中..."];
    [HRDataTool deletePartOfCacheInSqlite];
    [[SDImageCache sharedImageCache] clearDisk];

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.cacheSize = 0;
        NSIndexPath *index=[NSIndexPath indexPathForRow:1 inSection:2];//刷新
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
        [SVProgressHUD dismiss];
        // Do something...
        
    });
    
}

-(void)didReceiveMemoryWarning {
    [[SDImageCache sharedImageCache] clearDisk];
    
}
#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}
@end
