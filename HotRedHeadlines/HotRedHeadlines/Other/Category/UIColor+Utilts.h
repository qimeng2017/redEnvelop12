//
//  UIColor+Utilts.h
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/23.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utilts)
+ (UIColor *) colorWithHexString: (NSString *)color;
+ (UIColor *) getColor:(NSString *)hexColor alpha:(CGFloat)alpha;
@end
