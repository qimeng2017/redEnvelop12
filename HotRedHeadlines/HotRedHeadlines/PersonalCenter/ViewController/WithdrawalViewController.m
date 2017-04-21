//
//  WithdrawalViewController.m
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/24.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "WithdrawalViewController.h"
#import "WithdrawaCollectionViewCell.h"

#import "HRTextfieldView.h"
#import "HRUtilts.h"
#import "WithdrawalViewController.h"
#import "KBRoundedButton.h"
@interface WithdrawalViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)HRTextfieldView *balance;
@property (nonatomic,strong)HRTextfieldView *PayTreasureName;
@property (nonatomic,strong)HRTextfieldView *PayTreasureAccount;
@property (nonatomic,strong)HRTextfieldView *confirmPayTreasure;
@property (nonatomic,strong)KBRoundedButton *submitBtn;

@property (nonatomic,assign)CGFloat originY;
@end

@implementation WithdrawalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现&兑换";
    self.view.backgroundColor = [UIColor colorWithRed:243/255.f green:243/255.f blue:243/255.f alpha:1];
    //键盘出现
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //隐藏键盘
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
   self.view.frame = CGRectMake(0, 64.f, kScreenWidth, kScreenHeight - 64.f);
    [self initUI];
    ADD_BACK(backAction);
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.frame = CGRectMake(0, 64.f, kScreenWidth, kScreenHeight - 64.f);
     _originY = 64.f;
    [_PayTreasureName.textfield becomeFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}
- (void)initUI{
    
    _balance = [[HRTextfieldView alloc]initWithFrame:CGRectMake(0, 20*kScale, kScreenWidth, 40*kScale) desLableText:@"余额" placeholder:@"5元" isHidden:YES];
    float money = [self.cash_gold floatValue];
    _balance.contentLable.text = [NSString stringWithFormat:@"%.2f元",money/1000];
    [self.view addSubview:_balance];
    _PayTreasureName = [[HRTextfieldView alloc]initWithFrame:CGRectMake(0, 20*kScale, kScreenWidth, 40*kScale) desLableText:@"支付宝账号姓名:" placeholder:@"请输入支付宝账号真实姓名" isHidden:NO];
    _PayTreasureName.textfield.delegate = self;
    [self.view addSubview:_PayTreasureName];
    _PayTreasureAccount = [[HRTextfieldView alloc]initWithFrame:CGRectMake(0, 20*kScale, kScreenWidth, 40*kScale) desLableText:@"支付宝账号:" placeholder:@"请输入支付宝账号" isHidden:NO];
    _PayTreasureAccount.textfield.delegate = self;
    [self.view addSubview:_PayTreasureAccount];
    _confirmPayTreasure = [[HRTextfieldView alloc]initWithFrame:CGRectMake(0, 20*kScale, kScreenWidth, 40*kScale) desLableText:@"确认支付宝账号:" placeholder:@"请确认支付宝账号" isHidden:NO];
    _confirmPayTreasure.textfield.delegate = self;
    [self.view addSubview:_confirmPayTreasure];
    _submitBtn = [[KBRoundedButton alloc]init];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitBtn.userInteractionEnabled = NO;
    _submitBtn.backgroundColor = [UIColor colorWithRed:191/255.0 green:192/255.0 blue:196/255.0 alpha:1.0];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.layer.cornerRadius = 6*kScale;
    [self.view addSubview:_submitBtn];
    
    [_balance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 40*kScale));
    }];
    [_PayTreasureName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_balance.mas_bottom).with.offset(30*kScale);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 40*kScale));
    }];
    [_PayTreasureAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_PayTreasureName.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 40*kScale));
    }];
    [_confirmPayTreasure mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.mas_equalTo(_PayTreasureAccount.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 40*kScale));
    }];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_confirmPayTreasure.mas_bottom).with.offset(40*kScale);
        make.left.mas_equalTo(self.view.mas_left).with.offset(30*kScale);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-30*kScale);
        make.height.mas_equalTo(60*kScale);
    }];
    
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
//    CGFloat width = (SCREEN_WIDTH - 40*kScale)/2;
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//    flowLayout.itemSize = CGSizeMake(width, width);
////    flowLayout.minimumLineSpacing = 20*kScale;
//    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
//    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, SCREEN_WIDTH) collectionViewLayout:flowLayout];
//    [self.collectionView setBackgroundColor:[UIColor clearColor]];
//    [self.collectionView registerClass:[WithdrawaCollectionViewCell class] forCellWithReuseIdentifier:@"cellids"];
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
//    [self.view addSubview:self.collectionView];
    
    
    
}

