//
//  MultiPictureTableViewCell.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "MultiPictureTableViewCell.h"
#import "NSDate+Formatter.h"
@interface MultiPictureTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLable;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageview3;
@property (weak, nonatomic) IBOutlet UILabel *sourceLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@end
@implementation MultiPictureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    self.newsTitleLable.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.sourceLable.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.timeLable.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}
- (void)setTime:(NSString *)time{
    _time = time;
    self.timeLable.text = time;
}
- (void)setTitle:(NSString *)title{
    _title = title;
    self.newsTitleLable.text = title;
}

- (void)setSource:(NSString *)source{
    _source = source;
    self.sourceLable.text = source;
}
- (void)setNormalNews:(HRNormalNews *)normalNews{
    _normalNews = normalNews;
    self.sourceLable.text = [NSString stringWithFormat:@"%@",normalNews.source];
    [_imageView1 sd_setImageWithURL:[NSURL URLWithString:normalNews.image_list[0]] placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageProgressiveDownload];
    [_imageView2 sd_setImageWithURL:[NSURL URLWithString:normalNews.image_list[1]] placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageProgressiveDownload];    
    if (normalNews.image_list.count > 2) {
        [_imageview3 sd_setImageWithURL:[NSURL URLWithString:normalNews.image_list[2]] placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageProgressiveDownload];
    }

    self.newsTitleLable.text =  normalNews.title;
    NSString *str =normalNews.time;
    NSTimeInterval time = [str doubleValue];
    self.timeLable.text = [NSDate timeStamps:time];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
