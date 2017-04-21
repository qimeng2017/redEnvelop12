//
//  SignInMainView.m
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/24.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "SignInMainView.h"
#import "SignBtn.h"
#import "NSDate+Formatter.h"
#import "HRUtilts.h"
#import "GoldCount.h"

#define Start_X 35.0f           // 第一个按钮的X坐标
#define Width_Space 15.0f        // 2个按钮之间的横间距

static NSInteger SignInMain = 256789;
@interface SignInMainView ()
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)NSMutableArray *selectedButtons;
@property (nonatomic,strong)NSMutableArray *normalButtons;
@property (nonatomic,strong)UIButton *signBtn;
@property (nonatomic,strong)SignBtn *dayGoldBtn;

@property (nonatomic)GoldCount*goldCount;
@end
@implementation SignInMainView
- (instancetype)init{
    self = [super init];
    if (self) {
        self.tag = SignInMain;
        self.selectedButtons = [NSMutableArray array];
        self.normalButtons = [NSMutableArray array];
        self.backgroundColor = [UIColor getColor:@"000000" alpha:0.3];
        self.frame = [[UIScreen mainScreen] bounds];
        self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic5.png"]];
        self.imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self.imageView addGestureRecognizer:tap];
        [self addSubview:self.imageView];
        
        self.signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.signBtn setImage:[UIImage imageNamed:@"ico_nosignbtn.png"] forState:UIControlStateNormal];
        [self.signBtn setImage:[UIImage imageNamed:@"ico_signed.png"] forState:UIControlStateSelected];
        [self.signBtn addTarget:self action:@selector(signBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.signBtn];
        _goldCount = [[GoldCount alloc]init];
        _goldCount.count = 0;
        [_goldCount addObserver:self forKeyPath:@"count" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        NSArray *arr = @[@{@"day":@"1天",@"gold":@"10金币"},
                         @{@"day":@"2天",@"gold":@"20金币"},
                         @{@"day":@"3天",@"gold":@"30金币"},
                         @{@"day":@"4天",@"gold":@"40金币"},
                         @{@"day":@"5天",@"gold":@"50金币"},
                         @{@"day":@"6天",@"gold":@"60金币"},
                         @{@"day":@"7天",@"gold":@"70金币"}
                         ];
        
        CGFloat width = (self.frame.size.width - 160*kScale)/7;
        for (NSInteger i = 0; i< 7; i++) {
            NSDictionary *dic = [arr objectAtIndex:i];
            NSString *day = [dic objectForKey:@"day"];
            NSString *gold = [dic objectForKey:@"gold"];
            _dayGoldBtn = [[SignBtn alloc]initWithDay:day gold:gold width:width];
            _dayGoldBtn.tag = 100+i;
            [self addSubview:_dayGoldBtn];
            
        }
    }
    return self;
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    CGPoint pp=[tap locationInView:self];
    if (pp.y >70*kScale&&pp.x>kScreenWidth/2&&pp.y< kScreenHeight/2) {
        [self remove];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"count"] && object == _goldCount) {
        [self signSelected:_goldCount.count];
    }
}
- (void)signSelected:(int)count{
    for (int i= 0; i<count; i++) {
        SignBtn *view = (SignBtn *)[self viewWithTag:100+i];
        view.isSelected = YES;
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).with.offset(76*kScale);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    [self.signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.imageView);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    CGFloat width = (self.imageView.frame.size.width - 160*kScale)/7;
    for (__block NSInteger i=0; i<7; i++) {
        UIView *view = [self viewWithTag:100+i];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).with.offset(Start_X*kScale+i*(width+Width_Space*kScale));
            make.top.mas_equalTo(self.signBtn.mas_bottom).with.offset(25*kScale);
        }];
    }
    
}
- (void)signBtnAction:(UIButton *)sender{
    _goldCount.count +=1;
    NSString *sign_day = [NSString stringWithFormat:@"%d",_goldCount.count];
    HRUtilts *utilts = [[HRUtilts alloc]init];
    NSString *idfa = [utilts idfa];
    NSString *verify = [utilts verify];
    NSDictionary *userInfo = UserDefaultObjectForKey(@"userInfo");
    NSString *unionid = [userInfo objectForKey:@"unionid"];
    NSString *openid = [userInfo objectForKey:@"openid"];
    
    NSString *weixinId = unionid ?unionid:openid;
    NSString *urlStr = [NSString stringWithFormat:@"%@/hongbao_system/grant",RED_ENVELOP_HOST_NAME];
    NSDictionary *parameters = @{@"idfa":idfa,@"verify":verify,@"weixin_id":weixinId,@"bags_type":@"3",@"sign_day":sign_day};
    __weak SignInMainView *weakSelf = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSString *status = [responseObject objectForKey:@"status"];
            if ([status isEqualToString:@"0"]) {
                sender.selected = YES;
                sender.userInteractionEnabled = NO;
                NSString *nowDay = [NSString stringWithFormat:@"%@-sign",[NSDate redDateForEveryday]];
                UserDefaultSetObjectForKey(@"sign", nowDay);
                NSNumber *number = [NSNumber numberWithInt:weakSelf.goldCount.count];
                UserDefaultSetObjectForKey(number, @"signCount");
           
                
            }
        }
        [self.delegate signSucess];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}






- (void)showType:(NSString *)type info:(NSString *)info{
    NSDate *date = [NSDate date];
    NSString *weak = [NSDate weekdayStringFromDate:date];
    if ([weak isEqualToString:@"星期一"]) {
        //星期一：判断是否签到过
        NSString *nowDay = [NSString stringWithFormat:@"%@-sign",[NSDate redDateForEveryday]];
        NSString *isSign = UserDefaultObjectForKey(nowDay);
        if ([isSign isEqualToString:@"sign"]) {
            NSNumber *number = UserDefaultObjectForKey(@"signCount");
            _goldCount.count = [number intValue];
        }else{
           _goldCount.count = 0;
            NSNumber *number = [NSNumber numberWithInt:0];
            UserDefaultSetObjectForKey(number, @"signCount");
        }
        
        
    }else{
        NSNumber *number = UserDefaultObjectForKey(@"signCount");
        _goldCount.count = [number intValue];
        if (_goldCount.count>0) {
            [self signSelected:_goldCount.count];
        }
        
    }
    
    NSString *nowDay = [NSString stringWithFormat:@"%@-sign",[NSDate redDateForEveryday]];
    NSString *isSign = UserDefaultObjectForKey(nowDay);
    
    if ([isSign isEqualToString:@"sign"]) {
        _signBtn.selected = YES;
        _signBtn.userInteractionEnabled = NO;
    }else{
        _signBtn.selected = NO;
        _signBtn.userInteractionEnabled = YES;
    }
    
    if (!self.superview) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
        self.center = CGPointMake(CGRectGetMidX(keyWindow.bounds), CGRectGetMidY(keyWindow.bounds));
        [keyWindow addSubview:self];
        [keyWindow bringSubviewToFront:self];
        [self setTransform:CGAffineTransformMakeScale(0.5f, 0.5f)];
    }
    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    __weak SignInMainView *weakSelf = self;
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    } completion:NULL];
    
}
- (void)dealloc{
    [_goldCount removeObserver:self forKeyPath:@"count" context:nil];
}
- (void)remove{
    
    __weak SignInMainView *weakSelf = self;
    [UIView animateWithDuration:.4f delay:.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.alpha = 0.f;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        
    }];
}
@end
