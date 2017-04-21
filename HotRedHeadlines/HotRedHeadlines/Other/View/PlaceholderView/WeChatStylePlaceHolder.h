//
//  WeChatStylePlaceHolder.h
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/21.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeChatStylePlaceHolderDelegate <NSObject>

@required
- (void)emptyOverlayClicked:(id)sender;

@end
@interface WeChatStylePlaceHolder : UIView
@property (nonatomic, weak) id<WeChatStylePlaceHolderDelegate> delegate;


@end
