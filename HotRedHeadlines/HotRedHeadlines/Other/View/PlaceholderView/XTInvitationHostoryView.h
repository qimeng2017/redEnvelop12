//
//  XTInvitationHostoryView.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/7.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XTInvitationHostoryViewDelegate <NSObject>

@required
- (void)emptyOverlayClicked:(id)sender;

@end
@interface XTInvitationHostoryView : UIView
@property (nonatomic, weak) id<XTInvitationHostoryViewDelegate> delegate;
@end
