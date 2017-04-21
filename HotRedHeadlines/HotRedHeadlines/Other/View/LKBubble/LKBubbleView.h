//
//  LKBubbleView.h
//  LemonKit
//
//  Created by 1em0nsOft on 16/8/30.
//  Copyright © 2016年 1em0nsOft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKBubbleInfo.h"

/**
 *  @author 1em0nsOft LiuRi
 *  @date 2016-08-30 14:08:50
 *
 *  @brief LK提示系列 - LK泡泡控件
 */
@interface LKBubbleView : UIView

/// @brief 进度属性
@property (nonatomic) CGFloat progress;

/**
 *  @author 1em0nsOft LiuRi
 *  @date 2016-08-30 16:08:41
 *
 *  @brief 默认的LK泡泡控件 - 单例方法
 *
 *  @return 默认的LK泡泡控件对象
 */
+ (LKBubbleView *)defaultBubbleView;

- (void)registerInfo: (LKBubbleInfo *)info forKey: (NSString *)key;

/**
 *  @author 1em0nsOft LiuRi
 *  @date 2016-08-30 16:08:53
 *
 *  @brief 显示指定的信息模型对应的泡泡控件
 */
- (void)showWithInfo: (LKBubbleInfo *)info;

/**
 *  @author 1em0nsOft LiuRi
 *  @date 2016-08-30 16:08:53
 *
 *  @brief 通过传入键来显示已经注册的指定样式泡泡控件
 */
- (void)showWithInfoKey: (NSString *)infoKey;

/**
 *  @author 1em0nsOft LiuRi
 *  @date 2016-08-30 16:08:53
 *
 *  @brief 显示指定的信息模型对应的泡泡控件，并指定的时间后隐藏
 *
 *  @param info          样式信息模型
 *  @param autoCloseTime 指定时间后隐藏泡泡控件的秒数
 */
- (void)showWithInfo: (LKBubbleInfo *)info autoCloseTime: (CGFloat)time;

/**
 *  @author 1em0nsOft LiuRi
 *  @date 2016-08-30 16:08:53
 *
 *  @brief 显示指定的信息模型对应的泡泡控件，并指定的时间后隐藏
 *
 *  @param info          已注册的样式信息模型的键
 *  @param autoCloseTime 指定时间后隐藏泡泡控件的秒数
 */
- (void)showWithInfoKey: (NSString *)infoKey autoCloseTime: (NSInteger)time;

/**
 *  @author 1em0nsOft LiuRi
 *  @date 2016-08-30 16:08:40
 *
 *  @brief 隐藏当前泡泡控件
 */
- (void)hide;

@end
