//
//  WithdrawaCollectionViewCell.m
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/24.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "WithdrawaCollectionViewCell.h"

@interface WithdrawaCollectionViewCell ()
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *lable;
@end
@implementation WithdrawaCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.imageView];
        self.lable = [[UILabel alloc]initWithFrame:CGRectMake(0, (frame.size.height - 60)/2, frame.size.width, 60)];
        self.lable.textAlignment = NSTextAlignmentCenter;
        self.lable.font = [UIFont systemFontOfSize:24];
        self.lable.tintColor = [UIColor blackColor];
        [self addSubview:self.lable];
    }
    return self;
}
- (void)setContentImage:(NSString *)imageName{
    self.imageView.image = [UIImage imageNamed:@"hb.jpg"];
    self.lable.text = imageName;
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:nil];
}
@end
