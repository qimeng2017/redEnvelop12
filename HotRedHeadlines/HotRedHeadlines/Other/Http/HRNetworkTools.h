//
//  HRNetworkTools.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface HRNetworkTools : AFHTTPSessionManager
+ (instancetype)sharedNetworkTools;
+ (instancetype)sharedNetworkToolsWithoutBaseUrl;
@end
