//
//  IncomeDetailTableViewCell.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/6.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "IncomeDetailTableViewCell.h"

@interface IncomeDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *goldLable;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end
@implementation IncomeDetailTableViewCell

- (void)awakeFromNib {
//    self.iconImageView.backgroundColor = [UIColor grayColor];
    [super awakeFromNib];
    // Initialization code
}
- (void)setContent:(NSDictionary *)dic{
    NSString *typeStr = [dic objectForKey:@"type"];
    if ([typeStr isEqualToString:@"0"]) {
        self.iconImageView.image = [UIImage imageNamed:@"detail_shouci_denglv"];
    }else if ([typeStr isEqualToString:@"1"]){
        self.iconImageView.image = [UIImage imageNamed:@"detail_fenxiang_wenzhang"];
    }else if ([typeStr isEqualToString:@"2"]){
      self.iconImageView.image = [UIImage imageNamed:@"detail_yuedu_wenzhang"];
    }else if ([typeStr isEqualToString:@"3"]){
       self.iconImageView.image = [UIImage imageNamed:@"detail_qiandao_hongbao"];
    }else if ([typeStr isEqualToString:@"4"]){
      self.iconImageView.image = [UIImage imageNamed:@"detail_yaoqing_hongbao"];
    }else if ([typeStr isEqualToString:@"5"]){
        self.iconImageView.image = [UIImage imageNamed:@"detail_pinglun_hongbao"];
    } else if ([typeStr isEqualToString:@"6"]){
        self.iconImageView.image = [UIImage imageNamed:@"detail_shiping_hongbao"];
    }else if ([typeStr isEqualToString:@"7"]){
        self.iconImageView.image = [UIImage imageNamed:@"renwuhongbao"];
    }
    
    self.titleLable.text = [dic objectForKey:@"describe"];
    self.goldLable.text = [NSString stringWithFormat:@"+%@金币",[dic objectForKey:@"number"]];
    self.timeLable.text = [dic objectForKey:@"time"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
