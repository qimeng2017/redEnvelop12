//
//  InvitationMakeMoneyVC.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/7.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "InvitationMakeMoneyVC.h"
#import "TopInvitationCell.h"
#import "CenterInvitationCell.h"
#import "BottomInvitationCell.h"
#import "InvitationHistoryVC.h"
#import "HRUtilts.h"
#import "HRNetworkTools.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "SGActionSheet.h"
#import "LKBubble.h"
#import "UIImage+Extension.h"
#define TRY_AN_ANIMATED_GIF 0
static NSString *InvitationtopCellIdentifier = @"InvitationtopCellIdentifier";
static NSString *InvitationCenterCellIdentifier = @"InvitationCenterCellIdentifier";
static NSString *InvitationBottomCellIdentifier = @"InvitationBottomCellIdentifier";
@interface InvitationMakeMoneyVC ()<TopInvitationCellDelegate,CenterInvitationCellDelegate,JTSImageViewControllerInteractionsDelegate,SGActionSheetDelegate>
//@property (nonatomic,strong)NSMutableArray *dataArr;
//@property (nonatomic,strong)NSString *adTitle;
@property (nonatomic,strong)UIImage *saveImage;
@property (nonatomic,strong)JTSImageViewController *imageViewer;

@end

@implementation InvitationMakeMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"邀请赚钱";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initUI];
   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (UserDefaultObjectForKey(USER_CODE)) {
//        return;
//    }
//    [self getInviteCode];
}
//- (NSMutableArray *)dataArr{
//    if (!_dataArr) {
//        _dataArr = [NSMutableArray array];
//    }
//    return _dataArr;
//}
//获取邀请码及邀请记录
//- (void)getInviteCode{
//    if (self.dataArr.count>0) {
//        [self.dataArr removeAllObjects];
//    }
//    __weak InvitationMakeMoneyVC *weakSelf = self;
//    NSString *url = [NSString stringWithFormat:@"%@/user/tudi",RED_ENVELOP_HOST_NAME];
//    NSDictionary *userInfo = UserDefaultObjectForKey(@"userInfo");
//    HRUtilts *utilts = [[HRUtilts alloc]init];
//    NSString *idfa = [utilts idfa];
//    NSString *verify = [utilts verify];
//    NSString *weixinId = [userInfo objectForKey:@"unionid"];
//    NSNumber *inviteCode = UserDefaultObjectForKey(USER_CODE);
//    NSString *invite_code = [NSString stringWithFormat:@"%@",inviteCode];
//    NSDictionary *parameters = @{
//                                 @"idfa":idfa,@"verify":verify,@"weixin_id":weixinId
//                                 };
//    [[HRNetworkTools sharedNetworkTools]POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if ([responseObject isKindOfClass:[NSDictionary class]]){
//            NSNumber *numberCode = [responseObject objectForKey:@"code"];
//            NSInteger code = [numberCode integerValue];
//            if (code == 1) {
//                NSNumber *inviteCode = [responseObject objectForKey:@"invite_code"];
//                UserDefaultSetObjectForKey(inviteCode, USER_CODE);
//                NSArray *arr = [responseObject objectForKey:@"data"];
//                weakSelf.adTitle = [responseObject objectForKey:@"invite_ad_title"];
//                for (NSDictionary *dic in arr) {
//                    [weakSelf.dataArr addObject:dic];
//                }
//                
//            }
//            
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [weakSelf.tableView reloadData];
//        });
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
//    
//    
//    }
- (void)initUI{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TopInvitationCell class]) bundle:nil] forCellReuseIdentifier:InvitationtopCellIdentifier];
    [self.tableView registerClass:[CenterInvitationCell class] forCellReuseIdentifier:InvitationCenterCellIdentifier];

    [self.tableView registerClass:[BottomInvitationCell class] forCellReuseIdentifier:InvitationBottomCellIdentifier];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        self.tableView.rowHeight =  UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 100;//必须设置好预估值
    }else if (indexPath.row == 1){
        return kScreenWidth*3/5+15;
    }
        return kScreenWidth*3/10+50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TopInvitationCell *cell = [tableView dequeueReusableCellWithIdentifier:InvitationtopCellIdentifier forIndexPath:indexPath];
        cell.delegate  =self;
        
        return cell;
    }else if (indexPath.row == 1){
        CenterInvitationCell *cell = [tableView dequeueReusableCellWithIdentifier:InvitationCenterCellIdentifier];
        NSDictionary *userRedBaginfoDict = UserDefaultObjectForKey(USER_REDBAG_INFO);
       NSNumber *inviteCode = [userRedBaginfoDict objectForKey:@"invite_code"];
        cell.conten = [NSString stringWithFormat:@"%@",inviteCode];
        cell.delegate  =self;
        return cell;
        
    }else{
        BottomInvitationCell *cell = [tableView dequeueReusableCellWithIdentifier:InvitationBottomCellIdentifier];
        return cell;
    }
   
}
- (void)viewYourInvitationHistory{
    InvitationHistoryVC *invitationHistory = [[InvitationHistoryVC alloc]init];
//    invitationHistory.dataArr = self.dataArr;
//    invitationHistory.adTitle = self.adTitle;
    [self.navigationController pushViewController:invitationHistory animated:YES];
    NSLog(@"查看记录");
}
- (void)tap:(NSInteger)index view:(UIView *)view{
    if (index==4) {
        [self copyInvitationCode];
    }else if (index == 5){
        [self bigButtonTapped:view];
    }else{
        [self systemShare];
    }
    NSLog(@"%ld",(long)index);
}
//二维码
- (void)bigButtonTapped:(UIView *)sender {
    
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
#if TRY_AN_ANIMATED_GIF == 1
    imageInfo.imageURL = [NSURL URLWithString:@"http://media.giphy.com/media/O3QpFiN97YjJu/giphy.gif"];
#else
    self.saveImage = [UIImage imageNamed:@"QRcode"];
    imageInfo.image = self.saveImage;
#endif
    imageInfo.referenceRect = sender.frame;
    imageInfo.referenceView = sender.superview;
    imageInfo.referenceContentMode = sender.contentMode;
    imageInfo.referenceCornerRadius = sender.layer.cornerRadius;
    
    // Setup view controller
    _imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    _imageViewer.interactionsDelegate = self;
    
    // Present the view controller.
    [_imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}
//长按
- (void)imageViewerDidLongPress:(JTSImageViewController *)imageViewer atRect:(CGRect)rect{
    NSLog(@"长按");
    SGActionSheet *sheet = [[SGActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitleArray:@[@"保存到相册"]];
    sheet.cancelButtonTitleColor = [UIColor redColor];
    [sheet show];
}
- (void)SGActionSheet:(SGActionSheet *)actionSheet didSelectRowAtIndexPath:(NSInteger)indexPath {
    if (indexPath == 0) {
       UIImageWriteToSavedPhotosAlbum(self.saveImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);  
    }
   
    NSLog(@"%ld", (long)indexPath);
}
//保存相册
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
        
        [_imageViewer dismiss:YES];
        [self saveMessage:message];
    }else
    {
        message = [error description];
        [self saveMessage:@"保存失败"];
    }
    NSLog(@"message is %@",message);
}
- (void)saveMessage:(NSString *)message{
    [SVProgressHUD showInfoWithStatus:message];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [SVProgressHUD dismiss];
        // Do something...
        
    });
}
//复制
- (void)copyInvitationCode{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    NSNumber *inviteCode = UserDefaultObjectForKey(USER_CODE);
    pboard.string = [NSString stringWithFormat:@"%@",inviteCode];
    [self showRightWithTitle:@"复制成功" autoCloseTime:1];
//    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//
//        [SVProgressHUD dismiss];
//        // Do something...
//        
//    });
}
#pragma 分享
- (void)systemShares{
    NSDictionary *userRedBagInfoDict = UserDefaultObjectForKey(USER_REDBAG_INFO);
//    NSNumber *invite_code = [userRedBagInfoDict objectForKey:@"invite_code"];
    NSString *textToShare = [NSString stringWithFormat:@"你有个红包还未拆开呢！快下载领取吧~看新闻就能月赚366元"];
    
    UIImage *imageToShare = [UIImage imageNamed:@"Icon-Spotlight-40"];
    imageToShare = [UIImage compressOriginalImage:imageToShare toMaxDataSizeKBytes:64];
    NSString *url = [NSString stringWithFormat:@"%@",[userRedBagInfoDict objectForKey:@"invite_ad_url"]];
    NSURL *urlToShare = [NSURL URLWithString:@"http://www.baidu.com"];
    
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:@[textToShare,urlToShare]
                                                        applicationActivities:nil];
    
    
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact,UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks,UIActivityTypePostToVimeo,
                                                     UIActivityTypePrint];
    [self presentViewController:activityViewController animated:YES completion:nil];
    activityViewController.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        if (completed) {
            if ([activityType isEqualToString:@"com.tencent.xin.sharetimeline"]) {

            }
            
        }
    };
}

//系统方法
- (void)systemShare{
    NSDictionary *userRedBagInfoDict = UserDefaultObjectForKey(USER_REDBAG_INFO);
     NSString *textToShare = [NSString stringWithFormat:@"你有个还未拆开呢"];
    UIImage *imageToShare = [UIImage imageNamed:@"Icon-Spotlight-40"];

   
   NSString *url = [NSString stringWithFormat:@"%@",[userRedBagInfoDict objectForKey:@"invite_ad_url"]];
    NSURL *urlToShare = [NSURL URLWithString:url];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:@[urlToShare]
                                                        applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact,UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks,UIActivityTypePostToVimeo,
                                                     UIActivityTypePrint];
    [self presentViewController:activityViewController animated:YES completion:nil];
    activityViewController.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        if (completed) {
            if ([activityType isEqualToString:@"com.tencent.xin.sharetimeline"]) {
                
            }
            
        }
    };
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
