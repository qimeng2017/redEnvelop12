//
//  XTWithdrawalPlaceHolder.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/14.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XTWithdrawalPlaceHolderDelegate <NSObject>

@required
- (void)emptyOverlayClicked:(id)sender;

@end
@interface XTWithdrawalPlaceHolder : UIView
@property (nonatomic, weak) id<XTWithdrawalPlaceHolderDelegate> delegate;
@end
