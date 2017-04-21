//
//  InvitatioBtn.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/7.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "InvitatioBtn.h"


@interface InvitatioBtn ()
{
    UIImageView *imageView;
    UILabel *contentLable;
}
@end
@implementation InvitatioBtn

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName lableText:(NSString *)text right:(BOOL)isRight isImage:(BOOL)isImage{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        if (isImage) {
            imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
            imageView.center = CGPointMake(frame.size.width/2, imageView.frame.size.height/2+20);
            [self addSubview:imageView];
          
        }else{
            contentLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 14, frame.size.width, 40)];
            
            contentLable.font = [UIFont systemFontOfSize:20];
            contentLable.textAlignment = NSTextAlignmentCenter;
            contentLable.text = imageName;
            contentLable.textColor = [UIColor blackColor];
            contentLable.dk_textColorPicker = DKColorPickerWithKey(TEXT);
            [self addSubview:contentLable];
        }
        CGFloat originY = isImage?CGRectGetMaxY(imageView.frame)+10:CGRectGetMaxY(contentLable.frame);
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, originY, frame.size.width, 40)];
        lable.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        lable.text = text;
        lable.font = [UIFont systemFontOfSize:14];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.numberOfLines = 2;
        [self addSubview:lable];
    }
    return self;
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self.delegate touchView:tap];
}
- (void)setContent:(NSString *)content{
    contentLable.text = content;
}
@end
