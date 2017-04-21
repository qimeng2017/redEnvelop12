//
//  InvitationHistoryCell.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/7.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "InvitationHistoryCell.h"
#define Start_X 24.0f           // 第一个lable的X坐标
#define Start_Y 0.0f           // 第一个lable的Y坐标
#define Width_Space 5.0f        // 2个lable之间的横间距
@interface InvitationHistoryCell ()
@property (nonatomic,strong)UILabel *serialNumberLable;
@property (nonatomic,strong)UILabel *nickNameLable;
@property (nonatomic,strong)UILabel *goldLable;
@property (nonatomic,strong)UILabel *statusLable;
@end
@implementation InvitationHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
   
    
}
- (void)initUI{
    CGFloat width = (kScreenWidth - Start_X*2 - 3*Width_Space)/4;
    self.serialNumberLable = [self createLable:CGRectMake(Start_X, 0, width, 40)];
    [self addSubview:self.serialNumberLable];
    self.nickNameLable = [self createLable:CGRectMake(Start_X+width+Width_Space, 0, width, 40)];
    [self addSubview:self.nickNameLable];
    self.goldLable = [self createLable:CGRectMake(Start_X+(width+Width_Space)*2, 0, width, 40)];
    [self addSubview:self.goldLable];
    self.statusLable = [self createLable:CGRectMake(Start_X+(width+Width_Space)*3, 0, width, 40)];
    [self addSubview:self.statusLable];
}
- (void)setcontent:(NSDictionary *)dic index:(NSInteger)index{
    self.serialNumberLable.text = [NSString stringWithFormat:@"%ld",(long)index];
    NSString *nickName = [dic objectForKey:@"nickname"];
    if (!((NSNull *)nickName == [NSNull null]) ) {
       self.nickNameLable.text = nickName;
    }else{
        self.nickNameLable.text = @"null";
    }
   
    NSNumber *goldNumber = [dic objectForKey:@"be_invite_gold"];
    self.goldLable.text = [NSString stringWithFormat:@"%@",goldNumber];
    self.statusLable.text = [dic objectForKey:@"status"];
}
- (UILabel *)createLable:(CGRect)frame{
    UILabel *lable = [[UILabel alloc]initWithFrame:frame];
    lable.layer.masksToBounds = YES;
    lable.layer.cornerRadius = 2;
    lable.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    lable.textColor = [UIColor colorWithHexString:@"#FF5645"];
    lable.textAlignment = NSTextAlignmentCenter;
    return lable;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
