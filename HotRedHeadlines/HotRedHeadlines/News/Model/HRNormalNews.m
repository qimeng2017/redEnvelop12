//
//  HRNormalNews.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRNormalNews.h"

@implementation HRNormalNews
@synthesize article_url,image_url,source,title,image_list,ground_id,listId,time;
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:article_url forKey:@"article_url"];
    [aCoder encodeObject:image_url forKey:@"image_url"];
    [aCoder encodeObject:source forKey:@"source"];
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:image_list forKey:@"image_list"];
    [aCoder encodeObject:ground_id forKey:@"ground_id"];
    [aCoder encodeObject:listId forKey:@"listId"];
    [aCoder encodeObject:time forKey:@"time"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        [self setArticle_url:[aDecoder decodeObjectForKey:@"article_url"]];
        [self setImage_url:[aDecoder decodeObjectForKey:@"image_url"]];
        [self setSource:[aDecoder decodeObjectForKey:@"source"]];
        [self setTitle:[aDecoder decodeObjectForKey:@"title"]];
        [self setImage_list:[aDecoder decodeObjectForKey:@"image_list"]];
        [self setGround_id:[aDecoder decodeObjectForKey:@"ground_id"]];
        [self setListId:[aDecoder decodeObjectForKey:@"listId"]];
        [self setTime:[aDecoder decodeObjectForKey:@"time"]];
        
    }
    return  self;
}

- (void)readFromJSONDictionary:(NSDictionary *)d{
    [self setArticle_url:[d objectForKey:@"article_url"]];
    [self setImage_url:[d objectForKey:@"image_url"]];
    [self setSource:[d objectForKey:@"source"]];
    [self setTitle:[d objectForKey:@"title"]];
    [self setImage_list:[d objectForKey:@"image_list"]];
    [self setGround_id:[d objectForKey:@"ground_id"]];
    [self setListId:[d objectForKey:@"id"]];
    [self setTime:[d objectForKey:@"time"]];
}

@end
