//
//  SignBtn.h
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/25.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignBtn : UIView
@property (nonatomic)BOOL isSelected;
- (instancetype)initWithDay:(NSString *)day gold:(NSString *)gold width:(CGFloat)width;
@end
