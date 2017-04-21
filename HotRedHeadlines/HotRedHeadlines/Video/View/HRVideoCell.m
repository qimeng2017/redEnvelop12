//
//  HRVideoCell.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/8.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRVideoCell.h"
#import "NSDate+Formatter.h"
@interface HRVideoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
@implementation HRVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bottomView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    // Initialization code
}
- (IBAction)shareAction:(id)sender {
    [self.delegate shareVideo:_videoModel];
}

- (void)setVideoModel:(VideoModel *)videoModel{
    _videoModel = videoModel;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.imgurl] placeholderImage:nil options:SDWebImageProgressiveDownload];
    self.titleLable.text = videoModel.title;
    self.titleLable.textColor = [UIColor whiteColor];
//    self.titleLable.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    NSString *str =videoModel.time;
    NSTimeInterval time = [str doubleValue];
    self.timeLable.text =[NSDate timeStamp:time];
    self.timeLable.dk_textColorPicker = DKColorPickerWithKey(TEXT);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
