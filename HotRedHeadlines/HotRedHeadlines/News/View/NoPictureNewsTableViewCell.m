//
//  NoPictureNewsTableViewCell.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "NoPictureNewsTableViewCell.h"

@interface NoPictureNewsTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@end
@implementation NoPictureNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setTime:(NSString *)time{
    _time = time;
    self.timeLable.text = time;
}
- (void)setTitle:(NSString *)title{
    _title = title;
    self.newsTitleLabel.text = title;
}
- (void)setContent:(NSString *)content{
    _content = content;
    self.contentLabel.text = content;
}
- (void)setSource:(NSString *)source{
    _source = source;
    self.sourceLable.text = source;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
