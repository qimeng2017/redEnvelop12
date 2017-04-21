//
//  TopInvitationCell.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/7.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "TopInvitationCell.h"

@interface TopInvitationCell ()
//@property (weak, nonatomic) IBOutlet UILabel *moneyLable;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

@end
@implementation TopInvitationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.recordBtn.titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    // Initialization code
}
- (IBAction)recordBtnAction:(id)sender {
    [self.delegate viewYourInvitationHistory];
}
//- (void)setMoney:(NSString *)money{
//    self.moneyLable.text = [NSString stringWithFormat:@"已赚%@元",money];
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
