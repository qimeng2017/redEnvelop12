//
//  HRConfigPlist.m
//  HotRed
//
//  Created by 邹壮壮 on 2016/12/1.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRConfigPlist.h"
#import "HRVideoHeadModel.h"
@implementation HRConfigPlist
+ (HRConfigPlist *)sharedInstance
{
    static HRConfigPlist *_settings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _settings = [[HRConfigPlist alloc] init];
    });
    return _settings;
}
+(NSString *)path{
    //获取沙盒路径，创建plist文件，因为系统的list文件是只读属性，在沙盒中的文件才是可读和可写的，必须在沙盒中创建plist文件
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"personal.plist"];
    return filename;
}
+ (void)saveIsApproved:(BOOL)approved{
    //创建一个NSDictionary
    NSMutableDictionary *dictionary =[NSMutableDictionary dictionary];
    NSNumber *approvedBoolean =[[NSNumber alloc]initWithBool:approved];
    [dictionary setValue:approvedBoolean forKey:@"approved"];
    NSString *filePath = [HRConfigPlist path];
    [dictionary writeToFile:filePath atomically:YES];
   
}
+ (BOOL)readeIsApproved{
   NSString *filePath = [HRConfigPlist path];
    NSDictionary *dictionary = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    BOOL switchFlag=[(NSNumber*)[dictionary objectForKey:@"approved"]boolValue];
    return switchFlag;
}
+(NSArray *)localHeaderData{
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"headerInfo" ofType:@"plist"]];
    NSArray *headerArr = [dataDict objectForKey:@"Root"];
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dict in headerArr) {
        
        HRCategoryM *item = [[HRCategoryM alloc] init];
        [item updateDataFromDictionary:dict];
        
        [array addObject:item];
    }

    
    return array;
}
+(NSArray *)localVideoHeaderData{
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"videoHeaderInfo" ofType:@"plist"]];
    NSArray *headerArr = [dataDict objectForKey:@"Root"];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in headerArr) {
        HRVideoHeadModel *item = [[HRVideoHeadModel alloc]init];
        [item updateDataFromDictionary:dict];
        [array addObject:item];
    }
    return array;
}
@end
