//
//  HRWebProgressLayer.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/16.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface HRWebProgressLayer : CAShapeLayer
- (void)finishedLoad;
- (void)startLoad;

- (void)closeTimer;
@end
