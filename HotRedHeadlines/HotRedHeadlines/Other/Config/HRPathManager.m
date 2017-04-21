//
//  HRPathManager.m
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/21.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRPathManager.h"
#define kRootDir                @"Data"
@implementation HRPathManager
+ (NSString *)iCloudDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths firstObject];
}

+ (NSString *)tempDirectory
{
    return NSTemporaryDirectory();
}

+ (NSString *)cacheDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    return [paths firstObject];
}


+ (NSString *)appRootDirectory
{
    NSString *path = [HRPathManager cacheDirectory];
    path = [path stringByAppendingPathComponent:kRootDir];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:path]) {
        
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    return path;
}

+ (BOOL)isDirectory:(NSString *)filePath
{
    NSError *error = nil;
    NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
    if (error == nil) {
        return [[attr fileType] isEqualToString:NSFileTypeDirectory];
    }
    
    return NO;
}

+ (BOOL)isReadOnly:(NSString *)filePath
{
    NSError *error = nil;
    NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
    if (error == nil) {
        return [attr fileIsImmutable];
    }
    
    return YES;
}

+ (unsigned long long)fileSize:(NSString *)filePath
{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
    if (error == nil) {
        return [attrs fileSize];
    }
    else {
        NSLog(@"get file size failed for %@", filePath);
        return 0;
    }
}

+ (unsigned long long)directorySize:(NSString *)directory
{
    unsigned long long dirSize = 0;
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:directory];
    NSString *file;
    @autoreleasepool {
        while (file = [dirEnum nextObject]) {
            // 跳过隐藏文件
            if ([file characterAtIndex:0] != '.') {
                NSString *path = [directory stringByAppendingPathComponent:file];
                dirSize += [HRPathManager fileSize:path];
            }
        }
    }
    
    return dirSize;
}

+ (NSDate *)fileCreationDate:(NSString *)filePath
{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
    if (error == nil) {
        return [attrs fileCreationDate];
    }
    else {
        NSLog(@"get file create failed for %@", filePath);
        return 0;
    }
}

//文件是否存在
+ (BOOL)fileExistsAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

@end
