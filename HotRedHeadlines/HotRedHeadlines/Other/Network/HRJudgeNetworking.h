//
//  HRJudgeNetworking.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRJudgeNetworking : NSObject
typedef NS_ENUM(NSUInteger, NetworkingType) {
    NetworkingTypeNoReachable = 1,
    NetworkingType3G = 2,
    NetworkingTypeWiFi = 3,
};

+ (BOOL)judge;

+ (NetworkingType)currentNetworkingType;
@end
