//
//  HRUtilts.m
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/24.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRUtilts.h"

@implementation HRUtilts
- (NSString *)idfa{
    NSString*idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return idfa;
   
}
- (NSString *)verify{
    
    NSString *idfa = [self idfa];
    NSString *date = [NSDate redDateForEveryday];
   NSString *redUrl = [NSString stringWithFormat:@"%@%@FB1C1CE0F269EBDF2B564174F0909E84",idfa,date];
    NSString *verify = [NSString stringToMD5:redUrl];
    return verify;
}
@end
