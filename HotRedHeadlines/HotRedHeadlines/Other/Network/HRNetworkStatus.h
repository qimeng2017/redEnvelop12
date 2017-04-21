//
//  HRNetworkStatus.h
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/21.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>
extern  NSString  * const WifiAvailableNotification;/**<使用wifi连接*/
extern  NSString  * const WwanAavailableNotification;/**<使用2g/3g 连接*/
extern  NSString  * const NetworkUnavailableNotification;/**<未有网络*/

@interface HRNetworkStatus : NSObject
@property (nonatomic, assign)  BOOL  wifiAvailable;
@property (nonatomic, assign)  BOOL  networkAvailable;
@property (nonatomic, assign)  BOOL  unavailable;

+ (HRNetworkStatus *)sharedInstance;

- (void)startNetworkNotifer;//开始监听
- (void)stopNetworkNotifer;//停止监听
@end
