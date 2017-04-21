//
//  VideoContentTableVC.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/8.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "VideoContentTableVC.h"
#import <MJRefresh/MJRefresh.h>
#import "HRVideoCell.h"
#import "HRNetworkTools.h"
#import "VideoModel.h"
#import "VideoPlayViewController.h"
#import <CYLTableViewPlaceHolder.h>
#import "XTNetReloader.h"
#import "WeChatStylePlaceHolder.h"
#import "HRJudgeNetworking.h"
#import "UIImage+Extension.h"
static NSString * const videoCell = @"videoCell";
@interface VideoContentTableVC ()<HRVideoCellDelegate,CYLTableViewPlaceHolderDelegate,WeChatStylePlaceHolderDelegate>
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *arrayList;

@end

@implementation VideoContentTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBasic];
    
    [self setupRefresh];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark --private Method--设置tableView
-(void)setupBasic {
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(104, 0, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HRVideoCell class]) bundle:nil] forCellReuseIdentifier:videoCell];
    self.tableView.rowHeight =  UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;//必须设置好预估值
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
  [self.tableView cyl_reloadData];
  __weak VideoContentTableVC *weakSelf = self;
 
  NSString *page = [NSString stringWithFormat:@"%ld",(long)_currentPage];
  NSString *url = [[NSString stringWithFormat:@"%@/video/%@?page=%@",INFAMATION_HOST_NAME,self.title,page] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  [[[HRNetworkTools sharedNetworkToolsWithoutBaseUrl] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSNumber *code = [responseObject objectForKey:@"code"];
        NSInteger codeInteger = [code integerValue];
        if (codeInteger == 1) {
            //有数据
            id value = [responseObject objectForKey:@"data"];
            if ([value isKindOfClass:[NSArray class]]){
                NSArray *dataArr = (NSArray *)value;
                NSArray *arrayM = [VideoModel mj_objectArrayWithKeyValuesArray:dataArr];
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
            
        }else if (codeInteger == 0){
            //加载完所有数据
            if (type == ScrollDirectionDown) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView cyl_reloadData];
            }else if(type == ScrollDirectionUp){
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView cyl_reloadData];
            }
        }else{
            //服务出问题
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
             }
        }
    
   } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@",error);
   }] resume];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arrayList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HRVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:videoCell forIndexPath:indexPath];
     cell.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    cell.delegate = self;
    VideoModel *videoMode= [self.arrayList objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.videoModel = videoMode;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoModel *model = [self.arrayList objectAtIndex:indexPath.row];
    VideoPlayViewController *playVc = [[VideoPlayViewController alloc]initWithURL:[NSURL URLWithString:model.html_url]];
    playVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playVc animated:YES];
}




- (void)shareVideo:(VideoModel *)videoModel{
    __weak VideoContentTableVC *weakSelf = self;
    //NSString *textToShare = videoModel.title;
    NSURL *image_url = [NSURL URLWithString:videoModel.imgurl];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:image_url]];
    
    UIImage *imageToShare = [UIImage compressOriginalImage:image toMaxDataSizeKBytes:64.0];
    NSString *url = [NSString stringWithFormat:@"%@?stype=share",videoModel.html_url];
    NSURL *urlToShare = [NSURL URLWithString:url];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:@[imageToShare,urlToShare]
                                                        applicationActivities:nil];
    
    
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact,UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks,UIActivityTypePostToVimeo,
                                                     UIActivityTypePrint];
    [self presentViewController:activityViewController animated:YES completion:nil];
    activityViewController.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        if (completed) {
           
                [weakSelf showSVPressHUB:@"分享成功"];
           
            
        }
    };
}

- (void)showSVPressHUB:(NSString *)info{
    [SVProgressHUD showInfoWithStatus:info];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [SVProgressHUD dismiss];
        // Do something...
        
    });
}
- (UIView *)makePlaceHolderView{
   
    UIView *weChatStyle = [self weChatStylePlaceHolder];
        return weChatStyle;
}
- (UIView *)taoBaoStylePlaceHolder {
    __block XTNetReloader *netReloader = [[XTNetReloader alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                                                  reloadBlock:^{
                                                                      [self.tableView.mj_header beginRefreshing];
                                                                  }] ;
    return netReloader;
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
