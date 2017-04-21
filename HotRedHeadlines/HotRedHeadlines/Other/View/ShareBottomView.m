//
//  ShareBottomView.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/6.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "ShareBottomView.h"

@interface ShareBottomView ()

@end
@implementation ShareBottomView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#3b424c"];
        UITapGestureRecognizer *sharTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareTapAction:)];
        [self addGestureRecognizer:sharTap];
        [self initUI];
    }
    return self;
}
- (void)initUI{
    UIImageView *tipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 20, 20)];
    tipImageView.image = [UIImage imageNamed:@"shareTip"];
    [self addSubview:tipImageView];
    tipImageView.center = CGPointMake(15, 20);
    UILabel *tipLable = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 120*kScale, 40)];
    tipLable.text = @"分享本文有机会获得100+金币";
    tipLable.textColor = [UIColor whiteColor];
    tipLable.font = [UIFont systemFontOfSize:14];
    [self addSubview:tipLable];
    
    [tipLable sizeToFit];
    tipLable.center = CGPointMake(40+tipLable.frame.size.width/2, 20);
    UILabel *shareLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 120, 0, 110, 30)];
    shareLable.textColor = [UIColor blackColor];
    shareLable.font = [UIFont systemFontOfSize:14];
    shareLable.text = @"立即分享";
    shareLable.textAlignment = NSTextAlignmentCenter;
    shareLable.backgroundColor = [UIColor colorWithHexString:@"#df3121"];
    [self addSubview:shareLable];
    shareLable.center = CGPointMake(kScreenWidth - 65, 20);
    shareLable.layer.masksToBounds = YES;
    shareLable.layer.cornerRadius = 15;
}
- (void)shareTapAction:(UITapGestureRecognizer*)tap{
    [self.delegate shareToWX];
}


@end
