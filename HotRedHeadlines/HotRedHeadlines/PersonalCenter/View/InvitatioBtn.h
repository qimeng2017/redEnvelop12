//
//  InvitatioBtn.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/7.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InvitatioBtnDelegate <NSObject>

- (void)touchView:(UITapGestureRecognizer *)tap;

@end
@interface InvitatioBtn : UIView
@property (nonatomic,strong)NSString *content;
@property (nonatomic,weak)id<InvitatioBtnDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName lableText:(NSString *)text right:(BOOL)isRight isImage:(BOOL)isImage;

@end
