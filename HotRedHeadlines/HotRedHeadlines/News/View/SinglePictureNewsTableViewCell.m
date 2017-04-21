//
//  SinglePictureNewsTableViewCell.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "SinglePictureNewsTableViewCell.h"
#import "NSDate+Formatter.h"
@interface SinglePictureNewsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *sourceLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@end
@implementation SinglePictureNewsTableViewCell

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
- (void)setContent:(NSString *)content{
    
    self.contentLable.text = content;
}
- (void)setSource:(NSString *)source{
    _source = source;
    self.sourceLable.text = source;
}
- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageProgressiveDownload];
}
- (void)setNormalNews:(HRNormalNews *)normalNews{
    
    _normalNews = normalNews;
    NSLog(@"normalNews.image_url====%@",normalNews.image_url);
    self.sourceLable.text = [NSString stringWithFormat:@"%@",normalNews.source];
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:normalNews.image_url] placeholderImage:nil options:SDWebImageRefreshCached];
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
