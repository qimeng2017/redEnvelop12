//
//  SGActionSheetCell.m
//  SGActionSheetExample
//
//  Created by Sorgle on 16/9/17.
//  Copyright © 2016年 Sorgle. All rights reserved.
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
//
//  - - 如在使用中, 遇到什么问题或者有更好建议者, 请于kingsic@126.com邮箱联系 - - - - //
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - GitHub下载地址 https://github.com/kingsic/SGActionSheet.git - - - - - //
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

#import "SGActionSheetCell.h"

@interface SGActionSheetCell ()

@property (nonatomic, strong) UIImageView *cellBGimageHigh;

@end

@implementation SGActionSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *) reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        
        self.cellBGimageHigh = [[UIImageView alloc] init];
        _cellBGimageHigh.image = [UIImage imageNamed:@"SGActionSheet.bundle/cell_bg_image_high@2x"];
        _cellBGimageHigh.clipsToBounds = YES;
        _cellBGimageHigh.hidden = YES;
        [self addSubview:_cellBGimageHigh];
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        self.splitters = [[UIImageView alloc] init];
        _splitters.image = [UIImage imageNamed:@"SGActionSheet.bundle/cell_splitters@2x"];
        _splitters.contentMode = UIViewContentModeTop;
        _splitters.clipsToBounds = YES;
        [self addSubview:_splitters];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.cellBGimageHigh.frame = self.bounds;
    self.titleLabel.frame = self.bounds;
    self.splitters.frame = CGRectMake(0, 0, self.bounds.size.width, 1.0f);
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    self.cellBGimageHigh.hidden = !highlighted;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
