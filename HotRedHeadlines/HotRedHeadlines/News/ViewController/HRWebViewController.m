//
//  HRWebViewController.m
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/22.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRWebViewController.h"
#import "SignImageView.h"
#import "RedEnvelopeView.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"
#import "HRAlertView.h"
#import "NSDate+Formatter.h"
#import "MSSBrowseDefine.h"
#import "ShareBottomView.h"
#import "ZYShareView.h"
#import "HRSettings.h"
#import "SCSkypeActivityIndicatorView.h"
#import "NSObject+arc4arndom.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "HRWebProgressLayer.h"
#import "UIImage+Extension.h"
#import "HRFlashLable.h"
#import "HRUtilts.h"
#import "HRNetworkTools.h"
#import "LNAlertView.h"
@interface HRWebViewController ()<UIWebViewDelegate,UIScrollViewDelegate,WXApiManagerDelegate,HRAlertViewDelegate,ShareBottomViewDelegate,RedEnvelopeViewDelegate,SignImageViewDelegate,GADRewardBasedVideoAdDelegate,UINavigationControllerDelegate>
{
    UIWebView                    *_webView;
    //SCSkypeActivityIndicatorView *activityIndicatorView;
    CGFloat                      webViewHeight;
    NSString                     *webTitle;
    HRAlertView                  *alertViews;
    int                          count;
    ShareBottomView              *shareBottomView;
    NSInteger                    arc4random;
    NSDictionary                 *userInfoDict;
    NSTimer                      *adTimer;
    BOOL                         ad_switch;
    BOOL                         isNotTopShare;
    UIButton                     *backBtn;
    UIButton                     *shareBtn;
    HRWebProgressLayer           *_progressLayer; ///< 网页加载进度条
}


@property (nonatomic, strong) SignImageView   *sign;
@property (nonatomic, strong) NSMutableArray  *imageArr;
@property(nonatomic, strong)  GADInterstitial *interstitial;
@property (nonatomic, strong) HRFlashLable     *tipLable;
@end

@implementation HRWebViewController


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
- (NSMutableArray *)imageArr{
    if (_imageArr == nil) {
        _imageArr = [[NSMutableArray alloc]init];
    }
    return _imageArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    arc4random = [NSObject getRandomNumber:1 to:100];

    userInfoDict = UserDefaultObjectForKey(USER_REDBAG_INFO);
    //广告出现的情况
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
        if (ad_place_inter==1&&ad_switch_inter==1) {
            if (arc4random < ad_open_rate) {
                [self campaignPrepare];
                adTimer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(campaignAppear) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:adTimer forMode:NSRunLoopCommonModes];
            }
            
        }
        if (ad_place_inter==3&&ad_switch_inter==0){
            ad_switch = YES;
        }
        if (ad_place_inter==3&&ad_switch_inter==1) {
            
                dispatch_async(dispatch_get_main_queue(), ^{
                  [self bannerPrepare];
                });
                
         
        }
        
    }
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.showSubTitle = NO;
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    // Do any additional setup after loading the view.
    [WXApiManager sharedManager].delegate = self;
}


