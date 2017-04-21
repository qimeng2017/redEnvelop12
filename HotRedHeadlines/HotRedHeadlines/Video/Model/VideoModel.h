//
//  VideoModel.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/8.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *html_url;/**<解释*/
@property (nonatomic, strong) NSString * imgurl;/**<解释*/
@property (nonatomic, strong) NSString * title;/**<解释*/
@property (nonatomic, strong) NSString *time;/**<解释*/
- (void)readFromJSONDictionary:(NSDictionary *)d;
@end
