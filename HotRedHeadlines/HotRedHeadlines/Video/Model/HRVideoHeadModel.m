//
//  HRVideoHeadModel.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/8.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRVideoHeadModel.h"

@implementation HRVideoHeadModel
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.category = [aDecoder decodeObjectForKey:@"category"];
        
        self.icon = [aDecoder decodeObjectForKey:@"icon"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.category forKey:@"category"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
}

- (void)setValue:(id)value forKey:(NSString *)key
{
        [super setValue:value forKey:key];
}

@end
