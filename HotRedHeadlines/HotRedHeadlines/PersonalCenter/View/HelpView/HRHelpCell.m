//
//  HRHelpCell.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/16.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRHelpCell.h"
@interface HRHelpCell ()
@property (nonatomic, weak) UIImageView *imageViewIcon;

@property (nonatomic, weak) UILabel *problemL;

@property (nonatomic, weak) UILabel *answerL;

@property (nonatomic, weak) UIImageView *moreImageView;
@end
@implementation HRHelpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        // 设置Cell中的控件
        [self setupCellWithInsideContent];
        
        
        
    }
    return self;
}
#pragma mark - 设置Cell中的内容
-(void)setupCellWithInsideContent{
    UIImageView *headIcon = [[UIImageView alloc] init];
    headIcon.opaque = YES;
    self.imageViewIcon = headIcon;
    [self.contentView addSubview:headIcon];
    
    UILabel *problemLab = [[UILabel alloc] init];
    problemLab.opaque = YES;
    problemLab.font = [UIFont boldSystemFontOfSize:18];
    self.problemL = problemLab;
    [self.contentView addSubview:problemLab];
    
    UILabel *answerLab = [[UILabel alloc] init];
    answerLab.numberOfLines = 0;
    answerLab.opaque = YES;
    answerLab.font = [UIFont boldSystemFontOfSize:16];
    answerLab.textColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1.0];
    self.answerL = answerLab;
    [self.contentView addSubview:answerLab];
    
    UIImageView *moreView = [[UIImageView alloc] init];
    moreView.contentMode = UIViewContentModeScaleAspectFit;
    moreView.backgroundColor = [UIColor clearColor];
    
    moreView.image = [UIImage imageNamed:@"group_pay_arrow"];
    self.moreImageView = moreView;
    [self.contentView addSubview:moreView];
    
    
    
}

-(void)setCellFrame:(HRHelpCellFrame *)cellFrame{
    _cellFrame = cellFrame;
    
    [self setupMessageFrame];
    
    [self setupMessageContent:cellFrame];
}

-(void)setupMessageFrame{
    self.imageViewIcon.frame = self.cellFrame.imageFrame;
    self.answerL.frame = self.cellFrame.answerFrame;
    self.problemL.frame = self.cellFrame.problemFrame;
    
    self.moreImageView.frame = self.cellFrame.moreFrame;
    if (self.cellFrame.isOpened == YES){
        self.moreImageView.transform = CGAffineTransformMakeRotation(-M_PI);
    }else{
        self.moreImageView.transform = CGAffineTransformIdentity;
        
    }
}

-(void)setupMessageContent:(HRHelpCellFrame *)cellFrame{
    HRHelpModel *model = cellFrame.cellModel;
    
    self.imageViewIcon.image = [UIImage imageNamed:model.imageURL];
    self.problemL.text = model.problem;
    self.answerL.text = model.answer;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageViewIcon.layer.cornerRadius = self.imageViewIcon.frame.size.width * 0.5;
    self.imageViewIcon.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
