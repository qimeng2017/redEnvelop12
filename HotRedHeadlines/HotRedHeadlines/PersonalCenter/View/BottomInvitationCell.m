//
//  BottomInvitationCell.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/7.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "BottomInvitationCell.h"
#import "InvitatioBtn.h"
#define height kScreenWidth*3/10
@implementation BottomInvitationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
     self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    InvitatioBtn *wechat  = [[InvitatioBtn alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/3, height) imageName:@"invitatio1" lableText:@"分享链接\n邀请好友" right: NO isImage:YES];
    [self addSubview:wechat];
    InvitatioBtn *friend  = [[InvitatioBtn alloc]initWithFrame:CGRectMake(kScreenWidth/3, 0, kScreenWidth/3, height) imageName:@"invitatio2" lableText:@"好友注册\n填写你的邀请码" right: NO isImage:YES];
    [self addSubview:friend];
    InvitatioBtn *qq  = [[InvitatioBtn alloc]initWithFrame:CGRectMake(kScreenWidth*2/3, 0, kScreenWidth/3, height) imageName:@"invitatio3" lableText:@"邀请成功\n获得奖励" right: NO isImage:YES];
    [self addSubview:qq];
    UILabel *tipLable = [[UILabel alloc]initWithFrame:CGRectMake(0, height+20, kScreenWidth, 22)];
    tipLable.font = [UIFont systemFontOfSize:11];
    tipLable.text = @"*好友注册时填写邀请码,才能获得邀请奖励";
    tipLable.textColor = [UIColor colorWithHexString:@"#cccccc"];
    tipLable.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    tipLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tipLable];
   
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
