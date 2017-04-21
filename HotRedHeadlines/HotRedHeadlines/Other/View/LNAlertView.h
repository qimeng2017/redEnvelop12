//
//  LNAlertView.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/28.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, LNAlertActionStyle) {
    LNAlertActionStyleDefault = 0,
    LNAlertActionStyleCancel,
    LNAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, LNCustomViewPresentationStyle) {
    Default = 0,
    MoveUp,
    MoveDown
};
@class LNAlertButtonItem;
@interface LNAlertView : UIView
@property(nonatomic, strong) UIColor *titleColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIFont *titleFont UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *messageColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIFont *messageFont UI_APPEARANCE_SELECTOR;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;
- (instancetype)initWithCustomView:(UIView *)customView;
- (instancetype)initWithCustomView:(UIView *)customView withPresentationStyle:(LNCustomViewPresentationStyle)style;
- (void)addButtonWithTitle:(NSString *)title
                     style:(LNAlertActionStyle)style
                   handler:(void(^)(LNAlertView *alertView, LNAlertButtonItem *buttonItem))handler;
- (void)addDefaultStyleButtonWithTitle:(NSString *)title
                               handler:(void(^)(LNAlertView *alertView, LNAlertButtonItem *buttonItem))handler;
- (void)show;
- (void)dismiss;
@end

@interface LNAlertView (Creations)
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;
+ (instancetype)alertWithCustomView:(UIView *)customView withPresentationStyle:(LNCustomViewPresentationStyle)style;
@end

