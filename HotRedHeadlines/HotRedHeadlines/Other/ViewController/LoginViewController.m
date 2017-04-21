//
//  LoginViewController.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "LoginViewController.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "HRJudgeNetworking.h"
#import "HRSystem.h"
#import "HRNetworkTools.h"
#import "HRUtilts.h"
#import "HelpViewController.h"
#import "WXApi.h"

@interface LoginViewController ()<WXApiManagerDelegate,UITextFieldDelegate>
//登录
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton    *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton    *registeredBtn;
@property (weak, nonatomic) IBOutlet UIButton    *wxixinLoginBtn;
//注册
@property (weak, nonatomic) IBOutlet UITextField *regPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *regPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton    *completeRegBtn;
@property (nonatomic)BOOL                        isReg;
@property (weak, nonatomic) IBOutlet UILabel     *tipLable;
@property (nonatomic,assign) CGFloat             originY;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WXApiManager sharedManager].delegate = self;
    self.wxixinLoginBtn.layer.masksToBounds = YES;
   
    self.wxixinLoginBtn.layer.cornerRadius = 22.f;
    self.completeRegBtn.layer.masksToBounds = YES;
    self.completeRegBtn.layer.cornerRadius = 21.f;
    self.passwordTextField.delegate = self;
    self.phoneNumberTextField.delegate = self;
    self.regPasswordTextField.delegate = self;
    self.regPasswordTextField.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //隐藏键盘
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self AFNetworkReachabilityStatus];
    
}
#pragma mark -网络状态监测
- (void)AFNetworkReachabilityStatus{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"不可达的网络(未连接)");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [self auditSwitch];
                
                NSLog(@"2G,3G,4G...的网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                [self auditSwitch];
                
                NSLog(@"wifi的网络");
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
    
}
- (void)viewDidAppear:(BOOL)animated{
     _originY = self.view.frame.origin.y;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)helpAction:(id)sender {
    HelpViewController *helpVC = [[HelpViewController alloc]init];
    helpVC.from = @"login";
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:helpVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response{
    if (response.code) {
      [self getAccess_token:response.code];
    }else{
        NSLog(@"登录失败");
    }
}
#pragma mark - 登录按钮事件
- (IBAction)loginAction:(id)sender {
    if (self.passwordTextField.text.length > 0&&self.phoneNumberTextField.text.length > 0 ) {
      [self.delegate loginSucess:YES];
    }
    
}
- (IBAction)registeredAction:(id)sender {
    _isReg = YES;
    [self.phoneNumberTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    self.regPhoneTextField.hidden = self.regPasswordTextField.hidden = self.completeRegBtn.hidden = NO;
     self.phoneNumberTextField.hidden = self.passwordTextField.hidden = self.loginBtn.hidden=self.registeredBtn.hidden = YES;
}
- (IBAction)completeRegAction:(id)sender {
    if (self.regPhoneTextField.text.length > 0&&self.regPasswordTextField.text.length > 0 ) {
        [self.delegate loginSucess:YES];
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL isOK = YES;//记录用户输入是否合法
    if (_isReg) {
        if (textField!=self.regPhoneTextField&&self.regPhoneTextField.text.length==0) {
            isOK = false;
        }
    }else{
        
    }
    return YES;
}
#pragma mark 键盘
//当键盘将要显示时，将底部的view向上移到键盘的上面
-(void)keyboardWillShow:(NSNotification*)notification{
    //通过消息中的信息可以获取键盘的frame对象
    NSValue *keyboardObj = [[notification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    // 获取键盘的尺寸,也即是将NSValue转变为CGRect
    CGRect keyrect;
    [keyboardObj getValue:&keyrect];
    CGRect rect=self.view.frame;
    
    //如果键盘的高度大于底部控件到底部的高度，将_scrollView往上移 也即是：-（键盘的高度-底部的空隙）
    if (_isReg) {
        if (keyrect.size.height>kScreenHeight-_completeRegBtn.frame.origin.y-_completeRegBtn.frame.size.height) {
            rect.origin.y=-keyrect.size.height+(kScreenHeight-_completeRegBtn.frame.origin.y-_completeRegBtn.frame.size.height);
            self.view.frame = rect;
        }
    }else{
        if (keyrect.size.height>kScreenHeight-_registeredBtn.frame.origin.y-_registeredBtn.frame.size.height) {
            rect.origin.y=-keyrect.size.height+(kScreenHeight-_registeredBtn.frame.origin.y-_registeredBtn.frame.size.height);
            self.view.frame = rect;
        }
    }
    
}

//当键盘将要隐藏时（将原来移到键盘上面的视图还原）
-(void)keyboardWillHide:(NSNotification *)notification{
    CGRect rect=self.view.frame;
    NSValue *keyboardObj = [[notification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    // 获取键盘的尺寸,也即是将NSValue转变为CGRect
    CGRect keyrect;
    [keyboardObj getValue:&keyrect];
    rect.origin.y= _originY;
    self.view.frame = rect;
}



#pragma mark -微信登录
- (IBAction)weixinLoginAction:(id)sender {
    if ([WXApi isWXAppInstalled]) {
        
       [WXApiRequestHandler sendAuthRequestScope:kAuthScope State:kAuthState OpenID:kAuthOpenID InViewController:self];
    }else{
        self.tipLable.hidden = NO;
    }
   
}
-(void)getAccess_token:(NSString *)code

{
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kAuthOpenID,kAuthOpensecret,code];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *zoneUrl = [NSURL URLWithString:url];
        
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                /*
                 
                 {
                 
                 "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
                 
                 "expires_in" = 7200;
                 
                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                 
                 "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
                 
                 scope = "snsapi_userinfo,snsapi_base";
                 
                 }
                 
                 */
                
                NSString * access_token = [dic objectForKey:@"access_token"];
                
                NSString *openid = [dic objectForKey:@"openid"];
                [self getUserInfo:access_token openid:openid];
            }
            
        });
        
    });
    
}
//三.根据第二步获取的token和openid来获取用户的相关信息

-(void)getUserInfo:(NSString *)token openid:(NSString *)openid

{
    
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *zoneUrl = [NSURL URLWithString:url];
        
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                /*
                 
                 {
                 
                 city = Haidian;
                 
                 country = CN;
                 
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 
                 language = "zh_CN";
                 
                 nickname = "xxx";
                 
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 
                 privilege =    (
                 
                 );
                 
                 province = Beijing;
                 
                 sex = 1;
                 
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 
                 }
                 
                 */
                
                
                
                UserDefaultSetObjectForKey(dic, @"userInfo");
                
                [self uploadUserInfo:dic];
//                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
            
        });
        
    });
    
}

