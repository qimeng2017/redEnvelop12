//
//  HRDataTool.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRDataTool.h"
#import <FMDB.h>
@implementation HRDataTool
static FMDatabaseQueue *_queue;
+ (void)initialize {
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"data.sqlite"];
    //    NSLog(@"%@",path);
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists table_video(id integer primary key autoincrement, idstr text, time integer, video blob);"];
        
        [db executeUpdate:@"create table if not exists table_picture(id integer primary key autoincrement, idstr text, time integer, picture blob);"];
        
        [db executeUpdate:@"create table if not exists table_ttheadernews(id integer primary key autoincrement, title text, url text, desc text, picUrl text, ctime text);"];
        
        [db executeUpdate:@"create table if not exists table_normalnews(id integer primary key autoincrement, channelid text, title text, imageurls blob, desc text, link text, pubdate text, createdtime integer, source text);"];
        [db executeUpdate:@"create table if not exists table_videocomment(id integer primary key autoincrement, idstr text, page integer, hotcommentarray blob, latestcommentarray blob, total integer);"];
    }];
}
+ (void)deletePartOfCacheInSqlite {
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from table_video where id > 20"];
        [db executeUpdate:@"delete from table_picture where id > 20"];
        [db executeUpdate:@"delete from table_normalnews where id > 20"];
        [db executeUpdate:@"delete from table_ttheadernews where id > 5"];
    }];
}
@end
