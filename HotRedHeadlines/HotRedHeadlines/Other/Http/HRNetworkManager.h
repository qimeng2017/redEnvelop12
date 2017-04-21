//
//  HRNetworkManager.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^Completion)(NSURLSessionDataTask *task ,NSDictionary *responseObject);
typedef void (^Failure)(NSError *error);
@interface HRNetworkManager : NSObject
+ (HRNetworkManager *)shareManager;

/**
 *  有请求头的get请求
 */
- (void)Get:(NSString *)url Parameters:(NSDictionary *)parameters Success:(Completion)success Failure:(Failure)failure;

/**
 *  有请求头的get请求
 */
- (void)Get2:(NSString *)url Parameters:(NSDictionary *)parameters Success:(Completion)success Failure:(Failure)failure;
@end
