//
//  NSObject+arc4arndom.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/9.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "NSObject+arc4arndom.h"

@implementation NSObject (arc4arndom)
//获取一个随机整数范围在：[0,100)包括0，不包括100
+ (int)getRangOneToOneHundred{
  int x = arc4random() % 100;
    return x;
}

//获取一个随机整数，范围在[from,to），包括from，包括to
+(NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to
{
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}
//获取一个随机整数，范围在[from,to），包括from，包括to
+(NSInteger)getRandomNum:(NSInteger)from to:(NSInteger)to
{
    return (NSInteger)(from + (arc4random() % (to - from)));
}
@end
