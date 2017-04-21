//
//  HRSettings.m
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/22.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRSettings.h"
#import "NSDate+Formatter.h"
@implementation HRSettings
+ (HRSettings *)sharedInstance
{
    static HRSettings *_settings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _settings = [[HRSettings alloc] init];
    });
    return _settings;
}

- (void)saveValue:(id)value
{
    if (value) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:value forKey:[NSString stringWithFormat:@"HRFramework.%@", value]];
        [defaults synchronize];
    }
    
}

#pragma mark - approved
- (void)setIsApproved:(BOOL)isApproved{
   
}
#pragma mark -countNumber
- (void)setCountNumber:(NSNumber *)countNumber{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:countNumber];
    NSString *nowDay = [NSString stringWithFormat:@"%@-webShare",[NSDate redDateForEveryday]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:data forKey:nowDay];
    [defaults synchronize];
}
- (NSNumber *)countNumber{
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *nowDay = [NSString stringWithFormat:@"%@-webShare",[NSDate redDateForEveryday]];
   NSData *data = [defaults objectForKey:nowDay];
    NSNumber *number = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return number;
}
#pragma mark - tags

- (void)setTags:(NSArray *)tags
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tags];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"tags"];
    [defaults synchronize];
}

- (NSArray *)tags
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"tags"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}
@end
