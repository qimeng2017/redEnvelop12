//
//  RedEnvelopeView.m
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/23.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "RedEnvelopeView.h"
#import "HRUtilts.h"
#import "NSObject+arc4arndom.h"
static NSInteger RedEnvelopeInteger = 6789;

@interface RedEnvelopeView ()<CAAnimationDelegate>
{
    CAAnimationGroup *m_pGroupAnimation;
}
@property (nonatomic, strong) NSString    *info;
@property (nonatomic)BOOL                isRobSuccess;
@property (nonatomic, strong) UIView      *cancleView;
@property (nonatomic, strong) UIImageView *cancleBtn;
@property (nonatomic, strong) UIImageView *tapImageView;
@property (nonatomic, strong) UILabel     *tipLables;

@end
@implementation RedEnvelopeView
- (instancetype)init{
    self = [super init];
    if (self) {
        self.tag = RedEnvelopeInteger;
        self.backgroundColor = [UIColor getColor:@"000000" alpha:0.3];
        self.frame = [[UIScreen mainScreen] bounds];
       
        self.cancleView = [[UIView alloc]init];
        self.cancleView.userInteractionEnabled = YES;
        UITapGestureRecognizer *canaleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleBtnAction:)];
        [self.cancleView addGestureRecognizer:canaleTap];
        [self addSubview:self.cancleView];
        self.cancleBtn = [[UIImageView alloc]init];
        self.cancleBtn.image = [UIImage imageNamed:@"close.png"];
        [self.cancleView addSubview:self.cancleBtn];
        
        
        
        self.imageView = [[UIImageView alloc]init];
        self.imageView.userInteractionEnabled = YES;
        self.imageView.image = [UIImage imageNamed:@"pic1we"];
        [self addSubview:self.imageView];
//        self.congratulationsL = [[UILabel alloc]init];
//        self.congratulationsL.numberOfLines = 0;
//        self.congratulationsL.text = @"得金币尽在红包头条";
//        self.congratulationsL.font = [UIFont systemFontOfSize:16];
//        self.congratulationsL.textAlignment = NSTextAlignmentCenter;
//        self.congratulationsL.textColor = [UIColor colorWithHexString:@"FFFFFF"];
//        self.congratulationsL.hidden = YES;
//        [self.imageView addSubview:self.congratulationsL];
        self.goldL = [[UILabel alloc]init];
        self.goldL.font = [UIFont systemFontOfSize:20];
        self.goldL.textAlignment = NSTextAlignmentCenter;
        self.goldL.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        self.goldL.hidden = YES;
        self.goldL.numberOfLines = 0;
        [self.imageView addSubview:self.goldL];
        
        self.tapImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cahihongbao"]];
        self.tapImageView.userInteractionEnabled = YES;
        [self.imageView addSubview:self.tapImageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self.tapImageView addGestureRecognizer:tap];
        
        self.tipLables = [[UILabel alloc]init];
        self.tipLables.font = [UIFont systemFontOfSize:18];
        self.tipLables.textAlignment = NSTextAlignmentCenter;
        self.tipLables.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        
        self.tipLables.numberOfLines = 0;
        [self.imageView addSubview:self.tipLables];
        NSDictionary *userInfo = UserDefaultObjectForKey(USER_REDBAG_INFO);
        NSArray *tips = [userInfo objectForKey:@"hongbao_message"];
        NSInteger index = [NSObject getRandomNum:0 to:tips.count];
        NSString *tipStr = [tips objectAtIndex:index];
        
        if (!tipStr) {
            //首次安装
           self.tipLables.text = @"得金币尽在红包头条";
        }else{
          self.tipLables.text = tipStr;
        }
        
        [self.tipLables sizeToFit];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.cancleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).with.offset(-69*kScale+self.cancleBtn.image.size.width/2);
        make.top.mas_equalTo(self.mas_top).with.offset(144*kScale);
        make.size.mas_equalTo(CGSizeMake(50*kScale, 50*kScale));
    }];
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.cancleView.mas_centerX);
        make.bottom.mas_equalTo(self.cancleView.mas_bottom);
        
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.cancleView.mas_bottom);
        
    }];

    [self.goldL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_top).with.offset(177*kScale);
        make.centerX.mas_equalTo(self.imageView.mas_centerX);
    }];
//    [self.congratulationsL mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(self.imageView.mas_bottom).with.offset(-10*kScale);
//            make.centerX.mas_equalTo(self.imageView.mas_centerX);
//        }];
    [self.tapImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.imageView.mas_centerX);
        make.centerY.mas_equalTo(self.imageView.mas_centerY).with.offset(35);
    }];
    [self.tipLables mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.imageView.mas_centerX);
        make.bottom.mas_equalTo(self.imageView.mas_bottom).with.offset(-20);
        
    }];
}



