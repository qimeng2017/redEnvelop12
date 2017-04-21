//
//  HRTaBarViewController.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRTaBarViewController.h"
#import "HRNavigationViewController.h"
#import "NewsViewController.h"
#import "VideoViewController.h"
#import "MeTableViewController.h"
#import "InvitationMakeMoneyVC.h"
#import "HRNetworkTools.h"
#import "SGAlertView.h"
#import "HRUtilts.h"
#import "HRSystem.h"
#import <StoreKit/StoreKit.h>
#import "HRAlertView.h"
#import "RedEnvelopeView.h"
@interface HRTaBarViewController ()<MeTableViewControllerDelegate,SGAlertViewDelegate,RedEnvelopeViewDelegate,SKStoreProductViewControllerDelegate>
{
    MeTableViewController *_MeController;
    NSString *download_url;
    SGAlertView *alert;
}
@property (nonatomic, assign) BOOL            isShakeCanChangeSkin;
@property (nonatomic, strong) NSNumber        *timeNumber;
@property (nonatomic, strong) RedEnvelopeView *redEnvelop;//抢红包页面
@property (nonatomic, strong) NSTimer         *timer;
@end

@implementation HRTaBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor redColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [UITabBar appearance].translucent = NO;
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    NewsViewController *vc1 = [[NewsViewController alloc] init];
    [self addChildViewController:vc1 withImage:[UIImage imageNamed:@"tabbar_zhuyemianb"] selectedImage:[UIImage imageNamed:@"tabbar_zhuyemian"] withTittle:@"新闻"];
        VideoViewController *vc3 = [[VideoViewController alloc] init];
        [self addChildViewController:vc3 withImage:[UIImage imageNamed:@"tabbar_shipingb"] selectedImage:[UIImage imageNamed:@"tabbar_shiping"] withTittle:@"视频"];
    InvitationMakeMoneyVC *vc2 = [[InvitationMakeMoneyVC alloc] init];
    [self addChildViewController:vc2 withImage:[UIImage imageNamed:@"tabbar_yaoqingb"] selectedImage:[UIImage imageNamed:@"tabbar_yaoqing"] withTittle:@"邀请"];
    

    
    MeTableViewController *vc4 = [[MeTableViewController alloc] init];
    _MeController = vc4;
    [self addChildViewController:vc4 withImage:[UIImage imageNamed:@"tabbar_wo_yemianb"] selectedImage:[UIImage imageNamed:@"tabbar_wo_yemian"] withTittle:@"我的"];
    vc4.delegate = self;
    
    [self setupBasic];
    if ([UserDefaultObjectForKey(REVIEW_THE_STATUS) isEqualToString:@"review"]) {
        [self remindingGoToReview];
    }
   
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString *buildVersionUpdate = [NSString stringWithFormat:@"%@-update",[HRSystem bundleBuildVersion]];
    NSString *isUpdate = UserDefaultObjectForKey(buildVersionUpdate);
    if (![isUpdate isEqualToString:@"ok"]) {
        [self getUserInfo];
        UserDefaultSetObjectForKey(@"ok", buildVersionUpdate);
    }
//    [self checkUpdate];
}



-(void)setupBasic {
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
        self.tabBarController.tabBar.barTintColor = RGBA(246, 246, 246, 1);
    } else {
        self.tabBar.barTintColor = [UIColor whiteColor];
    }
    
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self becomeFirstResponder];
    self.isShakeCanChangeSkin = [[NSUserDefaults standardUserDefaults] boolForKey:IsShakeCanChangeSkinKey];
}

-(void)dealloc {
    
}


-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        if (self.isShakeCanChangeSkin == NO) return;
        if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {//将要切换至夜间模式
            self.dk_manager.themeVersion = DKThemeVersionNight;                self.tabBar.barTintColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
//            _MeController.changeSkinSwitch.on = YES;
        } else {
            self.dk_manager.themeVersion = DKThemeVersionNormal;             self.tabBar.barTintColor = [UIColor whiteColor];
//            _MeController.changeSkinSwitch.on = NO;
            
        }
    }
}

- (void)addChildViewController:(UIViewController *)controller withImage:(UIImage *)image selectedImage:(UIImage *)selectImage withTittle:(NSString *)tittle{
    UIColor *colorSelect=[UIColor redColor];
    HRNavigationViewController *nav = [[HRNavigationViewController alloc] initWithRootViewController:controller];
    
    [nav.tabBarItem setImage:image];
    [nav.tabBarItem setSelectedImage:selectImage];
    //    nav.tabBarItem.title = tittle;
    //    controller.navigationItem.title = tittle;
    controller.title = tittle;//这句代码相当于上面两句代码
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:colorSelect} forState:UIControlStateSelected];
    nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
    [self addChildViewController:nav];
}