//TITLE
- (void)setNavigationTitle:(NSString *)aNavigationTitle
{
    navigationTitle = aNavigationTitle;
    
    SET_NAVIGATION_TITLE(navigationTitle);
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    }

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    if (_webView == nil) {
        UIWebView *webView = [[UIWebView alloc] init];
        webView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.view.frame));
         [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#e5e5e5'"];
//        if (ad_switch) {
//            if (arc4random < 50) {
//              
//            }else{
//                webView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.view.frame)-40);
//            }
//            
//        }else{
//            if (arc4random < 50) {
//              webView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.view.frame)-60);
//            }else{
//               webView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.view.frame));
//            }
//           
//        }
//        
        webView.delegate = self;
        webView.scrollView.delegate = self;
        [self.view addSubview:webView];
        _webView = webView;
        //UIActivityIndicatorView
//        {
//            activityIndicatorView = [[SCSkypeActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//            [self.view addSubview:activityIndicatorView];
//            [activityIndicatorView startAnimating];
//            activityIndicatorView.center = CGPointMake(kScreenWidth/2, SCREEN_HEIGHT/2);
//        }
        
                NSURLRequest *request = [NSURLRequest requestWithURL:self.aUrl];
                [_webView loadRequest:request];
           
            
       
       
    }
    //返回按钮
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"video_fanhui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [self.view bringSubviewToFront:backBtn];
    // 上面的分享按钮
    shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-54, 20, 44, 44)];
    [shareBtn setImage:[UIImage imageNamed:@"video_fenxiang"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(topShare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    shareBtn.userInteractionEnabled = NO;
    [self.view bringSubviewToFront:shareBtn];
    //进度条
    _progressLayer = [HRWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 2);
    [self.view.layer addSublayer:_progressLayer];
    
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
    [self signInView];
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
}

- (void)goBack
{
    [_webView stopLoading];
    [_webView goBack];
}

#pragma mark - UIWebView delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (title.length > 0 && self.navigationTitle == nil) {
        
        if (showSubTitle) {
            SET_NAVIGATION_TITLE_SUBTITLE(title, self.aUrl.absoluteString);
        }
        else {
            SET_NAVIGATION_TITLE(title);
        }
    }
    if (self.tipLable) {
        [self.tipLable removeFromSuperview];
    }
    [_progressLayer startLoad];
    
//    [activityIndicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    shareBtn.userInteractionEnabled = YES;
    [_progressLayer finishedLoad];
    int counts = [[HRSettings sharedInstance].countNumber intValue];
    NSString *urlStr = [NSString stringWithFormat:@"%@-share",self.aUrl];
    NSString *rob = UserDefaultObjectForKey(urlStr);
    if (counts < 6) {
        if ([rob isEqualToString:@"ok"]) {
            webView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.view.frame));
            
        }else{
            
            if (arc4random > 50) {
                shareBottomView = [[ShareBottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, kScreenWidth, 40)];
                shareBottomView.delegate = self;
                //[self.view addSubview:shareBottomView];
            }
            
        }
        
    }else{
       
        _webView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.view.frame));
    }
    webViewHeight=[[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
//    CGFloat webViewHeight=[webView.scrollView contentSize].height;
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    webTitle = title;
    if (title.length > 0 && self.navigationTitle == nil) {
        if (showSubTitle) {
            SET_NAVIGATION_TITLE_SUBTITLE(title, self.aUrl.absoluteString);
        }
        else {
            SET_NAVIGATION_TITLE(title);
        }
    }
    //[activityIndicatorView stopAnimating];
    
    //这里是js，主要目的实现对url的获取
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    self.imageArr= [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
    if (self.imageArr.count >= 2) {
        [self.imageArr removeLastObject];
    }
    
    //添加图片可点击js
    [webView stringByEvaluatingJavaScriptFromString:@"function registerImageClickAction(){\
     var imgs=document.getElementsByTagName('img');\
     var length=imgs.length;\
     for(var i=0;i<length;i++){\
     img=imgs[i];\
     img.onclick=function(){\
     window.location.href='image-preview:'+this.src}\
     }\
     }"];
    [webView stringByEvaluatingJavaScriptFromString:@"registerImageClickAction();"];
}
//在这个方法中捕获到图片的点击事件和被点击图片的url
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    //预览图片
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString* path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        for (NSInteger index = 0; index < self.imageArr.count; index++) {
           NSString *url = self.imageArr[index];
            if ([url isEqualToString:path]) {
                [self selectedIndex:index];
            }
        }
        
        return NO;
    }
    return YES;
}
- (void)selectedIndex:(NSInteger)selectedIndex{
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    for (NSInteger index = 0; index < self.imageArr.count; index++) {
        
        NSString *url = self.imageArr[index];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = url;// 加载网络图片大图地址
        // browseItem.smallImageView = imageView;// 小图
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:selectedIndex];
    //    bvc.isEqualRatio = NO;// 大图小图不等比时需要设置这个属性（建议等比）
    [bvc showBrowseViewController];

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_progressLayer finishedLoad];
    //[activityIndicatorView stopAnimating];
    
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