#pragma mark --提交数据
- (void)submitBtnAction:(KBRoundedButton *)sender{
      [self resignFirstResponders];
    __typeof(self) weakSelf = self;
    float gold = [_cash_gold floatValue];
    float money =gold/1000;
    if (![self.PayTreasureAccount.textfield.text isEqualToString:self.confirmPayTreasure.textfield.text]) {
        [self HUBshow:@"请确认账号是否正确" time:1.0];
        return;
    }
    if (money < 30) {
        [self HUBshow:@"金额大于30元才能提现哦~" time:5.0];
        return;
    }
    
    sender.working = YES;
    NSString *cashMoney = [NSString stringWithFormat:@"%.2f",money];
    NSString *goldS = [NSString stringWithFormat:@"%.f",gold];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    HRUtilts *utilts = [[HRUtilts alloc]init];
    NSString *idfa = [utilts idfa];
    NSString *verify = [utilts verify];
    NSDictionary *userInfo = UserDefaultObjectForKey(@"userInfo");
    NSString *unionid = [userInfo objectForKey:@"unionid"];
    NSString *openid = [userInfo objectForKey:@"openid"];
    
    NSString *weixinId = unionid ?unionid:openid;
    NSString *urlStr = [NSString stringWithFormat:@"%@/cash_system/alipay",RED_ENVELOP_HOST_NAME];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    NSDictionary *parameters = @{
                        @"idfa":idfa,
                        @"verify":verify,
                        @"weixin_id":weixinId,
                        @"full_name":_PayTreasureName.textfield.text,
                        @"alipay_account":_PayTreasureAccount.textfield.text,
                        @"cash_gold":goldS,
                        @"cash_money":cashMoney
                                 };
   [manager GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       if ([responseObject isKindOfClass:[NSDictionary class]]){
           NSString *message = [responseObject objectForKey:@"message"];
           sender.working = NO;
           dispatch_async(dispatch_get_main_queue(), ^{
              [weakSelf HUBshow:message time:3.0];
           });
           
       }
      
      
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSLog(@"err");
   }];
    
}
//提示信息
- (void)HUBshow:(NSString *)lableText time:(float)time{
    [SVProgressHUD  showInfoWithStatus:lableText];
    
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // Do something...
        [SVProgressHUD dismiss];
    });
}
//记录用户输入是否合法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL isOK = YES;
    if (textField!=self.PayTreasureName.textfield&&self.PayTreasureName.textfield.text.length==0) {
        isOK = false;
    }else if(textField!=self.PayTreasureAccount.textfield&&self.PayTreasureAccount.textfield.text.length==0){
        isOK = false;
    }else if(textField!=self.confirmPayTreasure.textfield&&self.confirmPayTreasure.textfield.text.length==0){
        isOK = false;
    }else if(range.location == 0&&[string isEqualToString:@""]){
        isOK = false;
    }
    
    if (isOK) {
        _submitBtn.userInteractionEnabled = YES;
        _submitBtn.backgroundColor = [UIColor greenColor];
    
    }else{
        _submitBtn.userInteractionEnabled = NO;
        _submitBtn.backgroundColor = [UIColor colorWithRed:191/255.0 green:192/255.0 blue:196/255.0 alpha:1.0];
    }
    
    return YES;
}
//当键盘将要显示时，将底部的view向上移到键盘的上面
-(void)keyboardWillShow:(NSNotification*)notification{
    //通过消息中的信息可以获取键盘的frame对象
    NSValue *keyboardObj = [[notification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    // 获取键盘的尺寸,也即是将NSValue转变为CGRect
    CGRect keyrect;
    [keyboardObj getValue:&keyrect];
    CGRect rect=self.view.frame;
    
    //如果键盘的高度大于底部控件到底部的高度，将_scrollView往上移 也即是：-（键盘的高度-底部的空隙）
    if (keyrect.size.height>kScreenHeight-_submitBtn.frame.origin.y-_submitBtn.frame.size.height) {
        rect.origin.y=-keyrect.size.height+(kScreenHeight-_submitBtn.frame.origin.y-_submitBtn.frame.size.height);
        self.view.frame = rect;
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












- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resignFirstResponders];
}
- (void)resignFirstResponders{
    [_PayTreasureName.textfield resignFirstResponder];
     [_PayTreasureAccount.textfield resignFirstResponder];
     [_confirmPayTreasure.textfield resignFirstResponder];
}





- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WithdrawaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellids" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    if (indexPath.item == 0) {
       [cell setContentImage:@"￥30红包"];
    }else{
       [cell setContentImage:@"￥50红包"]; 
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [SVProgressHUD showWithStatus:@"你的零钱不够！"];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      
        // Do something...
        [SVProgressHUD dismiss];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
