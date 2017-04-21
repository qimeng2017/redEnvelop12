//
//  UserStore.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2017/3/8.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^sucessCompleteBlock)(NSURLSessionDataTask *task, id responseObject);

typedef void(^failureCompleteBlock)(NSURLSessionDataTask *task, NSError * error);
@interface UserStore : NSObject
+ (UserStore *)sharedInstance;
#pragma mark--审核开关
- (void)auditSwitch;
@end