- (void)setShareView{
    UIView *shareView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-80*kScale, kScreenWidth, 80*kScale)];
    shareView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shareView];
   
    UIButton *aButton = [self buildButtonWithTitle:@"微信好友" andImageName:@"share_icon_weixin" andTag:WDSHARE_WEIXIN];
    aButton.center = CGPointMake(kScreenWidth /4, 40*kScale);
    [shareView addSubview:aButton];
    UIButton *bButton = [self buildButtonWithTitle:@"朋友圈" andImageName:@"share_icon_friend_circle" andTag:WDSHARE_WEIXIN];
    bButton.center = CGPointMake(kScreenWidth *3/4, 40*kScale);
    [shareView addSubview:bButton];
}

- (UIButton *)buildButtonWithTitle:(NSString *)pTitle andImageName:(NSString *)pImageName andTag:(NSInteger)pTag{
    UIButton *aButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 64.f, 76.f)];
    [aButton setImage:[UIImage imageNamed:pImageName] forState:UIControlStateNormal];
    [aButton setImage:[UIImage imageNamed:pImageName] forState:UIControlStateHighlighted];
    [aButton setTitle:pTitle forState:UIControlStateNormal];
    [aButton setTitleColor:[UIColor colorWithRed:88.f/255.f green:88.f/255.f blue:88.f/255.f alpha:1.f] forState:UIControlStateNormal];
    [aButton.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
    [aButton setImageEdgeInsets:UIEdgeInsetsMake(0.f, 7.f, 26.f, 7.f)];
    [aButton setTag:pTag];
    [aButton addTarget:self action:@selector(handleTapToShareAction:) forControlEvents:UIControlEventTouchUpInside];
    //aButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [aButton setTitleEdgeInsets:UIEdgeInsetsMake(55.f, -50.f, 0.f, 0)];
    return aButton;
}
- (void)handleTapToShareAction:(UIButton *)sender{
    NSString *url = [NSString stringWithFormat:@"%@",self.aUrl];
    
    if (sender.tag == WDSHARE_WEIXIN) {
        [WXApiRequestHandler sendLinkURL:url TagName:nil Title:webTitle Description:nil ThumbImage:nil InScene:WXSceneSession];
    }else{
       [WXApiRequestHandler sendLinkURL:url TagName:nil Title:webTitle Description:nil ThumbImage:nil InScene:WXSceneTimeline]; 
    }
}
#pragma mark --scrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    backBtn.hidden = YES;
    shareBtn.hidden = YES;
    NSString *urlStr = [NSString stringWithFormat:@"%@-webShare",self.aUrl];
    CGFloat contentOffsetX = scrollView.contentOffset.y;
    if (contentOffsetX >webViewHeight/3) {
        NSString *isOK=  UserDefaultObjectForKey(urlStr);
        if ([isOK isEqualToString:@"ok"]){
            return;
        }else{
            NSDictionary *userRedBagInfoDic = UserDefaultObjectForKey(USER_REDBAG_INFO);
            NSNumber *toutiao_rate = [userRedBagInfoDic objectForKey:@"toutiao_rate"];
            int rate = [toutiao_rate intValue];
            if (arc4random < rate) {
                _sign.hidden = NO;
            }
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //动画效果待做
    backBtn.hidden = YES;
    shareBtn.hidden = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    backBtn.hidden = NO;
    shareBtn.hidden = NO;
}
#pragma mark--红包
- (void)redEnvelopeView{
    [MobClick event:@"文章点击红包"];
    RedEnvelopeView *red = [[RedEnvelopeView alloc]init];
    NSString *urlStr = [NSString stringWithFormat:@"%@-webShare",self.aUrl];
    red.delegate = self;
    [red showType:RobRedEnvelopRead info:urlStr];
}
- (void)robSucess:(RobRedEnvelopType)type {
    
    if (type==RobRedEnvelopRead){
        NSString *urlStr = [NSString stringWithFormat:@"%@-webShare",self.aUrl];
        NSString *isOK=  UserDefaultObjectForKey(urlStr);
        if ([isOK isEqualToString:@"ok"]) {
            [MobClick event:@"文章拆开红包"];
            [_sign removeFromSuperview];
        }
        
    }else if(type==RobRedEnvelopShare){
      int shareCount=  [[HRSettings sharedInstance].countNumber intValue];
        NSString *urlStr = [NSString stringWithFormat:@"%@-share",self.aUrl];
        NSString *rob = UserDefaultObjectForKey(urlStr);
        if (shareCount>6||[rob isEqualToString:@"ok"]) {
            shareBottomView.hidden = YES;
            _webView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.view.frame));
        }
    }
}
- (void)robSeverFailer{
    [self showSVPressHUB:NSLocalizedString(@"serviceError", @"")];
}
- (void)removeFrom:(RobRedEnvelopType)type{
    if (type == RobRedEnvelopRead) {
        if ([UserDefaultObjectForKey(REVIEW_THE_STATUS) isEqualToString:@"review"]) {
            [self ios_ad_manage];
        }
        
    }
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
        if (code == 1) {
            NSString *title = [responseObject objectForKey:@"title"];
            NSString *message = [responseObject objectForKey:@"message"];
            NSString *downloadurl = [responseObject objectForKey:@"download_url"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self downLoad:title message:message downloadurl:downloadurl];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)downLoad:(NSString *)title message:(NSString *)message downloadurl:(NSString *)downloadurl{
    LNAlertView *lnalertView = [[LNAlertView alloc]initWithTitle:title message: message cancelButtonTitle:@"取消"];
    [lnalertView addDefaultStyleButtonWithTitle:@"去下载" handler:^(LNAlertView *alertView, LNAlertButtonItem *buttonItem) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadurl]];
        [alertView dismiss];
        
    }];
    
    [lnalertView show];
}
- (void)showSVPressHUB:(NSString *)info{
    [SVProgressHUD showInfoWithStatus:info];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [SVProgressHUD dismiss];
        // Do something...
        
    });
}
- (void)signInView{
    _sign = [[SignImageView alloc]initWithLableString:@"阅读红包"];
    _sign.delegate = self;
    NSString *urlStr = [NSString stringWithFormat:@"%@",self.aUrl];
    [_sign showViewController:self type:@"2" info:urlStr];
    _sign.hidden = YES;
}
- (void)showSignOrBag:(NSString *)type{
    NSString *urlStr = [NSString stringWithFormat:@"%@-webShare",self.aUrl];
    if ([UserDefaultObjectForKey(urlStr) isEqualToString:@"ok"]) {
        return;
    }
    [self redEnvelopeView];
}
- (void)removeFrom{
    NSLog(@"123");
}
#pragma mark- 分享
- (void)shareToWX{
    isNotTopShare = YES;
    [self systemShare];
//    [self shareView];
}
- (void)topShare{
    isNotTopShare = YES;
   
           [self systemShare];

}
//系统方法
- (void)systemShare{
   
    UIImage *imageToShare = [UIImage imageNamed:@"Icon-Spotlight-40"];
    
        NSURL *image_url = [NSURL URLWithString:_image_url];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:image_url]];
    if (image) {
        imageToShare = [UIImage compressOriginalImage:image toMaxDataSizeKBytes:64.0];
    }
    
    
    NSString *url = [NSString stringWithFormat:@"%@?stype=share",self.aUrl];
    NSURL *urlToShare = [NSURL URLWithString:url];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:@[imageToShare,urlToShare]
                                                        applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact,UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks,UIActivityTypePostToVimeo,
                                                     UIActivityTypePrint];
    [self presentViewController:activityViewController animated:YES completion:nil];
    activityViewController.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        if (completed) {
            
            
            if ([activityType isEqualToString:@"com.tencent.xin.sharetimeline"]) {
                NSString *urlStr = [NSString stringWithFormat:@"%@-share",self.aUrl];
                NSString *rob = UserDefaultObjectForKey(urlStr);
                 int counts = [[HRSettings sharedInstance].countNumber intValue];
                if (isNotTopShare && (counts < 6)&![rob isEqualToString:@"ok"]) {
                    int counts = [[HRSettings sharedInstance].countNumber intValue];
                    counts += 1;
                    NSNumber *countNumber = [NSNumber numberWithInt:counts];
                    [HRSettings sharedInstance].countNumber = countNumber;
                    for (UIView *view in alertViews.subviews) {
                        [view removeFromSuperview];
                    }
                    
                    NSString *urlStr = [NSString stringWithFormat:@"%@-share",self.aUrl];
                    RedEnvelopeView *red = [[RedEnvelopeView alloc]init];
                    red.delegate = self;
                    [red showType:RobRedEnvelopShare info:urlStr];
                    [MobClick event:@"文章分享后点击红包"];
                }

            }
           
        }
    };
}




