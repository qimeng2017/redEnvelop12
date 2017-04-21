//
//  NewsViewController.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "NewsViewController.h"
#import "ContentTableViewController.h"
#import "HRCategoryM.h"
#import "HRConfigPlist.h"
#import "NSDate+Formatter.h"
#import <StoreKit/StoreKit.h>
//红包
#import "RedEnvelopeView.h"
#import "SignImageView.h"
#import "SignInMainView.h"
#import "HRAlertView.h"

#import "HRNetworkTools.h"
#import "HRUtilts.h"

@interface NewsViewController ()<UINavigationControllerDelegate,SignImageViewDelegate,SignInMainViewDelegate,RedEnvelopeViewDelegate,HRAlertViewDelegate,SKStoreProductViewControllerDelegate>
@property (nonatomic, strong) SignImageView *signView;//签到红包按钮
@property (nonatomic, strong) SignInMainView *signMainView;//签到红包页面
@property (nonatomic, strong) RedEnvelopeView *redEnvelop;//抢红包页面
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSNumber *timeNumber;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _array = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
    
    [self setUpAllViewController];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    if ([UserDefaultObjectForKey(REVIEW_THE_STATUS) isEqualToString:@"review"]) {
//        [self remindingGoToReview];
//    }
    [self signInViewBtn];
    if([UserDefaultObjectForKey(@"frist_start_app") isEqualToString:@"YES"]){
        if ([UserDefaultObjectForKey(@"RobRedEnvelopFirstApp") isEqualToString:@"ok"]) {
            return;
        }
        [self redEncelop];
        UserDefaultSetObjectForKey(@"NO", @"frist_start_app");
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}
#pragma mark 添加所有子控制器
- (void)setUpAllViewController
{

    NSArray *arr = [HRConfigPlist localHeaderData];
    for (HRCategoryM *categoryM in arr) {
        ContentTableViewController *wordVc1 = [[ContentTableViewController alloc] init];
        wordVc1.title = categoryM.name;
        [self addChildViewController:wordVc1];
    }
    
}

#pragma mark --红包
#pragma mark -- 签到红包按钮
- (void)signInViewBtn{
    
    NSString *nowDay = [NSString stringWithFormat:@"%@-sign",[NSDate redDateForEveryday]];
    NSString *isSign = UserDefaultObjectForKey(nowDay) ;
    if ([isSign isEqualToString:@"sign"]) return;
    _signView = [[SignImageView alloc]initWithLableString:@"签到红包"];
    _signView.delegate = self;
    
    [_signView showViewController:self type:@"1" info:isSign];
}
- (void)showSignOrBag:(NSString *)type{
    [self signInMainView];
}
#pragma mark --签到页面
- (void)signInMainView{
    [MobClick event:@"首页点击红包"];
    _signMainView = [[SignInMainView alloc]init];
    _signMainView.delegate = self;
    [_signMainView showType:@"1" info:@"2"];
}
#pragma mark -签到成功 3秒自动消失
- (void)signSucess{
    NSString *nowDay = [NSString stringWithFormat:@"%@-sign",[NSDate redDateForEveryday]];
    NSString *isSign = UserDefaultObjectForKey(nowDay);
    if ([isSign isEqualToString:@"sign"]){
        __weak NewsViewController *weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.signView removeFromSuperview];
            [weakSelf.signMainView removeFromSuperview];
        });
        
    }
}
#pragma mark --首次打开应用出现红包
- (void)redEncelop{
    [MobClick event:@"首次登录领取红包"];
    _redEnvelop = [[RedEnvelopeView alloc]init];
    _redEnvelop.delegate = self;
    [_redEnvelop showType:RobRedEnvelopFirstApp info:@"RobRedEnvelopFirstApp"];
}
- (void)removeFrom:(RobRedEnvelopType)type{
    NSLog(@"removeFrom");
}
#pragma mark --抢成功 2秒消失
- (void)robSucess:(RobRedEnvelopType)type{
    __weak NewsViewController *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.redEnvelop removeFromSuperview];
        
    });
}
- (void)robSeverFailer{
     [self showSVPressHUB:NSLocalizedString(@"serviceError", @"")];
}
- (void)showSVPressHUB:(NSString *)info{
    [SVProgressHUD showInfoWithStatus:info];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [SVProgressHUD dismiss];
        // Do something...
        
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}
#pragma mark - 提醒评分
- (void)remindingGoToReview{
    NSDictionary *userInfo = UserDefaultObjectForKey(@"userInfo");
    NSString *unionid = [userInfo objectForKey:@"unionid"];
    NSString *openid = [userInfo objectForKey:@"openid"];
    
    NSString *weixinId = unionid ?unionid:openid;
    NSString *url = [NSString stringWithFormat:@"%@/comment_status",RED_ENVELOP_HOST_NAME];
    NSDictionary *parameters = @{@"appid":appid,@"stype":stype,@"weixin_id":weixinId};
    [[HRNetworkTools sharedNetworkTools] GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSNumber *codeNumber = [responseObject objectForKey:@"code"];
            NSString *message = [responseObject objectForKey:@"message"];
            NSInteger code = [codeNumber integerValue];
            _timeNumber = [responseObject objectForKey:@"time"];
            if (code == 1) {
                NSString *title = [responseObject objectForKey:@"title"];
                HRAlertView *alertView = [[HRAlertView alloc] initWithTitle:title message:message delegate:self andButtons:@[@"去评论", @"下次再说"]];
                [alertView show];
            }else{
                
            }
           
           
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"err");
    }];

    
    
}
- (void)popAlertView:(HRAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //记录弹出提醒的时间
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate new] forKey:DATE_TO_BEGIN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self presentAppstory];
    }
}
- (void)presentAppstory{
    
    
    [SVProgressHUD showInfoWithStatus:@"Loding..."];
    
//    NSString *string = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/zhi-jian-hong-bao/id%@?l=zh&ls=1&mt=8",appid];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    
    Class isAllow = NSClassFromString(@"SKStoreProductViewController");
    
    if (isAllow != nil) {
        
        SKStoreProductViewController *sKStoreProductViewController = [[SKStoreProductViewController alloc] init];
        [sKStoreProductViewController.view setFrame:CGRectMake(0, 200, 320, 200)];
        [sKStoreProductViewController setDelegate:self];
        [sKStoreProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: appid}
                                                completionBlock:^(BOOL result, NSError *error) {
                                                    if (result) {
                                                        [SVProgressHUD dismiss];
                                                        [self presentViewController:sKStoreProductViewController
                                                                           animated:YES
                                                                         completion:nil];
                                                        
                                                        
                                                    }else{
                                                        NSLog(@"error:%@",error);
                                                    }
                                                }];
    }else{
        //低于iOS6的系统版本没有这个类,不支持这个功能
        NSString *string = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/zhi-jian-hong-bao/id%@?l=zh&ls=1&mt=8",appid];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    }
    

    
}

#pragma mark - 评分取消按钮监听
//取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSDate *readyDateStamp = [[NSUserDefaults standardUserDefaults] objectForKey:DATE_TO_BEGIN];
    time_t startTime = (time_t)[readyDateStamp timeIntervalSince1970];
    time_t endTime = (time_t)[[NSDate date] timeIntervalSince1970];
    time_t deltaTimeInSeconds = endTime - startTime;
    //        NSLog(@"statrt=%ld,now=%ld, deltatime=%ld",startTime, endTime, deltaTimeInSeconds);
    NSInteger time = [_timeNumber integerValue];
    if (deltaTimeInSeconds < (60.f*time)) {//3分钟
        return;
    }
    _redEnvelop = [[RedEnvelopeView alloc]init];
    _redEnvelop.delegate = self;
    [_redEnvelop showType:RobRedEnvelopComment info:@"RobRedEnvelopComment"];
}



@end
