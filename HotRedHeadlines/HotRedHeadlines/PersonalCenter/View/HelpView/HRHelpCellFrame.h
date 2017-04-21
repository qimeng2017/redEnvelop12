//
//  HRHelpCellFrame.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/16.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HRHelpModel;
@interface HRHelpCellFrame : NSObject

@property (nonatomic, strong) HRHelpModel *cellModel;

@property (nonatomic, assign) CGRect problemFrame;

@property (nonatomic, assign) CGRect answerFrame;

@property (nonatomic, assign) CGRect moreFrame;

@property (nonatomic, assign) CGRect imageFrame;

@property (nonatomic, assign) CGFloat cellHeight;
/**
 *  isOpened = YES 就代表展开  isOpened = NO 代表合拢
 */
@property (nonatomic, assign, getter = isOpened) BOOL opened;
+(NSMutableArray *)cellSourceWithName:(NSString *)sourceName;
@end
