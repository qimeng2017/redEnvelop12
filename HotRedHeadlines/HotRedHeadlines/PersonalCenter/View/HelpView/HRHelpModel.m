//
//  HRHelpModel.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/15.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRHelpModel.h"

@implementation HRHelpModel
@synthesize imageURL,problem,answer;
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:imageURL forKey:@"imageURL"];
    [aCoder encodeObject:problem forKey:@"problem"];
    [aCoder encodeObject:answer forKey:@"answer"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        [self setImageURL:[aDecoder decodeObjectForKey:@"imageURL"]];
        [self setProblem:[aDecoder decodeObjectForKey:@"problem"]];
        [self setAnswer:[aDecoder decodeObjectForKey:@"answer"]];
    }
    return  self;
}

- (void)readFromJSONDictionary:(NSDictionary *)d{
    [self setImageURL:[d objectForKey:@"imageURL"]];
    [self setProblem:[d objectForKey:@"problem"]];
    [self setAnswer:[d objectForKey:@"answer"]];
}

@end