//自定义分享面板

- (void)shareView{
    __weak typeof(self) weakSelf = self;
    
    // 创建代表每个按钮的模型
    ZYShareItem *item0 = [ZYShareItem itemWithTitle:@"发送给朋友"
                                               icon:@"Action_Share"
                                            handler:^{ [weakSelf shareFriends]; }];
    
    ZYShareItem *item1 = [ZYShareItem itemWithTitle:@"分享到朋友圈"
                                               icon:@"Action_Moments"
                                            handler:^{ [weakSelf shareCircleOfFriends]; }];
    NSArray *shareItemsArray = @[item0, item1];
    //    NSArray *functionItemsArray = @[item6, item7, item8, item9];
    
    // 创建shareView
    ZYShareView *shareView = [ZYShareView shareViewWithShareItems:shareItemsArray
                                                    functionItems:nil];
    // 弹出shareView
    [shareView show];
}





- (void)shareFriends{
    NSString *url = [NSString stringWithFormat:@"%@",self.aUrl];
    [WXApiRequestHandler sendLinkURL:url TagName:nil Title:webTitle Description:nil ThumbImage:nil InScene:WXSceneSession];
}
- (void)shareCircleOfFriends{
    NSString *url = [NSString stringWithFormat:@"%@",self.aUrl];
    [WXApiRequestHandler sendLinkURL:url TagName:nil Title:webTitle Description:nil ThumbImage:nil InScene:WXSceneTimeline];
}


