//
//  HRPathManager.h
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/21.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRPathManager : NSObject
//需要iCloud备份的文件保存于此
+ (NSString *)iCloudDirectory;

//临时文件保存目录
+ (NSString *)tempDirectory;

//一些持久化数据等保存
+ (NSString *)cacheDirectory;

//文件存储根目录
+ (NSString *)appRootDirectory;

//判断是否为文件夹
+ (BOOL)isDirectory:(NSString *)filePath;

//是否文件可读
+ (BOOL)isReadOnly:(NSString *)filePath;

//文件大小
+ (unsigned long long)fileSize:(NSString *)filePath;

//获取文件夹大小
+ (unsigned long long)directorySize:(NSString *)directory;

//文件创建日期
+ (NSDate *)fileCreationDate:(NSString *)filePath;

//文件是否存在
+ (BOOL)fileExistsAtPath:(NSString *)filePath;

@end