-(void)shakeCanChangeSkin:(BOOL)status {
    self.isShakeCanChangeSkin = status;
}

-(void)didReceiveMemoryWarning {
    [[SDImageCache sharedImageCache] clearDisk];
    
}
#pragma mark -检测是否更新
- (void)checkUpdate{
    NSString *url = [NSString stringWithFormat:@"%@/version_update",RED_ENVELOP_HOST_NAME];
    NSString *buildNumber = [HRSystem bundleVersion];
    NSDictionary * parameters = @{@"appid":appid,@"stype":buildNumber};
    [[HRNetworkTools sharedNetworkTools]GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *code = [responseObject objectForKey:@"code"];
        NSInteger codeInteger = [code integerValue];
        NSNumber *mode = [responseObject objectForKey:@"mode"];
        NSInteger modeInteger = [mode integerValue];
        NSString *title = [responseObject objectForKey:@"title"];
        NSString *message = [responseObject objectForKey:@"message"];
        download_url = [responseObject objectForKey:@"download_url"];
        if (codeInteger==1) {
            if (modeInteger==0) {
                [self accordingUpdate:title content:message type:SGAlertViewBottomViewTypeOne];
                
            }else{
                [self accordingUpdate:title content:message type:SGAlertViewBottomViewTypeTwo];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//code = 1弹出升级提醒,mode = 1  升级提醒，但不强制
- (void)accordingUpdate:(NSString *)title content:(NSString *)content type:(SGAlertViewBottomViewType)type{
    if (!alert) {
        alert = [[SGAlertView alloc] initWithTitle:title  delegate:self contentTitle:content alertViewBottomViewType:type];
        [alert show];
    }
    
}


- (void)didSelectedSureButtonClick {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:download_url]];
}
#pragma mark -获取用户信息
- (void)getUserInfo{
    NSString *url = [NSString stringWithFormat:@"%@/user/info",RED_ENVELOP_HOST_NAME];
    NSDictionary *userWXInfo = UserDefaultObjectForKey(USERINFO);
    HRUtilts *utilts = [[HRUtilts alloc]init];
    NSString *idfa = [utilts idfa];
    NSString *verify = [utilts verify];
    NSString *unionid = [userWXInfo objectForKey:@"unionid"];
    NSString *openid = [userWXInfo objectForKey:@"openid"];
    
    NSString *weixinId = unionid ?unionid:openid;
    NSDictionary *parameters = @{@"verify":verify,@"weixin_id":weixinId,@"idfa":idfa};
    [[HRNetworkTools sharedNetworkTools]POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            UserDefaultSetObjectForKey(responseObject, USER_REDBAG_INFO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma mark - 提醒评分
- (void)remindingGoToReview{
    
    NSDictionary *userInfo = UserDefaultObjectForKey(@"userInfo");
    NSString *unionid = [userInfo objectForKey:@"unionid"];
    NSString *openid = [userInfo objectForKey:@"openid"];
    
    NSString *weixinId = unionid ?unionid:openid;
    NSString *url = [NSString stringWithFormat:@"%@/comment_status",RED_ENVELOP_HOST_NAME];
    NSString *buildNumber = [HRSystem bundleVersion];
    NSDictionary *parameters = @{@"appid":appid,@"stype":buildNumber,@"weixin_id":weixinId};
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
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISAPPSTROY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self presentAppstory];
    }
}
- (void)presentAppstory{
    
    //计时开始
    
    NSString *reviewURL = templateReviewURL ;
  
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        reviewURL = templateReviewURLiOS7;
    }
    // iOS 8 needs a different templateReviewURL also @see https://github.com/arashpayan/appirater/issues/182
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        reviewURL = templateReviewURLiOS8 ;
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:reviewURL]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
    }
    
}

#
- (void)appearRedBag{
    NSDate *beginDate = [[NSUserDefaults standardUserDefaults] objectForKey:DATE_TO_BEGIN];
    NSDate *endDate = [[NSUserDefaults standardUserDefaults] objectForKey:DATE_TO_END];
    time_t startTime = (time_t)[beginDate timeIntervalSince1970];
    time_t endTime = (time_t)[endDate timeIntervalSince1970];
    time_t deltaTimeInSeconds = endTime - startTime;
    double time = [_timeNumber doubleValue];
    if (deltaTimeInSeconds < time) {//3分钟
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:ISAPPSTROY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
   
    _redEnvelop = [[RedEnvelopeView alloc]init];
    _redEnvelop.delegate = self;
    [_redEnvelop showType:RobRedEnvelopComment info:@"RobRedEnvelopComment"];
}
- (void)removeFrom:(RobRedEnvelopType)type{
    NSLog(@"removeFrom");
}
#pragma mark --抢成功 5秒消失
- (void)robSucess:(RobRedEnvelopType)type{
    __weak HRTaBarViewController *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.timer invalidate];
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
@end
