//
//  VideoPlayViewController.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/8.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "VideoPlayViewController.h"
#import "SCSkypeActivityIndicatorView.h"
#import "SignImageView.h"
#import "RedEnvelopeView.h"
#import "NSObject+arc4arndom.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "HRWebProgressLayer.h"
#import "HRFlashLable.h"
@interface VideoPlayViewController ()<UIWebViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,SignImageViewDelegate,RedEnvelopeViewDelegate>
{
    UIWebView                    *_webView;
    //SCSkypeActivityIndicatorView *activityIndicatorView;
    NSInteger                    arc4random;
    NSTimer                      *myTimer;
    NSDictionary                 *userInfoDict;
    NSTimer                      *adTimer;
    BOOL                         ad_switch;
    HRWebProgressLayer           *_progressLayer; ///< 网页加载进度条
}
@property (nonatomic, strong) SignImageView *sign;
@property(nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic, strong) HRFlashLable     *tipLable;
@end

@implementation VideoPlayViewController
@synthesize showSubTitle;
@synthesize navigationTitle;
- (instancetype)initWithURL:(NSURL *)url
{
    if (self = [super init]) {
        self.aUrl = url;
        self.showSubTitle = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    arc4random = [NSObject getRandomNumber:1 to:100];
    
    userInfoDict = UserDefaultObjectForKey(USER_REDBAG_INFO);
    NSDictionary *google_ad_setingDict = [userInfoDict objectForKey:@"google_ad_seting"];
    NSNumber *ad_open_rateNumber = [google_ad_setingDict objectForKey:@"ad_open_rate"];
    int ad_open_rate = [ad_open_rateNumber intValue];
    NSNumber *ad_open_timeNumber = [google_ad_setingDict objectForKey:@"ad_open_time"];
    double time = [ad_open_timeNumber doubleValue];
    NSArray *switch_seting = [google_ad_setingDict objectForKey:@"switch_seting"];
    for (NSDictionary *dic in switch_seting) {
        NSNumber *ad_place_number = [dic objectForKey:@"ad_place"];
        NSInteger ad_place_inter = [ad_place_number integerValue];
        NSNumber *ad_switch_number = [dic objectForKey:@"ad_switch"];
        NSInteger ad_switch_inter = [ad_switch_number integerValue];
        
        if (ad_place_inter==2&&ad_switch_inter==1) {
            if (arc4random < ad_open_rate) {
                [self campaignPrepare];
                adTimer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(campaignAppear) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:adTimer forMode:NSRunLoopCommonModes];
            }
            
        }
        if (ad_place_inter == 4&&ad_switch_inter==0) {
            ad_switch = YES;
        }
        if (ad_place_inter==4&&ad_switch_inter==1) {
            
//            if (arc4random < 50) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self bannerPrepare];
                });
                
//            }
        }
        
    }
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"viewDidLoad");
    self.showSubTitle = NO;
    
}

- (void)setNavigationTitle:(NSString *)aNavigationTitle
{
    navigationTitle = aNavigationTitle;
    
    SET_NAVIGATION_TITLE(navigationTitle);
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_webView == nil) {
        UIWebView *webView = [[UIWebView alloc] init];
        webView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.view.frame));
         [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#e5e5e5'"];
//        if (ad_switch) {
//            webView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.view.frame));
//        }else{
//           webView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.view.frame)-60);
//        }
     
        webView.delegate = self;
        
        webView.scrollView.delegate = self;
        [self.view addSubview:webView];
        [self.view sendSubviewToBack:webView];
        _webView = webView;
        
        
        
        
        
        //UIActivityIndicatorView
//        {
//            activityIndicatorView = [[SCSkypeActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//            [self.view addSubview:activityIndicatorView];
//            [activityIndicatorView startAnimating];
//            activityIndicatorView.center = CGPointMake(kScreenWidth/2, SCREEN_HEIGHT/2);
//            
//            
//            
//        }
        
        NSURLRequest *request = [NSURLRequest requestWithURL:self.aUrl];
        
        [_webView loadRequest:request];
    }
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [self.view bringSubviewToFront:backBtn];
    //进度条
    _progressLayer = [HRWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 2);
    [self.view.layer addSublayer:_progressLayer];
    
    //加载提示语
    if (_tipLable == nil) {
        _tipLable = [[HRFlashLable alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, 80)];
        _tipLable.text = @"正在努力加载中!";
        _tipLable.center = CGPointMake(kScreenWidth/2, SCREEN_HEIGHT/2);
        _tipLable.textColor = [UIColor grayColor];
        _tipLable.font = [UIFont systemFontOfSize:20];
        _tipLable.haloColor = [UIColor redColor];
        _tipLable.haloWidth = 0.8;
        _tipLable.haloDuration = 2;
        _tipLable.numberOfLines = 2;
        _tipLable.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_tipLable];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
       // Dispose of any resources that can be recreated.
}
- (void)back
{
    _webView.delegate = nil;
    [_webView stopLoading];
    
    if (self.presentingViewController.presentedViewController == self.navigationController) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [myTimer invalidate];
}

- (void)goBack
{
    [_webView stopLoading];
    [_webView goBack];
}
#pragma mark - UIWebView delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (self.tipLable) {
        [self.tipLable removeFromSuperview];
    }
    [_progressLayer startLoad];