- (void)cancleBtnAction:(id)sender{
    _isRobSuccess = NO;
    [self remove];
    [self.delegate removeFrom:_type];
 
}





- (void)tapAction:(UITapGestureRecognizer *)tap{
    UIView *sender = tap.view;
   
    CAAnimation* myAnimationRotate = [self animationRotate];
    m_pGroupAnimation     = [CAAnimationGroup animation];
    
    m_pGroupAnimation.delegate              =self;
    
    m_pGroupAnimation.removedOnCompletion   =NO;
    
    m_pGroupAnimation.duration             = 0.8;
    
    m_pGroupAnimation.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    m_pGroupAnimation.repeatCount           = MAXFLOAT;//FLT_MAX;  //"forever";
    
    m_pGroupAnimation.fillMode              =kCAFillModeForwards;
    
    m_pGroupAnimation.animations             = [NSArray arrayWithObjects:myAnimationRotate,nil];
    [sender.layer addAnimation:m_pGroupAnimation forKey:@"animationRotate"];
        NSString *robType = [NSString stringWithFormat:@"%u",_type];
        [self red:robType];
        self.tapImageView.userInteractionEnabled = NO;
   
}
//请求
- (void)red:(NSString *)bagstType{
    HRUtilts *utilts = [[HRUtilts alloc]init];
    NSString *idfa = [utilts idfa];
    NSString *verify = [utilts verify];
    NSDictionary *userInfo = UserDefaultObjectForKey(@"userInfo");
    NSString *unionid = [userInfo objectForKey:@"unionid"];
    NSString *openid = [userInfo objectForKey:@"openid"];
    
    NSString *weixinId = unionid ?unionid:openid;
    NSString *urlStr = [NSString stringWithFormat:@"%@/hongbao_system/grant",RED_ENVELOP_HOST_NAME];
    NSDictionary *parameters = @{@"idfa":idfa,
                                 @"verify":verify,
                                 @"weixin_id":weixinId,
                                 @"bags_type":bagstType
                                 };
    __weak RedEnvelopeView *weakSelf = self;
   AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSString *status = [responseObject objectForKey:@"status"];
            if ([status isEqualToString:@"0"]) {
                [weakSelf.tapImageView.layer removeAllAnimations];
                weakSelf.tapImageView.hidden = YES;
                weakSelf.goldL.hidden = NO;
                weakSelf.goldL.text = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"info"]];
                [weakSelf.goldL sizeToFit];
                weakSelf.isRobSuccess = YES;
                UserDefaultSetObjectForKey(@"ok", weakSelf.info);
                [self.delegate robSucess:weakSelf.type];
            }else if ([status isEqualToString:@"-1"]){
                [self.delegate robSeverFailer];
            }
        }
        
        
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorCode = [NSString stringWithFormat:@"%ld",(long)error.code];
        //是否以5开头的错误
        if ([errorCode hasPrefix:@"5"]||[errorCode hasPrefix:@"-1004"]) {
            [self.delegate robSeverFailer];
        }
        NSLog(@"%@",error);
    }];
}




- (void)showType:(RobRedEnvelopType)type info:(NSString *)info{
    _type = type;
    _info = info;
    
 
    if (!self.superview) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
        self.center = CGPointMake(CGRectGetMidX(keyWindow.bounds), CGRectGetMidY(keyWindow.bounds));
        [keyWindow addSubview:self];
        [keyWindow bringSubviewToFront:self];
        [self setTransform:CGAffineTransformMakeScale(0.5f, 0.5f)];
    }
    
    
    
    __weak RedEnvelopeView *weakSelf = self;
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    } completion:NULL];
    
}








- (void)remove{
    
    __weak RedEnvelopeView *weakSelf = self;
    [UIView animateWithDuration:.4f delay:.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.alpha = 0.f;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        
    }];
}







- (CAAnimation *)animationRotate

{
    
    //    UIButton *theButton = sender;
    
    // rotate animation
    
    CATransform3D rotationTransform  = CATransform3DMakeRotation(M_PI, 0, 1,0);
    
    
    
    CABasicAnimation* animation;
    
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    
    
    animation.toValue        = [NSValue valueWithCATransform3D:rotationTransform];
    
    animation.duration        =0.2;
    
    animation.autoreverses    = YES;
    
    animation.cumulative    = YES;
    
    animation.repeatCount    = MAXFLOAT;
    
    animation.beginTime        = 0;
    
    animation.delegate        = self;
    return animation;
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag

{
    NSLog(@"完成");
    //todo
    
}
@end
