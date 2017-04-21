//
//  SignImageView.m
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "SignImageView.h"
static NSInteger ignImageView = 456789;
@interface SignImageView ()
@property (nonatomic, strong)NSString    *type;
@property (nonatomic, strong)NSString    *info;
@property (nonatomic, strong)UIImageView *cancleBtn;
@property (nonatomic, strong)UILabel     *bagLable;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIView      *cancleView;
@end
@implementation SignImageView

- (instancetype)initWithLableString:(NSString *)string{
    self = [super init];
    if (self) {
        self.tag = ignImageView;
        self.cancleView = [[UIView alloc]init];
        self.cancleView.userInteractionEnabled = YES;
        UITapGestureRecognizer *canaleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleBtnAction:)];
        [self.cancleView addGestureRecognizer:canaleTap];
        [self addSubview:self.cancleView];
        self.cancleBtn = [[UIImageView alloc]init];
        self.cancleBtn.image = [UIImage imageNamed:@"close_small.png"];
        [self.cancleView addSubview:self.cancleBtn];
        
        self.imageView = [[UIImageView alloc]init];
        self.imageView.userInteractionEnabled = YES;
        self.imageView.image = [UIImage imageNamed:@"pic4.png"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(robRedAction:)];
        [self.imageView addGestureRecognizer:tap];
        [self addSubview:self.imageView];
        self.bagLable = [[UILabel alloc]init];
        self.bagLable.text = string;
        self.bagLable.font = [UIFont systemFontOfSize:14];
        self.bagLable.textColor = [UIColor whiteColor];
        
        [self.imageView addSubview:self.bagLable];
        [self.bagLable sizeToFit];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.cancleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.imageView.mas_top);
        make.size.mas_equalTo(CGSizeMake(40*kScale, 40*kScale));
    }];
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.cancleView.mas_right).with.offset(self.cancleBtn.image.size.width/2);
        make.bottom.mas_equalTo(self.cancleView.mas_bottom);
        
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [self.bagLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.imageView.mas_centerX);
        make.top.mas_equalTo(self.imageView.mas_top).with.offset(self.imageView.image.size.height/2);
    }];
}
- (void)showViewController:(UIViewController *)VC type:(NSString *)type info:(NSString *)info{
    _type = type;
    _info = info;
    for (UIView *view in VC.view.subviews) {
        if (view.tag == ignImageView) {
            [view removeFromSuperview];
        }
    }
    
    [VC.view addSubview:self];
    [VC.view bringSubviewToFront:self];
   self.imageView.userInteractionEnabled = YES;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(VC.view.mas_right).with.offset(-10*kScale);
        make.bottom.mas_equalTo(VC.view.mas_bottom).with.offset(-100*kScale);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/3, kScreenHeight/4));
    }];
    [self setTransform:CGAffineTransformMakeScale(0.5f, 0.5f)];
    
    __weak SignImageView *weakSelf = self;
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    } completion:NULL];
}



- (void)robRedAction:(UITapGestureRecognizer *)tap{
    if (_type) {
        self.imageView.userInteractionEnabled = NO;
       [self.delegate showSignOrBag:_type];
    }
    
}
- (void)cancleBtnAction:(UITapGestureRecognizer *)sender{
    [self remove];
}
- (void)remove{
        __weak SignImageView *weakSelf = self;
    [UIView animateWithDuration:.4f delay:.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.alpha = 0.f;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        
    }];
}


@end
