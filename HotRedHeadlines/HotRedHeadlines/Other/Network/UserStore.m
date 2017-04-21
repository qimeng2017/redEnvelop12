//
//  UserStore.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2017/3/8.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "UserStore.h"
#import "HRNetworkTools.h"
#import "HRNetworkManager.h"
@implementation UserStore
+ (UserStore *)sharedInstance
{
    static UserStore *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[UserStore alloc] init];
    });
    
    return _sharedInstance;
}
#pragma mark--审核开关
- (void)auditSwitch{
    
    NSDictionary *parameters = @{@"appid":appid,@"stype":stype};
    [[HRNetworkManager shareManager]Get:@"/review_status" Parameters:parameters Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        NSString *sucess = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        if ([sucess isEqualToString:@"1"]){
            UserDefaultSetObjectForKey(@"noreview", REVIEW_THE_STATUS);
            [self defaultUser];
        }else{
            UserDefaultSetObjectForKey(@"review", REVIEW_THE_STATUS);
        }
    } Failure:^(NSError *error) {
        
    }];
    
    
}
//默认用户
- (void)defaultUser{
    NSDictionary *userInfo = @{
                               @"city" : @"Bengbu",
                               @"country" : @"CN",
                               @"headimgurl" : @"http://wx.qlogo.cn/mmopen/9xM3cXia6HVM0ibBtbbBmu1iaIDRdp0pNlqh0MkAnQjxItYUh09pz356kxZs67VGoJZ7XuyOQbCxbwrGLibugCEwwDxc5zzqDNY3/0",
                               @"language" : @"zh_CN",
                               @"nickname" : @"恰少年",
                               @"openid" : @"o_k0lwKRNQZXZ1mbc0yrixGkrM44",
                               @"province" : @"Anhui",
                               @"sex" : @1,
                               @"unionid" : @"oszDYvnjGoggsWTshIScOemfEHWU"
                               };
    UserDefaultSetObjectForKey(userInfo, USERINFO);
}
@end
