//
//  HRTextfieldView.m
//  HotRed
//
//  Created by 邹壮壮 on 2016/12/1.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRTextfieldView.h"

@interface HRTextfieldView ()

@end
@implementation HRTextfieldView

- (instancetype)initWithFrame:(CGRect)frame desLableText:(NSString *)desLableText placeholder:(NSString *)placeholder isHidden:(BOOL)isHidden{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
       
        self.desLable.text = desLableText;
        self.desLable.textColor = [UIColor grayColor];
        self.desLable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.desLable];
        [self.desLable sizeToFit];
        
        self.textfield.placeholder = placeholder;
        self.textfield.textColor = [UIColor grayColor];
        self.textfield.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.textfield];
        
        self.contentLable.text = placeholder;
        self.contentLable.textColor = [UIColor grayColor];
        self.contentLable.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.contentLable];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithRed:229/255.f green:229/255.f blue:229/255.f alpha:1];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        [self.desLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).with.offset(10);
            make.top.mas_equalTo(self.mas_top).with.offset(0);
            make.bottom.mas_equalTo(line.mas_top);
        }];
        [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.desLable.mas_right);
            make.right.mas_equalTo(self.mas_right).with.offset(-10*kScale);
            make.top.mas_equalTo(self.mas_top).with.offset(0);
            make.bottom.mas_equalTo(line.mas_top);
        }];
        [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.desLable.mas_right);
            make.right.mas_equalTo(self.mas_right).with.offset(-10*kScale);
            make.top.mas_equalTo(self.mas_top).with.offset(0);
            make.bottom.mas_equalTo(line.mas_top);
        }];
        if (isHidden) {
            self.textfield.hidden = YES;
            self.contentLable.hidden = NO;
        }else{
            self.textfield.hidden = NO;
            self.contentLable.hidden = YES;
        }
    }
    return self;
}
- (UILabel *)contentLable{
    if (!_contentLable) {
        _contentLable = [[UILabel alloc]init];
    }
    return _contentLable;
}
- (UILabel *)desLable{
    if (!_desLable) {
        _desLable = [[UILabel alloc]init];
    }
    return _desLable;
}
- (UITextField *)textfield{
    if (!_textfield) {
        _textfield = [[UITextField alloc]init];
       
    }
    return _textfield;
}

@end
