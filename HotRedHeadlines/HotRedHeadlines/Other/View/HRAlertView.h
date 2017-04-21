//
//  HRAlertView.h
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/21.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HRAlertView;
@protocol HRAlertViewDelegate <NSObject>

- (void)popAlertView:(HRAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
@interface HRAlertView : UIView
@property (nonatomic, strong) NSString *targetUid;
@property (nonatomic, weak)   id <HRAlertViewDelegate> delegate;

- (id)initWithTitle:(NSString *)pTitle message:(NSString *)pMessage delegate:(id)pDelegate andButtons:(NSArray *)pButtons;
- (void)show;
//+ (HRAlertView *)sharedAlert;
@end
