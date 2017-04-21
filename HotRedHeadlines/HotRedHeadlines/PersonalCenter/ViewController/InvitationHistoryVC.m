//
//  InvitationHistoryVC.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/7.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "InvitationHistoryVC.h"
#import <TYAttributedLabel.h>
#import <CYLTableViewPlaceHolder.h>
#import "XTInvitationHostoryView.h"
#import "HRUtilts.h"
#import "HRNetworkTools.h"
#import "InvitationHistoryCell.h"
#define Start_X 24.0f           // 第一个lable的X坐标
#define Start_Y 0.0f           // 第一个lable的Y坐标
#define Width_Space 5.0f        // 2个lable之间的横间距

static NSString *InvitationHistoryCellid = @"InvitationHistoryCellid";
@interface InvitationHistoryVC ()<UITableViewDelegate,UITableViewDataSource,CYLTableViewPlaceHolderDelegate,XTInvitationHostoryViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
//@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic,strong) TYAttributedLabel *titleLabel;
@property (nonatomic,strong) UILabel *lableTitle;
@end

@implementation InvitationHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"邀请记录";
    self.edgesForExtendedLayout = UIRectEdgeNone;
   
    [self initUI];
//    [self.tableView cyl_reloadData];
//    [self reloadData];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getInviteCode];
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
//获取邀请码及邀请记录
- (void)getInviteCode{
    if (self.dataArr.count>0) {
        [self.dataArr removeAllObjects];
    }
    [SVProgressHUD showWithStatus:@"Loding..."];
    __weak InvitationHistoryVC *weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@/user/tudi",RED_ENVELOP_HOST_NAME];
    NSDictionary *userInfo = UserDefaultObjectForKey(@"userInfo");
    HRUtilts *utilts = [[HRUtilts alloc]init];
    NSString *idfa = [utilts idfa];
    NSString *verify = [utilts verify];
    NSString *unionid = [userInfo objectForKey:@"unionid"];
    NSString *openid = [userInfo objectForKey:@"openid"];
    
    NSString *weixinId = unionid ?unionid:openid;
//    NSNumber *inviteCode = UserDefaultObjectForKey(USER_CODE);
//    NSString *invite_code = [NSString stringWithFormat:@"%@",inviteCode];
    NSDictionary *parameters = @{
                                 @"idfa":idfa,@"verify":verify,@"weixin_id":weixinId
                                 };
    [[HRNetworkTools sharedNetworkTools]POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSNumber *numberCode = [responseObject objectForKey:@"code"];
            NSInteger code = [numberCode integerValue];
            _lableTitle.text = [responseObject objectForKey:@"invite_ad_title"];
            if (code == 1) {
                NSNumber *inviteCode = [responseObject objectForKey:@"invite_code"];
                UserDefaultSetObjectForKey(inviteCode, USER_CODE);
                NSArray *arr = [responseObject objectForKey:@"data"];
                
                for (NSDictionary *dic in arr) {
                    [weakSelf.dataArr addObject:dic];
                }
                
            }
            
        }
        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.tableView cyl_reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}

- (void)initUI{
    
    UIImageView *topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BG_invitation"]];
    [self.view addSubview:topImageView];
    _lableTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, CGRectGetHeight(topImageView.frame))];
    _lableTitle.textColor = [UIColor whiteColor];
    _lableTitle.font = [UIFont systemFontOfSize:20];
    _lableTitle.textAlignment = NSTextAlignmentCenter;
//    _lableTitle.text = self.adTitle;
    [topImageView addSubview:_lableTitle];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topImageView.frame)+10, kScreenWidth, SCREEN_HEIGHT - CGRectGetMaxY(topImageView.frame)-10) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource  =self;
    [self.tableView registerClass:[InvitationHistoryCell class] forCellReuseIdentifier:InvitationHistoryCellid];
    [self.view addSubview:self.tableView];

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 36)];
    NSArray *arr = @[@"序号",@"昵称",@"贡献金币",@"激活状态"];
    CGFloat width = (kScreenWidth - Start_X*2 - 3*Width_Space)/4;
    for (NSInteger i=0; i<arr.count; i++) {
        NSString *str = [arr objectAtIndex:i];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(i*(width+Width_Space)+Start_X, 0, width, 36)];
        lable.layer.masksToBounds = YES;
        lable.layer.cornerRadius = 2;
        lable.backgroundColor = [UIColor colorWithHexString:@"#FF5645"];
        lable.textColor = [UIColor whiteColor];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = str;
        [backView addSubview:lable];
    }
    return backView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InvitationHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:InvitationHistoryCellid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
    [cell setcontent:dic index:indexPath.row];
    return cell;
}
- (UIView *)makePlaceHolderView{
    UIView *nodataView = [self weChatStylePlaceHolder];
    return nodataView;
}
#pragma mark -- 无数据时
- (UIView *)weChatStylePlaceHolder {
    XTInvitationHostoryView *invitationstylePlaceHolder = [[XTInvitationHostoryView alloc] initWithFrame:self.tableView.frame];
    invitationstylePlaceHolder.delegate = self;
    return invitationstylePlaceHolder;
}
- (void)emptyOverlayClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
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
