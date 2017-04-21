//
//  UserInfoCells.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/6.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "UserInfoCells.h"

@interface UserInfoCells ()
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLable;
@property (weak, nonatomic) IBOutlet UILabel *goldLable;
@property (weak, nonatomic) IBOutlet UILabel *moneyLable;

@end
@implementation UserInfoCells



- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avaterImageView.layer.masksToBounds = YES;
    self.avaterImageView.layer.cornerRadius = self.avaterImageView.frame.size.height/2;
    self.avaterImageView.center = CGPointMake(kScreenWidth/2, 60*kScale);
    self.nickNameLable.center = CGPointMake(kScreenWidth/2, CGRectGetMaxY(self.avaterImageView.frame) +21*kScale);
    self.avaterImageView.backgroundColor = [UIColor grayColor];
    self.goldLable.text = @"0";
    // Initialization code
}

- (void)setUserInfo:(NSDictionary *)userInof gold:(NSString *)gold money:(NSString *)money{
    self.avaterImageView.hidden = NO;
    [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:[userInof objectForKey:@"headimgurl"]] placeholderImage:[UIImage imageNamed:@"pic1"]];
    self.nickNameLable.text = [userInof objectForKey:@"nickname"];
    
    self.goldLable.text = gold;
    float moneys = [gold floatValue];
    self.moneyLable.text = [NSString stringWithFormat:@"%.2f元",moneys/1000];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
