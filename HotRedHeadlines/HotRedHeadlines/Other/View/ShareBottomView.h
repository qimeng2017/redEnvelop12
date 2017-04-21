//
//  ShareBottomView.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/6.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  ShareBottomViewDelegate<NSObject>

- (void)shareToWX;

@end
@interface ShareBottomView : UIView
@property (nonatomic,weak)id<ShareBottomViewDelegate>delegate;
@end
