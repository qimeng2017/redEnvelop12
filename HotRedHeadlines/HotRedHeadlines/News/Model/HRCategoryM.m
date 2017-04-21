//
//  HRCategoryM.m
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/22.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRCategoryM.h"

@implementation HRCategoryM
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.categoryId = [aDecoder decodeObjectForKey:@"categoryId"];
       
        self.icon = [aDecoder decodeObjectForKey:@"icon"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.categoryId forKey:@"categoryId"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.categoryId = value;
    }
    else {
        [super setValue:value forKey:key];
    }
}

@end
