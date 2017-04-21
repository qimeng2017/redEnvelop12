//
//  HRJudgeNetworking.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRJudgeNetworking.h"
#import "Reachability.h"
@implementation HRJudgeNetworking
+ (BOOL)judge {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        return NO;
    }
    return YES;
}

+(NetworkingType)currentNetworkingType {
    Reachability *reachablility =  [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([reachablility currentReachabilityStatus] == ReachableViaWiFi) {
        return NetworkingTypeWiFi;
    } else if ([reachablility currentReachabilityStatus] == ReachableViaWWAN) {
        return NetworkingType3G;
    }
    return NetworkingTypeNoReachable;
}
@end
