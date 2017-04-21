//
//  IncomeDetailsViewController.m
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/24.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "IncomeDetailsViewController.h"
#import "NSDate+Formatter.h"
#import "IncomeDetailTableViewCell.h"
#import "HRUtilts.h"
#import "TXScrollLabelView.h"
#import "HRNetworkTools.h"
static NSString *const IncomeCellIdentifier = @"IncomeCellIdentifier";
@interface IncomeDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *incomeTableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (weak, nonatomic) TXScrollLabelView *scrollLabelView;
@end

@implementation IncomeDetailsViewController
- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"收入明细";
     self.view.backgroundColor = RGBA(246, 246, 246, 1);

    
    [self initUI];
    ADD_BACK(backAction);
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self prepareData];
    [self ios_ad_manage];
}

- (void)ios_ad_manage{
    HRUtilts *utilts = [[HRUtilts alloc]init];
    NSString *idfa = [utilts idfa];
    NSString *verify = [utilts verify];
    NSDictionary *userInfo = UserDefaultObjectForKey(@"userInfo");
    NSString *unionid = [userInfo objectForKey:@"unionid"];
    NSString *openid = [userInfo objectForKey:@"openid"];
    
    NSString *weixinId = unionid ?unionid:openid;
    NSString *urlStr = [NSString stringWithFormat:@"%@/ios_ad_manage",RED_ENVELOP_HOST_NAME];
    NSDictionary *parameters = @{@"idfa":idfa,
                                 @"verify":verify,
                                 @"weixin_id":weixinId,
                                 @"appid":appid,
                                 @"stype":stype
                                 };
    [[HRNetworkTools sharedNetworkTools]GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSNumber *codelNum = [responseObject objectForKey:@"code"];
        NSInteger code = [codelNum integerValue];
        if (code == 2) {
            NSString *message = [responseObject objectForKey:@"message"];
           
           dispatch_async(dispatch_get_main_queue(), ^{
               [self scrollerLable:message];
           });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)scrollerLable:(NSString *)message{
    /** Step2: 创建 ScrollLabelView */
    TXScrollLabelView *scrollLabelView = [TXScrollLabelView scrollWithTitle:message type:TXScrollLabelViewTypeFlipRepeat velocity:2 options:UIViewAnimationOptionCurveEaseInOut];
    /** Step4: 布局(Required) */
    scrollLabelView.frame = CGRectMake(0, 0, kScreenWidth, 30);
    scrollLabelView.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollLabelView];
    self.incomeTableView.frame = CGRectMake(0, 30, kScreenWidth, SCREEN_HEIGHT -30);
    [scrollLabelView beginScrolling];
    
}
- (void)prepareData{
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    HRUtilts *utilts = [[HRUtilts alloc]init];
    NSString *idfa = [utilts idfa];
    NSString *verify = [utilts verify];
    NSDictionary *userInfo = UserDefaultObjectForKey(USERINFO);
    NSString *unionid = [userInfo objectForKey:@"unionid"];
    NSString *openid = [userInfo objectForKey:@"openid"];
    
    NSString *weixinId = unionid ?unionid:openid;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/hongbao_system/record",RED_ENVELOP_HOST_NAME];
    __weak IncomeDetailsViewController *weakSelf = self;
    NSDictionary *parameters = @{@"idfa":idfa,@"verify":verify,@"weixin_id":weixinId,@"appid":appid,@"stype":stype};
    [manager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSString *message = [responseObject objectForKey:@"message"];
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:message];
            
          NSArray *icomeDetails= [responseObject objectForKey:@"income_data"];
            [icomeDetails enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *arr = (NSArray *)obj;
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                NSNumber *goldLong = [arr objectAtIndex:0];
                NSString *typeStr = [arr objectAtIndex:1];
                NSNumber *timeNumber = [arr objectAtIndex:2];
                NSTimeInterval time = [timeNumber doubleValue];
                [dic setObject:typeStr forKey:@"type"];
                NSString  *timeStr = [NSDate timeStamp:time];
                [dic setObject:timeStr forKey:@"time"];
                NSString *goldNum = [NSString stringWithFormat:@"%@",goldLong];
                [dic setObject:goldNum forKey:@"number"];
                if ([typeStr isEqualToString:@"0"]) {
                    [dic setObject:@"首次登录红包" forKey:@"describe"];
                }else if ([typeStr isEqualToString:@"1"]){
                    [dic setObject:@"分享文章红包" forKey:@"describe"];
                }else if ([typeStr isEqualToString:@"2"]){
                    [dic setObject:@"阅读文章红包" forKey:@"describe"];
                }else if ([typeStr isEqualToString:@"3"]){
                    [dic setObject:@"签到红包" forKey:@"describe"];
                }else if ([typeStr isEqualToString:@"4"]){
                    [dic setObject:@"邀请好友红包" forKey:@"describe"];
                }else if ([typeStr isEqualToString:@"5"]){
                    [dic setObject:@"评论红包" forKey:@"describe"];
                } else if ([typeStr isEqualToString:@"6"]){
                    [dic setObject:@"视频红包" forKey:@"describe"];
                }else if ([typeStr isEqualToString:@"7"]){
                    [dic setObject:@"任务红包" forKey:@"describe"];
                }
                [weakSelf.dataArray addObject:dic];
                if (stop) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC);
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            
                            [SVProgressHUD dismiss];
                            // Do something...
                            
                        });
                       
                        [weakSelf.incomeTableView reloadData];
                        
                    });
                }
            }];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
   
   
   
}
- (void)initUI{
    self.incomeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, SCREEN_HEIGHT)];
    [self.incomeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([IncomeDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:IncomeCellIdentifier];
    self.incomeTableView.delegate = self;
    self.incomeTableView.dataSource = self;
    [self.view addSubview:self.incomeTableView];
    self.incomeTableView.tableFooterView = [[UIView alloc]init];
    [self.incomeTableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53*kScale;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    IncomeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IncomeCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count> indexPath.row) {
        NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
        [cell setContent:dic];
    }
    
    return cell;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
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
