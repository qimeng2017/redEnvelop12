//
//  HRNetworkManager.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRNetworkManager.h"

@interface HRNetworkManager ()
{
    dispatch_semaphore_t semaphore;
}
@end
@implementation HRNetworkManager
+ (HRNetworkManager *)shareManager {
    static HRNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken ,^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)Get:(NSString *)url Parameters:(NSDictionary *)parameters Success:(Completion)success Failure:(Failure)failure {
    semaphore = dispatch_semaphore_create(0); //创建信号量
    __block NSInteger flag = 0;
    __block NSString *theUrl = [NSString stringWithFormat:@"%@%@",RED_ENVELOP_HOST_NAME,url];
    if (parameters) {
        [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (flag == 0) {
                theUrl = [theUrl stringByAppendingString:[NSString stringWithFormat:@"?%@=%@",key,obj]];
                flag = 1;
            } else {
                theUrl = [theUrl stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,obj]];
            }
        }];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theUrl]];
    NSURLSessionDataTask *task =[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
            return ;
        }
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            success(task,dict);
        });
         dispatch_semaphore_signal(semaphore);   //发送信号  +1
    }];
    [task resume];
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);
}

- (void)Get2:(NSString *)url Parameters:(NSDictionary *)parameters Success:(Completion)success Failure:(Failure)failure{
    __block NSInteger flag = 0;
    __block NSString *theUrl = url;
    if (parameters) {
        [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (flag == 0) {
                theUrl = [theUrl stringByAppendingString:[NSString stringWithFormat:@"?%@=%@",key,obj]];
                flag = 1;
            } else {
                theUrl = [theUrl stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,obj]];
            }
        }];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[theUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    NSString *apikey = @"8b72ce2839d6eea0869b4c2c60d2a449";
    [mutableRequest addValue:apikey forHTTPHeaderField:@"apikey"];
    request = [mutableRequest copy];
    NSURLSessionDataTask *task =[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
            return ;
        }
        //            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //            NSLog(@"%@",string);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            success(task,dict);
        });
    }];
    [task resume];
}

@end
