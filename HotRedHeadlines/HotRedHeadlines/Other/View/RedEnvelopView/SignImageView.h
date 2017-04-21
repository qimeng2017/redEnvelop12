//
//  SignImageView.h
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SignImageViewDelegate <NSObject>

- (void)showSignOrBag:(NSString *)type;

@end
@interface SignImageView : UIView
- (instancetype)initWithLableString:(NSString *)string;
@property (nonatomic,weak)id<SignImageViewDelegate>delegate;

- (void)showViewController:(UIViewController *)VC type:(NSString *)type info:(NSString *)info;
@end
