//
//  HRSystem.h
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/21.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HRSystem : NSObject
#pragma mark - 设备信息相关
+ (NSString *)model;//返回如 "iPhone", "iPod touch" 的字符串
+ (NSString *)spec;// 返回型号，行如 "iPhone3,1" 的字符串
+ (NSString *)systemName;// 返回行如 "iOS" 的字符串
+ (NSString *)deviceName;// 返回行如 "My Iphone" 的字符串
+ (NSString *)systemVersion;
+ (NSString *)bundleBuildVersion;//build version
+ (NSString *)bundleVersion;//
+ (NSString *)appName;

#pragma mark - 相机、相册权限

+ (BOOL)photoAuthorizationStatus;

+ (BOOL)cameraAuthorizationStatus;

#pragma mark - 时间格式

+ (NSDateFormatter *)dateFormatter;



#pragma mark - track(需要继承)
+ (void)startAnalytics;
+ (void)beginLogPageView:(NSString *)viewName;
+ (void)endLogPageView:(NSString *)viewName;
+ (void)trackEvent:(NSString *)event;

#pragma mark - 评论
+ (void)appReviewAppId:(NSString *)appId;


#pragma mark - alert view
+ (UIViewController *)topViewController;

+ (void)showAlertMessage:(NSString *)message;
+ (void)showAlertTitle:(NSString *)title message:(NSString *)message;

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message singleButtonTitle:(NSString *)singleButtonTitle;
+ (void)showAlertTitle:(NSString *)title message:(NSString *)message singleButtonTitle:(NSString *)singleButtonTitle confirm:(void (^)())confirm;
+ (void)showAlertMessage:(NSString *)message confirm:(void (^)(BOOL confirm))confirm;
+ (void)showAlertTitle:(NSString *)title message:(NSString *)message confirm:(void (^)(BOOL confirm))confirm;
+ (void)showAlertTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle confirm:(void (^)(BOOL confirm))confirm;

#pragma mark - registerForRemoteNotifications
+ (void)registerForRemoteNotifications;
@end
