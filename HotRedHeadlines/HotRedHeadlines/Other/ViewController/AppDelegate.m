//
//  AppDelegate.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/2.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "AppDelegate.h"
#import "HRTaBarViewController.h"
#import "LoginViewController.h"
#import "WXApiManager.h"
#import "HRSystem.h"
#import <Bugly/Bugly.h>
@interface AppDelegate ()<LoginViewControllerDelegate>
@property (nonatomic,strong)HRTaBarViewController *tabbarVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [WXApi registerApp:kAuthOpenID withDescription:@"demo 2.0"];
    //bugly
    BuglyConfig *config = [[BuglyConfig alloc]init];
    config.unexpectedTerminatingDetectionEnable = YES;
    config.blockMonitorEnable = YES;
    config.debugMode = YES;
    
    [Bugly startWithAppId:bugly_appid config:config];
    
    //um
    UMConfigInstance.appKey = kUMAppkey;
    [MobClick startWithConfigure:UMConfigInstance];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSString *buildVersion = [HRSystem bundleBuildVersion];
    if (!UserDefaultObjectForKey(buildVersion)) {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        loginVC.delegate = self;
        self.window.rootViewController = loginVC;
    }else{
        self.tabbarVC = [[HRTaBarViewController alloc] init];
        self.window.rootViewController = self.tabbarVC;
    }
    
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}
- (void)loginSucess:(BOOL)isaApp{
    NSString *buildVersion = [HRSystem bundleBuildVersion];
    UserDefaultSetObjectForKey(@"YES", @"frist_start_app");
    UserDefaultSetObjectForKey(@"sucess", buildVersion);
    self.tabbarVC = [[HRTaBarViewController alloc] init];
    self.window.rootViewController = self.tabbarVC;
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSString *status = UserDefaultObjectForKey(REVIEW_THE_STATUS);
    if ([status isEqualToString:@"review"]) {
      [self.tabbarVC checkUpdate];
    }
    [self.tabbarVC getUserInfo];
    BOOL isAppStory = [[NSUserDefaults standardUserDefaults] boolForKey:ISAPPSTROY];
    if (isAppStory) {
       [[NSUserDefaults standardUserDefaults] setObject:[NSDate new] forKey:DATE_TO_END];
        
        [self.tabbarVC appearRedBag];
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)openURL:(NSURL*)url options:(NSDictionary<NSString *, id> *)options completionHandler:(void (^ __nullable)(BOOL success))completion {
    
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return YES;
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"@2");
    
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    NSLog(@"3");
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}


//竖屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}
@end