#pragma mark -上传用户信息
- (void)uploadUserInfo:(NSDictionary *)userInfo{
    __weak LoginViewController *weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@/user/login",RED_ENVELOP_HOST_NAME];
    
    HRUtilts *utilts = [[HRUtilts alloc]init];
    NSString *idfa = [utilts idfa];
    NSString *verify = [utilts verify];
    NSString *unionid = [userInfo objectForKey:@"unionid"];
    NSString *openid = [userInfo objectForKey:@"openid"];
    
    NSString *weixinId = unionid ?unionid:openid;
    NSString *nickname = [userInfo objectForKey:@"nickname"];
    NSDictionary *parameters = @{@"idfa":idfa,@"verify":verify,@"weixin_id":weixinId,@"nickname":nickname};
    [[HRNetworkTools sharedNetworkTools]POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSNumber *numberCode = [responseObject objectForKey:@"code"];
            NSInteger code = [numberCode integerValue];
            [weakSelf.delegate loginSucess:NO];
            if (code == 1) {
               
            }else{
                
            }
            
        }
        
      
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}
#pragma mark--审核开关
- (void)auditSwitch{
     __weak LoginViewController *weakSelf = self;
    NSDictionary *parameters = @{@"appid":appid,@"stype":stype};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"%@/review_status",RED_ENVELOP_HOST_NAME];
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSString *sucess = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
            if ([sucess isEqualToString:@"1"]){
                UserDefaultSetObjectForKey(@"noreview", REVIEW_THE_STATUS);
                weakSelf.wxixinLoginBtn.hidden = YES;
                if (_isReg){
                    weakSelf.completeRegBtn.hidden=weakSelf.regPhoneTextField.hidden = weakSelf.regPasswordTextField.hidden = NO;
                    weakSelf.phoneNumberTextField.hidden = weakSelf.passwordTextField.hidden = weakSelf.loginBtn.hidden=weakSelf.registeredBtn.hidden = YES;
                }else{
                 weakSelf.phoneNumberTextField.hidden = weakSelf.passwordTextField.hidden = weakSelf.loginBtn.hidden=weakSelf.registeredBtn.hidden = NO;
                    
                    weakSelf.completeRegBtn.hidden=weakSelf.regPhoneTextField.hidden = weakSelf.regPasswordTextField.hidden = YES;
                }
                
                [self defaultUser];
            
            }else{
                UserDefaultSetObjectForKey(@"review", REVIEW_THE_STATUS);
                weakSelf.wxixinLoginBtn.hidden = NO;
                weakSelf.phoneNumberTextField.hidden = weakSelf.passwordTextField.hidden = weakSelf.loginBtn.hidden=weakSelf.registeredBtn.hidden = YES;
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
//默认用户
- (void)defaultUser{
    NSDictionary *userInfo = @{
                               @"city" : @"Bengbu",
                               @"country" : @"CN",
                               @"headimgurl" : @"http://wx.qlogo.cn/mmopen/9xM3cXia6HVM0ibBtbbBmu1iaIDRdp0pNlqh0MkAnQjxItYUh09pz356kxZs67VGoJZ7XuyOQbCxbwrGLibugCEwwDxc5zzqDNY3/0",
                               @"language" : @"zh_CN",
                               @"nickname" : @"恰少年",
                               @"openid" : @"o_k0lwKRNQZXZ1mbc0yrixGkrM44",
                               @"province" : @"Anhui",
                               @"sex" : @1,
                               @"unionid" : @"oszDYvnjGoggsWTshIScOemfEHWU"
                               };
     UserDefaultSetObjectForKey(userInfo, USERINFO);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resignFirstResponders];
}
- (void)resignFirstResponders{
    if (_isReg) {
        [self.regPasswordTextField resignFirstResponder];
        [self.regPhoneTextField resignFirstResponder];
    }else{
        [self.phoneNumberTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
    }
  
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
