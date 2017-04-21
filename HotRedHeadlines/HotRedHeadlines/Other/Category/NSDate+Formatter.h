//
//  NSDate+Formatter.h
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/22.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Formatter)
+ (NSString *)dateStringFromDate:(NSDate *)pDate;
+ (NSString *)dateStringForErrorLogViaDate:(NSDate *)date;
+ (NSString *)redDateForEveryday;
+ (NSString *)timtimeStr:(NSString *)timeStr;
+ (NSString *)weekdayStringFromDate:(NSDate*)inputDate;
+ (NSString *)timeStamp:(CFTimeInterval)timeStamp;
+ (NSString *)timeStamps:(CFTimeInterval)timeStamp;
@end
