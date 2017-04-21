//
//  HRFlashLable.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/16.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRFlashLable : UILabel
/** 光晕循环一次的持续时间，默认循环时间为3秒 */
@property (nonatomic, assign) CGFloat haloDuration;

/** 光晕宽度占Label宽度的百分比，默认0.5 */
@property (nonatomic, assign) CGFloat haloWidth;

/** 光晕颜色，默认白色 */
@property (nonatomic, strong) UIColor *haloColor;

/** 是否执行动画，默认为NO */
@property (nonatomic, assign, getter = isAnimated) BOOL animated;
@end
