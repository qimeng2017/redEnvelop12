//
//  SignInMainView.h
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/24.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignInMainViewDelegate <NSObject>

- (void)signSucess;

@end
@interface SignInMainView : UIView
@property (nonatomic,weak)id<SignInMainViewDelegate>delegate;
- (void)showType:(NSString *)type info:(NSString *)info;
@end
