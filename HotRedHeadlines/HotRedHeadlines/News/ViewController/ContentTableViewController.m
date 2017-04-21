//
//  ContentTableViewController.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "ContentTableViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "HRNetworkTools.h"
#import "HRNormalNews.h"
#import "NoPictureNewsTableViewCell.h"
#import "SinglePictureNewsTableViewCell.h"
#import "MultiPictureTableViewCell.h"
#import "HRWebViewController.h"
#import <CYLTableViewPlaceHolder.h>
#import "WeChatStylePlaceHolder.h"
@interface ContentTableViewController ()<CYLTableViewPlaceHolderDelegate,WeChatStylePlaceHolderDelegate,UINavigationControllerDelegate>
@property (nonatomic, assign) NSInteger      currentPage;
@property (nonatomic, strong) NSMutableArray *arrayList;
@property(nonatomic, assign)  BOOL           update;
@end
static NSString * const singlePictureCell = @"SinglePictureCell";
static NSString * const multiPictureCell = @"MultiPictureCell";
static NSString * const bigPictureCell = @"BigPictureCell";
static NSString * const topTextPictureCell = @"TopTextPictureCell";
static NSString * const topPictureCell = @"TopPictureCell";
static NSString * const NoPictureNewsCell = @"NoPictureNewsTableViewCell";
@implementation ContentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBasic];
    [self setupRefresh];
  
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.update == YES) {
        [self.tableView.mj_header beginRefreshing];
        self.update = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
#pragma mark --private Method--设置tableView
-(void)setupBasic {
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.navigationController.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(104, 0, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NoPictureNewsTableViewCell class]) bundle:nil] forCellReuseIdentifier:NoPictureNewsCell];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SinglePictureNewsTableViewCell class]) bundle:nil] forCellReuseIdentifier:singlePictureCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MultiPictureTableViewCell class]) bundle:nil] forCellReuseIdentifier:multiPictureCell];
    self.tableView.tableFooterView = [[UIView alloc]init];
}
#pragma mark --private Method--初始化刷新控件
-(void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.currentPage = 1;
}
#pragma mark - /************************* 刷新数据 ***************************/
// ------下拉刷新
- (void)loadData
{
    _currentPage = 1;
   [self loadDataForType:ScrollDirectionDown];
}

- (void)loadMoreData
{
    _currentPage +=1;
    [self loadDataForType:ScrollDirectionUp];

}

- (void)loadDataForType:(ScrollDirection)type
{
    __weak ContentTableViewController *weakSelf = self;

    NSString *page = [NSString stringWithFormat:@"%ld",(long)_currentPage];
    NSString *url = [[NSString stringWithFormat:@"%@/news/%@?page=%@",INFAMATION_HOST_NAME,self.title,page] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[[HRNetworkTools sharedNetworkToolsWithoutBaseUrl] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            id value = [responseObject objectForKey:@"data"];
            if ([value isKindOfClass:[NSArray class]]){
              NSArray *dataArr = (NSArray *)value;
               
                NSArray *arrayM = [HRNormalNews mj_objectArrayWithKeyValuesArray:dataArr];
                if (type == ScrollDirectionDown) {
                    self.arrayList = [arrayM mutableCopy];
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView cyl_reloadData];
                }else if(type == ScrollDirectionUp){
                    [self.arrayList addObjectsFromArray:arrayM];
                    
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView cyl_reloadData];
                }
            }
        }
        if (type == ScrollDirectionDown) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView cyl_reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView cyl_reloadData];
                [weakSelf.tableView.mj_footer endRefreshing];
            });
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }] resume];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arrayList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HRNormalNews *listM = self.arrayList[indexPath.row];
    if (listM.image_list.count == 1) {
        return 110;
    }else{
      return 170;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        HRNormalNews *listM = self.arrayList[indexPath.row];
    
    if (listM.image_list.count ==1) {
        SinglePictureNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:singlePictureCell];
        cell.normalNews = listM;
        
        return cell;
    }else{
     
        MultiPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:multiPictureCell];
        
        cell.normalNews = listM;
        return cell;
    }
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HRNormalNews *listM = self.arrayList[indexPath.row];
    NSString *imageUrl;
    if (listM.image_list.count > 0) {
        imageUrl = [listM.image_list objectAtIndex:0];
    }
    HRWebViewController *businessDetail = [[HRWebViewController alloc]init];
    businessDetail.aUrl = [NSURL URLWithString:listM.article_url];
    businessDetail.image_url = imageUrl;
    businessDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:businessDetail animated:NO];
}
#pragma mark - 无数据占位
- (UIView *)makePlaceHolderView{
    
    UIView *weChatStyle = [self weChatStylePlaceHolder];
    return weChatStyle;
}


- (UIView *)weChatStylePlaceHolder {
    WeChatStylePlaceHolder *weChatStylePlaceHolder = [[WeChatStylePlaceHolder alloc] initWithFrame:self.tableView.frame];
    weChatStylePlaceHolder.delegate = self;
    return weChatStylePlaceHolder;
}
#pragma mark - WeChatStylePlaceHolderDelegate Method

- (void)emptyOverlayClicked:(id)sender {
    [self.tableView.mj_header beginRefreshing];
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
@end
