//
//  CenterInvitationCell.m
//  
//
//  Created by 邹壮壮 on 2016/12/7.
//
//

#import "CenterInvitationCell.h"
#import "InvitatioBtn.h"

#define height kScreenWidth*3/10

@interface CenterInvitationCell ()<InvitatioBtnDelegate>
{
    InvitatioBtn *wechat;//微信
    InvitatioBtn *friend;//朋友圈
    InvitatioBtn *qq;//qq
    InvitatioBtn *qqspace;//qq 空间
    InvitatioBtn *invitationCode;//邀请码
    InvitatioBtn *code;//二维码
}
@end
@implementation CenterInvitationCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGBA(217, 217, 217, 1);
        [self initUI];
    }
    return self;
}
- (void)initUI{
    
    wechat  = [[InvitatioBtn alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/3, height) imageName:@"invitatio_wechat" lableText:@"微信" right: NO isImage:YES];
    wechat.delegate  =self;
    [self addSubview:wechat];
   friend  = [[InvitatioBtn alloc]initWithFrame:CGRectMake(kScreenWidth/3, 0, kScreenWidth/3, height) imageName:@"invitatio_friend" lableText:@"朋友圈" right: NO isImage:YES];
    friend.delegate  =self;
    [self addSubview:friend];
   qq  = [[InvitatioBtn alloc]initWithFrame:CGRectMake(kScreenWidth*2/3, 0, kScreenWidth/3, height) imageName:@"invitatio_qq" lableText:@" QQ" right: NO isImage:YES];
    qq.delegate = self;
    [self addSubview:qq];
    qqspace  = [[InvitatioBtn alloc]initWithFrame:CGRectMake(0, height, kScreenWidth/3, height) imageName:@"invitatio_space" lableText:@"QQ空间" right: NO isImage:YES];
    qqspace.delegate  =self;
    [self addSubview:qqspace];
    invitationCode  = [[InvitatioBtn alloc]initWithFrame:CGRectMake(kScreenWidth/3, height, kScreenWidth/3, height) imageName:nil lableText:@"我的邀请码\n点击复制" right: NO isImage:NO];
    invitationCode.delegate  = self;
    [self addSubview:invitationCode];
    code  = [[InvitatioBtn alloc]initWithFrame:CGRectMake(kScreenWidth*2/3, height, kScreenWidth/3, height) imageName:@"invitatio_code" lableText:@"二维码" right: NO isImage:YES];
    code.delegate  = self;
    [self addSubview:code];
}
- (void)touchView:(UITapGestureRecognizer *)tap{
    NSInteger btnIndex = -1;
    if ([tap.view isEqual:wechat]) {
        btnIndex = 0;
    }else if ([tap.view isEqual:friend]){
        btnIndex = 1;
    }else if ([tap.view isEqual:qq]){
        btnIndex = 2;
    }else if ([tap.view isEqual:qqspace]){
        btnIndex = 3;
    }else if ([tap.view isEqual:invitationCode]){
        btnIndex = 4;
    }else if ([tap.view isEqual:code]){
        btnIndex = 5;
    }
    [self.delegate tap:btnIndex view:tap.view];
}
- (void)setConten:(NSString *)conten{
    invitationCode.content = conten;
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
