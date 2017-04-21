//
//  WithdrawalRecordCellTableViewCell.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/12.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "WithdrawalRecordCellTableViewCell.h"
#import "NSDate+Formatter.h"
@interface WithdrawalRecordCellTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *accountLable;
@property (weak, nonatomic) IBOutlet UILabel *moneyLable;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *statusLable;

@end
@implementation WithdrawalRecordCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    // Initialization code
}

- (void)setContentDict:(NSDictionary *)contentDict{
    _contentDict = contentDict;
    NSNumber *cash_moneyNumber = [contentDict objectForKey:@"cash_money"];
    self.moneyLable.text = [NSString stringWithFormat:@"%@元",cash_moneyNumber];
    NSNumber *timeNumber = [contentDict objectForKey:@"time"];
    if (![timeNumber isKindOfClass:[NSNull class]]) {
        NSTimeInterval time = [timeNumber doubleValue];
        NSString  *timeStr = [NSDate timeStamp:time];
        self.timeLable.text = timeStr;
    }
    
    self.statusLable.text = [contentDict objectForKey:@"status"];
    NSNumber *status_code_number = [contentDict objectForKey:@"status_code"];
    NSInteger status_code = [status_code_number integerValue];
    if (status_code==0) {
        self.statusLable.textColor = RGBA(241, 197, 47, 1);
    }else if (status_code==1){
        self.statusLable.textColor = [UIColor greenColor];
    }else{
        self.statusLable.textColor = [UIColor redColor];
    }
    
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self.delegate didSelectView:self content:_contentDict];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