//    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    if (title.length > 0 && self.navigationTitle == nil) {
//        
//        if (showSubTitle) {
//            SET_NAVIGATION_TITLE_SUBTITLE(title, self.aUrl.absoluteString);
//        }
//        else {
//            SET_NAVIGATION_TITLE(title);
//        }
//    }
    
    //    [activityIndicatorView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_progressLayer finishedLoad];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    webTitle = title;
    if (title.length > 0 && self.navigationTitle == nil) {
        if (showSubTitle) {
            SET_NAVIGATION_TITLE_SUBTITLE(title, self.aUrl.absoluteString);
        }
        else {
            SET_NAVIGATION_TITLE(title);
        }
    }
   
    //[activityIndicatorView stopAnimating];
    NSDictionary *userRedBagInfoDict = UserDefaultObjectForKey(USER_REDBAG_INFO);
    NSNumber *hold_time = [userRedBagInfoDict objectForKey:@"hold_time"];
    double time = [hold_time doubleValue];
    myTimer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(signInView) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
   // [activityIndicatorView stopAnimating];
    [_progressLayer finishedLoad];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (title.length > 0 && self.navigationTitle == nil) {
        if (showSubTitle) {
            SET_NAVIGATION_TITLE_SUBTITLE(title, self.aUrl.absoluteString);
        }
        else {
            SET_NAVIGATION_TITLE(title);
        }
    }
    else {
        
        if (self.navigationTitle == nil) {
            if (showSubTitle) {
                SET_NAVIGATION_TITLE_SUBTITLE(@"加载失败", self.aUrl.absoluteString);
            }
            else {
                SET_NAVIGATION_TITLE(@"加载失败");
            }
        }
        
    }
    
}


- (void)signInView{
    NSString *urlStr = [NSString stringWithFormat:@"%@-webShare",self.aUrl];
    NSString *isOK=  UserDefaultObjectForKey(urlStr);
    if ([isOK isEqualToString:@"ok"]){
        return;
    }
    NSDictionary *userRedBagInfoDict = UserDefaultObjectForKey(USER_REDBAG_INFO);
    NSNumber *video_rate = [userRedBagInfoDict objectForKey:@"video_rate"];
    int rate = [video_rate intValue];
    if (arc4random <rate) {
        _sign = [[SignImageView alloc]initWithLableString:@"视频红包"];
        _sign.delegate = self;
        [_sign showViewController:self type:@"2" info:urlStr];
    }
    
}
- (void)showSignOrBag:(NSString *)type{
  
    NSString *urlStr = [NSString stringWithFormat:@"%@-webShare",self.aUrl];
    if ([UserDefaultObjectForKey(urlStr) isEqualToString:@"ok"]) {
        return;
    }
    [self redEnvelopeView];
}
- (void)removeFrom:(RobRedEnvelopType)type{
    NSLog(@"remove");
}
- (void)redEnvelopeView{
    [MobClick event:@"文章点击红包"];
    RedEnvelopeView *red = [[RedEnvelopeView alloc]init];
    NSString *urlStr = [NSString stringWithFormat:@"%@-webShare",self.aUrl];
    red.delegate = self;
    [red showType:RobRedEnvelopVideo info:urlStr];
}
- (void)robSucess:(RobRedEnvelopType)type {
    
    if (type==RobRedEnvelopVideo){
        NSString *urlStr = [NSString stringWithFormat:@"%@-webShare",self.aUrl];
        NSString *isOK=  UserDefaultObjectForKey(urlStr);
        if ([isOK isEqualToString:@"ok"]) {
            [MobClick event:@"文章拆开红包"];
            [_sign removeFromSuperview];
        }
        
    }else if(type==RobRedEnvelopShare){
//        int shareCount=  [[HRSettings sharedInstance].countNumber intValue];
//        NSString *urlStr = [NSString stringWithFormat:@"%@-share",self.aUrl];
//        NSString *rob = UserDefaultObjectForKey(urlStr);
//        if (shareCount>6||[rob isEqualToString:@"ok"]) {
//            shareBottomView.hidden = YES;
//            _webView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.view.frame));
//        }
    }
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


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}
#pragma mark --广告
//插页广告
- (void)campaignPrepare{
    self.interstitial = [[GADInterstitial alloc]initWithAdUnitID:video_ad_campaign_id];
    GADRequest *request = [GADRequest request];
    [self.interstitial loadRequest:request];
}
- (void)campaignAppear{
    
    if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:self];
    }
}
//横幅广告
-(void)bannerPrepare{
    
    GADBannerView *bannerView = [[GADBannerView alloc]initWithAdSize:kGADAdSizeSmartBannerPortrait origin:CGPointMake(0, SCREEN_HEIGHT - 60)];
    bannerView.adSize = GADAdSizeFromCGSize(CGSizeMake(kScreenWidth, 60));
    [self.view addSubview:bannerView];
    [self.view bringSubviewToFront:bannerView];
    bannerView.rootViewController = self;
    bannerView.adUnitID = video_ad_banner_id;
    [bannerView loadRequest:[GADRequest request]];
}
- (void)dealloc {
    
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
    NSLog(@"i am dealloc");
}
@end
