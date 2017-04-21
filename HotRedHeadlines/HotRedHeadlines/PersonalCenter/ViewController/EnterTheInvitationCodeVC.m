//
//  EnterTheInvitationCodeVC.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/7.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "EnterTheInvitationCodeVC.h"
#import "KBRoundedButton.h"
#import <TYAttributedLabel.h>
#import "NewsViewController.h"
#import "HRUtilts.h"
#import "HRNetworkTools.h"
@interface EnterTheInvitationCodeVC ()
@property (strong, nonatomic)  UIScrollView *backgroundScrollerview;
@property (nonatomic,strong) UITextField *subTextField;
@property (nonatomic,strong) KBRoundedButton *subBtn;

@end

@implementation EnterTheInvitationCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"输入邀请码";
    UIColor *color = [UIColor colorWithHexString:@"#FF5645"];
    NSDictionary *dics = [NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = dics;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)initUI{
    self.backgroundScrollerview = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.backgroundScrollerview.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self.view addSubview:self.backgroundScrollerview];
    UIView *submitCodeBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180*kScale)];
    submitCodeBackView.backgroundColor = [UIColor whiteColor];
    [self.backgroundScrollerview addSubview:submitCodeBackView];
    UILabel *tipLable = [self createLable:@"输入好友邀请码:" fontSize:14 textColor:@"#333333" frame:CGRectMake(14, 14, kScreenWidth - 28, 14)];
    [submitCodeBackView addSubview:tipLable];
    
    _subTextField = [[UITextField alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(tipLable.frame) +14, CGRectGetWidth(tipLable.frame), 40)];
    _subTextField.placeholder = @"填写他人邀请码（向他人索要）";
    _subTextField.layer.borderWidth = 0.5;
    _subTextField.layer.borderColor = RGBA(217, 217, 217, 1).CGColor;
    _subTextField.layer.masksToBounds = YES;
    _subTextField.layer.cornerRadius = 3;
    [submitCodeBackView addSubview:_subTextField];
    
    _subBtn = [[KBRoundedButton alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(_subTextField.frame)+17, CGRectGetWidth(_subTextField.frame), 50)];
    _subBtn.backgroundColorForStateNormal = [UIColor redColor];
    [_subBtn setTitle:@"提交邀请码" forState:UIControlStateNormal];
    [_subBtn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [submitCodeBackView addSubview:_subBtn];
    if ([UserDefaultObjectForKey(@"invite_sucess") isEqualToString:@"sucess"]) {
        _subBtn.userInteractionEnabled = NO;
        _subBtn.backgroundColorForStateNormal = [UIColor grayColor];
    }
    UIView *enterCodeBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 194*kScale, kScreenWidth, CGRectGetHeight(self.backgroundScrollerview.frame) -194*kScale)];
    enterCodeBackView.backgroundColor = [UIColor whiteColor];
    [self.backgroundScrollerview addSubview:enterCodeBackView];
    UIImageView *codeMoney = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120*kScale, 80)];
    codeMoney.image = [UIImage imageNamed:@"codeMoney"];
    codeMoney.center = CGPointMake(kScreenWidth/2, 60*kScale);
    [enterCodeBackView addSubview:codeMoney];
    TYAttributedLabel *label = [[TYAttributedLabel alloc]initWithFrame:CGRectMake(37, CGRectGetMaxY(codeMoney.frame)+10,kScreenWidth-74, 0)];
    [enterCodeBackView addSubview:label];
    NSString *text = @"邀请好友赚翻天\n邀请好友赚“1000金币”奖励";
    label.text = text;
    label.textAlignment = kCTTextAlignmentCenter;
    // 文字间隙
    label.characterSpacing = 2;
    // 文本行间隙
    label.linesSpacing = 6;
    NSArray *arr = @[@"邀请好友赚翻天",@"1000金币"];
    for (NSString *str in arr) {
        TYTextStorage* textStorage = [[TYTextStorage alloc]init];
        textStorage.range = [text rangeOfString:str];
        textStorage.textColor = [UIColor colorWithHexString:@"#F5A623"];
        textStorage.font = [UIFont systemFontOfSize:18];
        [label addTextStorage:textStorage];
    }
   [label sizeToFit];

    KBRoundedButton *inviteBtn = [[KBRoundedButton alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(label.frame)+20, CGRectGetWidth(_subTextField.frame), 50)];
    inviteBtn.backgroundColorForStateNormal = [UIColor  colorWithHexString:@"#F5A623"];
    [inviteBtn setTitle:@"邀请好友去赚钱" forState:UIControlStateNormal];
    [inviteBtn addTarget:self action:@selector(inviteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
   
    [enterCodeBackView addSubview:inviteBtn];
    
}
- (void)subBtnAction:(KBRoundedButton *)sender{
    NSNumber *inviteCode = UserDefaultObjectForKey(USER_CODE);
    NSString *invite_code = [NSString stringWithFormat:@"%@",inviteCode];
    if (_subTextField.text.length <= 0) {
        [self showSVPressHUB:@"请输入邀请码"];
        return;
    }
    
    if ([invite_code isEqualToString:_subTextField.text]) {
        [self showSVPressHUB:@"请不要输入自己的邀请码"];
        return;
    }
    
    sender.working = YES;
    __weak EnterTheInvitationCodeVC *weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@/user/invite",RED_ENVELOP_HOST_NAME];
    NSDictionary *userInfo = UserDefaultObjectForKey(@"userInfo");
    HRUtilts *utilts = [[HRUtilts alloc]init];
    NSString *idfa = [utilts idfa];
    NSString *verify = [utilts verify];
    NSString *unionid = [userInfo objectForKey:@"unionid"];
    NSString *openid = [userInfo objectForKey:@"openid"];
    
    NSString *weixinId = unionid ?unionid:openid;
    
    NSDictionary *parameters = @{@"idfa":idfa,@"verify":verify,@"weixin_id":weixinId,@"be_invite_code":_subTextField.text};
    [[HRNetworkTools sharedNetworkTools]POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            sender.working = NO;
            NSNumber *numberCode = [responseObject objectForKey:@"code"];
            NSString *message = [responseObject objectForKey:@"msg"];
            NSInteger code = [numberCode integerValue];
            [weakSelf.subTextField resignFirstResponder];
            if (code == 1) {
                UserDefaultSetObjectForKey(@"sucess", @"invite_sucess");
                _subBtn.userInteractionEnabled = NO;
                _subBtn.backgroundColorForStateNormal = [UIColor grayColor];
                NSNumber *inviteCode = [responseObject objectForKey:@"invite_code"];
                UserDefaultSetObjectForKey(inviteCode, USER_CODE);
                [weakSelf showSVPressHUB:message];
                
            }else if (code == 0){
                [weakSelf showSVPressHUB:message];
            }
            
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    NSLog(@"提交邀请码");
}
- (void)showSVPressHUB:(NSString *)info{
    [SVProgressHUD showInfoWithStatus:info];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      
        [SVProgressHUD dismiss];
        // Do something...
        
    });
}
- (void)inviteBtnAction:(id)sender{
    self.tabBarController.selectedIndex = 2;
    NSLog(@"邀请好友去赚钱");
}
- (UILabel *)createLable:(NSString *)text fontSize:(CGFloat)font textColor:(NSString *)textColor frame:(CGRect)frame{
    UILabel *lable = [[UILabel alloc]initWithFrame:frame];
    lable.text = text;
    lable.font = [UIFont systemFontOfSize:font];
    lable.textColor = [UIColor colorWithHexString:textColor];
    return lable;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_subTextField resignFirstResponder];
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
