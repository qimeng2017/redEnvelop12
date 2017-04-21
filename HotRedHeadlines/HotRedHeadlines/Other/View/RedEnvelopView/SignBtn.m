//
//  SignBtn.m
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/25.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "SignBtn.h"
#import "UIColor+Utilts.h"
@interface SignBtn ()
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel  *dayLable;
@property (nonatomic, strong) UILabel  *goldLable;
@end
@implementation SignBtn
- (instancetype)initWithDay:(NSString *)day gold:(NSString *)gold width:(CGFloat)width{
    self = [super init];
    if (self) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setImage:[UIImage imageNamed:@"ico_nosign.png"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"ico_sign"] forState:UIControlStateSelected];
        [self addSubview:self.button];
        self.dayLable = [self buildLable:day];
        [self addSubview:self.dayLable];
        self.goldLable = [self buildLable:gold];
        [self addSubview:self.goldLable];
        CGFloat height = 50*kScale+self.dayLable.frame.size.height+self.goldLable.frame.size.height;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).with.offset(0);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(40*kScale, 40*kScale));
    }];
    [self.dayLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.button.mas_bottom).with.offset(4*kScale);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    [self.goldLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dayLable.mas_bottom).with.offset(6*kScale);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
}
- (UILabel *)buildLable:(NSString *)text{
    UILabel *lable = [[UILabel alloc]init];
    lable.text = text;
    lable.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    lable.font = [UIFont systemFontOfSize:9];
    [lable sizeToFit];
    return lable;
}
- (void)setIsSelected:(BOOL)isSelected{
    self.button.selected = isSelected;
    if (isSelected) {
        
        self.dayLable.textColor = [UIColor colorWithHexString:@"FFDC18"];
        self.goldLable.textColor = [UIColor colorWithHexString:@"FFDC18"];
    }else{
        self.dayLable.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        self.goldLable.textColor = [UIColor colorWithHexString:@"FFFFFF"];
    }
}


@end