- (void)alert{
    
    NSString *nowDay = [NSString stringWithFormat:@"%@-webShare",[NSDate redDateForEveryday]];
    NSNumber *number = UserDefaultObjectForKey(nowDay);
    int c = [number intValue];
    if (!alertViews&&c<6) {
        alertViews = [[HRAlertView alloc] initWithTitle:nil message:@"分享到微信领取红包" delegate:self andButtons:@[@"微信", @"朋友圈",@"取消"]];
        [alertViews show];
    }
    
}
- (void)popAlertView:(HRAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *url = [NSString stringWithFormat:@"%@",self.aUrl];
    if (buttonIndex==0) {
        //        [MobClick event:@"文章领取了红包后分享微信"];
        [WXApiRequestHandler sendLinkURL:url TagName:nil Title:webTitle Description:nil ThumbImage:nil InScene:WXSceneSession];
    }else if(buttonIndex == 1){
        [WXApiRequestHandler sendLinkURL:url TagName:nil Title:webTitle Description:nil ThumbImage:nil InScene:WXSceneTimeline];
        //     [MobClick event:@"文章领取了红包后分享朋友圈"];
    }
}
- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response{
    
    if (response.errCode == WXSuccess) {
        
        NSNumber *number = [NSNumber numberWithInt:count];
        NSString *nowDay = [NSString stringWithFormat:@"%@-webShare",[NSDate redDateForEveryday]];
        count = [number intValue];
        count += 1;
        UserDefaultSetObjectForKey(number, nowDay);
        for (UIView *view in alertViews.subviews) {
            [view removeFromSuperview];
        }
        [alertViews removeFromSuperview];
        NSString *urlStr = [NSString stringWithFormat:@"%@-share",self.aUrl];
        RedEnvelopeView *red = [[RedEnvelopeView alloc]init];
        [red showType:RobRedEnvelopShare info:urlStr];
        red.delegate = self;
        [MobClick event:@"文章分享后点击红包"];
    }
    
}

#pragma mark --广告
//插页广告
- (void)campaignPrepare{
    self.interstitial = [[GADInterstitial alloc]initWithAdUnitID:news_ad_campaign_id];
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
    bannerView.adUnitID = news_ad_banner_id;
    [bannerView loadRequest:[GADRequest request]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [adTimer invalidate];
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)dealloc {
    
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
    NSLog(@"i am dealloc");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
