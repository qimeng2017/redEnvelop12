//
//  NSObject+arc4arndom.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/9.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (arc4arndom)
+ (int)getRangOneToOneHundred;
+ (NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to;
+ (NSInteger)getRandomNum:(NSInteger)from to:(NSInteger)to;
@end
