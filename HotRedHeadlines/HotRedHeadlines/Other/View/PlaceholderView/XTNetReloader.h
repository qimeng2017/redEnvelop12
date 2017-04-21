//
//  XTNetReloader.h
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/21.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ReloadButtonClickBlock)() ;

@interface XTNetReloader : UIView
- (instancetype)initWithFrame:(CGRect)frame
                  reloadBlock:(ReloadButtonClickBlock)reloadBlock ;

- (void)showInView:(UIView *)viewWillShow ;
- (void)dismiss ;
@end
