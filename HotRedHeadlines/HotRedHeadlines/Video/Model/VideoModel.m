//
//  VideoModel.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/8.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel
@synthesize html_url,imgurl,title,time;
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:html_url forKey:@"html_url"];
    [aCoder encodeObject:imgurl forKey:@"imgurl"];
    [aCoder encodeObject:time forKey:@"time"];
    [aCoder encodeObject:title forKey:@"title"];
   
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        [self setHtml_url:[aDecoder decodeObjectForKey:@"html_url"]];
        [self setImgurl:[aDecoder decodeObjectForKey:@"imgurl"]];
        [self setTitle:[aDecoder decodeObjectForKey:@"title"]];
        [self setTime:[aDecoder decodeObjectForKey:@"time"]];
        
    }
    return  self;
}

- (void)readFromJSONDictionary:(NSDictionary *)d{
    [self setImgurl:[d objectForKey:@"imgurl"]];
    [self setHtml_url:[d objectForKey:@"html_url"]];
    [self setTitle:[d objectForKey:@"title"]];
    [self setTime:[d objectForKey:@"time"]];
}

@end
