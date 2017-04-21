//
//  NSString+MD5.h
//  xiangle_beta
//
//  Created by Su Xiaozhou on 14-2-24.
//  Copyright (c) 2014年 xiangle.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)
- (NSString *)MD5String;
+ (NSString *)stringToMD5:(NSString *)str;
@end
