//
//  HRSystem.m
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/21.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRSystem.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>

@implementation HRSystem
#pragma mark - 设备相关

+ (NSString *)model
{
    return [[UIDevice currentDevice] model];
}

+ (NSString *)spec
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return platform;
}

+ (NSString *)systemName
{
    return [[UIDevice currentDevice] systemName];
}

+ (NSString *)deviceName
{
    return [[UIDevice currentDevice] name];
}

+ (NSString *)systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)bundleBuildVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+ (NSString *)bundleVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)appName
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

#pragma mark - 相机、相册权限

+ (BOOL)photoAuthorizationStatus
{
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted ||
        author == kCLAuthorizationStatusDenied) {
        
        [HRSystem showAlertTitle:@"提示" message:@"查看相册权限被禁止，请前往[设置]-[隐私]-[照片]中，允许每市APP使用相册服务"];
        return NO;
    }
    return YES;
}

+ (BOOL)cameraAuthorizationStatus
{
#if TARGET_IPHONE_SIMULATOR
    [HRSystem showAlertMessage:@"模拟器不支持"];
    return NO;
#else
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted ||
        authStatus == AVAuthorizationStatusDenied) {
        
        [HRSystem showAlertTitle:@"提示" message:@"使用相机权限被禁止，请前往[设置]-[隐私]-[相机]中，允许每市APP使用相机服务"];
        return NO;
    }
    return YES;
#endif
}

#pragma mark - 时间格式

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *_dateFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
    });
    
    return _dateFormatter;
}



#pragma mark - track
+ (void)startAnalytics
{
    
}

+ (void)beginLogPageView:(NSString *)viewName
{
    
}

+ (void)endLogPageView:(NSString *)viewName
{
    
}

+ (void)trackEvent:(NSString *)event
{
    
}

#pragma mark - 评论
+ (void)appReviewAppId:(NSString *)appId
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appId]]];
}

#
#pragma mark - alert view
+ (UIViewController *)topViewController
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow] ? : [[[UIApplication sharedApplication] windows] lastObject];
    UIViewController *rootViewController = window.rootViewController;
    UIViewController *topViewController = rootViewController;
    while (topViewController != nil) {
        
        if (topViewController.navigationController)
        {
            topViewController = topViewController.navigationController.topViewController;
        }
        
        if (topViewController.presentedViewController == nil)
        {
            break;
        }
        
        topViewController = topViewController.presentedViewController;
    }
    
    return topViewController;
}

+ (void)showAlertMessage:(NSString *)message
{
    if ([HRSystem topViewController]) {
        [self showAlertTitle:@"提示" message:message];
    }
}

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message
{
    if ([HRSystem topViewController]) {
        [self showAlertTitle:title message:message singleButtonTitle:@"确定"];
    }
}

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message singleButtonTitle:(NSString *)singleButtonTitle confirm:(void (^)())confirm
{
    if ([message isKindOfClass:[NSString class]]) {
        
        if (message.length != 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:singleButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    if (confirm) {
                        confirm();
                    }
                    
                }];
                
                [alertCtrl addAction:confirmAction];
                
                [[HRSystem topViewController] presentViewController:alertCtrl animated:YES completion:NULL];
            });
            
            
        }
        
    }
    
    
}

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message singleButtonTitle:(NSString *)singleButtonTitle
{
    [HRSystem showAlertTitle:title message:message singleButtonTitle:singleButtonTitle confirm:NULL];
    
}

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message confirm:(void (^)(BOOL))confirm
{
    if ([HRSystem topViewController]) {
        [self showAlertTitle:title message:message confirmTitle:@"确定" confirm:confirm];
    }
}

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle confirm:(void (^)(BOOL confirm))confirm
{
    if ([HRSystem topViewController]) {
        [self showAlertTitle:title message:message cancelTitle:@"取消" confirmTitle:confirmTitle confirm:confirm];
    }
}

+ (void)showAlertMessage:(NSString *)message confirm:(void (^)(BOOL confirm))confirm
{
    if ([HRSystem topViewController]) {
        [self showAlertTitle:@"提示" message:message confirm:confirm];
    }
}

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle confirm:(void (^)(BOOL))confirm
{
    
    if ([message isKindOfClass:[NSString class]]) {
        
        if (message.length != 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    if (confirm) {
                        confirm(NO);
                    }
                }];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (confirm) {
                        confirm(YES);
                    }
                }];
                
                [alertCtrl addAction:cancelAction];
                [alertCtrl addAction:confirmAction];
                
                [[HRSystem topViewController] presentViewController:alertCtrl animated:YES completion:NULL];
            });
        }
        
    }
    
}

#pragma mark - registerForRemoteNotifications

+ (void)registerForRemoteNotifications
{
#if !TARGET_IPHONE_SIMULATOR
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:
                                            (
                                             UIUserNotificationTypeAlert |
                                             UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound
                                             ) categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
#endif
}

#pragma mark - 微信

//微信登录
+ (void)wxAuthorizeLogin
{
    //    if (![WXApi isWXAppInstalled]) {
    //        [QBSystem showAlertMessage:LSTR(@"未安装微信")];
    //        return;
    //    }
    //
    //    SendAuthReq *req = [[SendAuthReq alloc] init];
    //    req.scope = @"snsapi_userinfo";
    //    req.state = kWXState;
    //    [WXApi sendReq:req];
}

//+ (void)requestWXLoginAccessToken:(NSString *)code
//{
//    NSString *accessTokenUrlStr = [NSString stringWithFormat:kWXAccessTokenURL, kWXAppId, kWXSecret, code];
//    NSURL *accessTokenUrl = [NSURL URLWithString:accessTokenUrlStr];
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionTask *task = [session dataTaskWithURL:accessTokenUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (data) {
//            id value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//            if ([value isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *dict = (NSDictionary *)value;
//                NSLog(@"dict %@", dict);
//            }
//        }
//    }];
//    [task resume];
//}

@end
