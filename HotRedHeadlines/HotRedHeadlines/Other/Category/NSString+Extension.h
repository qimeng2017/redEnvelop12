//
//  NSString+Extension.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/16.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
