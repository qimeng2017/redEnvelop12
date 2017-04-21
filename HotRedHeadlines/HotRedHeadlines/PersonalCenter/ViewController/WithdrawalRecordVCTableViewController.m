//
//  WithdrawalRecordVCTableViewController.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/12.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "WithdrawalRecordVCTableViewController.h"
#import "WithdrawalRecordCellTableViewCell.h"
#import "HRUtilts.h"
#import "HRNetworkTools.h"
#import <MMPopLabel/MMPopLabel.h>
#import "XTWithdrawalPlaceHolder.h"
#import <CYLTableViewPlaceHolder/CYLTableViewPlaceHolder.h>
static NSString *const WithdrawalRecordCellIdentifier = @"WithdrawalRecordCellIdentifier";

#define Start_X 10.0f           // 第一个lable的X坐标
#define Start_Y 0.0f           // 第一个lable的Y坐标
#define Width_Space 5.0f        // 2个lable之间的横间距
@interface WithdrawalRecordVCTableViewController ()<WithdrawalRecordCellTableViewCellDelegate,MMPopLabelDelegate,CYLTableViewPlaceHolderDelegate,XTWithdrawalPlaceHolderDelegate>
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, strong) MMPopLabel *label;
@end

@implementation WithdrawalRecordVCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现记录";
    self.view.backgroundColor = [UIColor colorWithRed:243/255.f green:243/255.f blue:243/255.f alpha:1];
    [self initUI];
    [self prepareData];
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)initUI{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WithdrawalRecordCellTableViewCell class]) bundle:nil] forCellReuseIdentifier:WithdrawalRecordCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc]init];
    //点击 cell 显示完整信息
    [[MMPopLabel appearance] setLabelColor:RGBA(243, 243, 243, 1)];
    [[MMPopLabel appearance] setLabelTextColor:[UIColor blackColor]];
    [[MMPopLabel appearance] setLabelTextHighlightColor:[UIColor greenColor]];
    [[MMPopLabel appearance] setLabelFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]];
    [[MMPopLabel appearance] setButtonFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
    _label = [MMPopLabel popLabelWithText:
              @"姓名：顶顶顶顶顶大大大\n支付宝账号:1456886160@qq.com\n时间：2016-12-12 12:23\n金额：222222\n\n处理中。。。"];
    _label.delegate = self;
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [okButton setTitle:NSLocalizedString(@"OK, Got It!", @"Dismiss Button") forState:UIControlStateNormal];
    [_label addButton:okButton];
    [self.view addSubview:_label];


}
- (void)prepareData{
    HRUtilts *utilts = [[HRUtilts alloc]init];
    NSString *idfa = [utilts idfa];
    NSString *verify = [utilts verify];
    NSDictionary *userInfo = UserDefaultObjectForKey(@"userInfo");
    NSString *unionid = [userInfo objectForKey:@"unionid"];
    NSString *openid = [userInfo objectForKey:@"openid"];
    NSString *weixinId = unionid ?unionid:openid;
    NSDictionary *parameters = @{@"idfa":idfa,@"verify":verify,@"weixin_id":weixinId};
    NSString *url = [NSString stringWithFormat:@"%@/cash_system/alipay_record",RED_ENVELOP_HOST_NAME];
    __weak WithdrawalRecordVCTableViewController *weakSelf = self;
    [[HRNetworkTools sharedNetworkTools]GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSNumber *codeNumber = [responseObject objectForKey:@"code"];
            NSInteger code = [codeNumber integerValue];
            if (code==1) {
                NSArray *dataArr = [responseObject objectForKey:@"data"];
                for (NSDictionary *dict in dataArr) {
                    [weakSelf.dataArray addObject:dict];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView cyl_reloadData];
            
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WithdrawalRecordCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WithdrawalRecordCellIdentifier forIndexPath:indexPath];
    if (self.dataArray.count > indexPath.row) {
       cell.contentDict = [self.dataArray objectAtIndex:indexPath.row]; 
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

- (void)didSelectView:(UIView *)view content:(NSDictionary *)contentDict{
   [_label dismiss];
//    _label
    NSNumber *cash_moneyNumber = [contentDict objectForKey:@"cash_money"];
    NSString *money = [NSString stringWithFormat:@"%@元",cash_moneyNumber];
    NSNumber *timeNumber = [contentDict objectForKey:@"time"];
    NSTimeInterval time = [timeNumber doubleValue];
    NSString  *timeStr = [NSDate timeStamp:time];
    NSString *status = [contentDict objectForKey:@"status"];
    NSString *name = [contentDict objectForKey:@"full_name"];
    NSString *alipay_account = [contentDict objectForKey:@"alipay_account"];
    NSString *content = [NSString stringWithFormat:@"提现金额：%@\n时间:%@\n姓名：%@\n支付宝账号：%@\n\n处理状态：%@",money,timeStr,name,alipay_account,status];
       [_label popAtView:view content:content];
   
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_label dismiss];
}
#pragma mark - MMPopLabelDelegate
///////////////////////////////////////////////////////////////////////////////
- (UIView *)makePlaceHolderView{
    UIView *nodataView = [self weChatStylePlaceHolder];
    return nodataView;
}
#pragma mark -- 无数据时
- (UIView *)weChatStylePlaceHolder {
     XTWithdrawalPlaceHolder*invitationstylePlaceHolder = [[XTWithdrawalPlaceHolder alloc] initWithFrame:self.tableView.frame];
    invitationstylePlaceHolder.delegate = self;
    return invitationstylePlaceHolder;
}
- (void)emptyOverlayClicked:(id)sender{
    [self.tableView cyl_reloadData];
}

- (void)dismissedPopLabel:(MMPopLabel *)popLabel
{
    NSLog(@"disappeared");
}


- (void)didPressButtonForPopLabel:(MMPopLabel *)popLabel atIndex:(NSInteger)index
{
    NSLog(@"pressed %li", (long)index);
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
