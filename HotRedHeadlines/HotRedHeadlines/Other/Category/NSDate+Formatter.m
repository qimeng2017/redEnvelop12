//
//  NSDate+Formatter.m
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/22.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "NSDate+Formatter.h"

@implementation NSDate (Formatter)
+ (NSString *)dateStringFromDate:(NSDate *)pDate{
    
    NSString *timeString = @"";
    if (!pDate) {
        return timeString;
    }
    
    NSDate *dateA = pDate; //Post time
    NSDate *dateB = [NSDate date]; //Now
    
    //计算距离现在的时间长度
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit
                                               fromDate:dateA
                                                 toDate:dateB
                                                options:0];
    
    NSInteger year = components.year;
    NSInteger month = components.month;
    NSInteger day = components.day;
    NSInteger hour = components.hour;
    NSInteger minute = components.minute;
    
    NSDateComponents *postDateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:pDate];
    
    NSInteger pYear = postDateComponents.year;
    NSInteger pMonth = postDateComponents.month;
    NSInteger pDay = postDateComponents.day;
    NSInteger pHour = postDateComponents.hour;
    NSInteger pMinute = postDateComponents.minute;
    
    if (year > 0) {
        timeString = [NSString stringWithFormat:@"%li-%.2li-%.2li", (long)pYear, (long)pMonth, (long)pDay];
    }else if (month > 0){
        timeString = [NSString stringWithFormat:@"%.2li-%.2li", (long)pMonth, (long)pDay];
    }else if (day > 0){
        timeString = [NSString stringWithFormat:@"%.2li-%.2li", (long)pMonth, (long)pDay];
    }else if (hour > 0){
        timeString = [NSString stringWithFormat:@"%.2li:%.2li", (long)pHour, (long)pMinute];
    }else if (minute > 0){
        timeString = [NSString stringWithFormat:@"%.2li:%.2li", (long)pHour, (long)pMinute];
    }else{
        timeString = @"刚刚";
    }
    
    return timeString;
}

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *theComponents = [calendar components:NSCalendarUnitWeekday fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
    
}
+ (NSString *)dateStringForErrorLogViaDate:(NSDate *)date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSZ"];
    NSString *nsstr = [format stringFromDate:date];
    return nsstr;
}

+(NSString *)redDateForEveryday{
   NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *nsstr = [format stringFromDate:date];
    return nsstr;
}

+(NSDate *)getCurrentDate{
    //    1.通过date方法创建出来的对象,就是当前时间对象;
    NSDate *date = [NSDate date];
    return date;
}
+(NSTimeZone *)getCurrentZone{
    //   2.获取当前所处时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    return zone;
}
+(NSString*)getTime:(NSString *)type{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = type;
    NSString *res = [formatter stringFromDate:date];
    return res;
}
//提现记录
+(NSString *)timeStamp:(CFTimeInterval)timeStamp{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
    
}

//新闻，视频列表
+(NSString *)timeStamps:(CFTimeInterval)timeStamp{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
+(NSString *)timtimeStr:(NSString *)timeStr{
    
    
   
    NSTimeInterval time=[timeStr doubleValue];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSDate* date = [formatter dateFromString:timeStr];
    NSDate *datenow = [NSDate date];
    
    CFTimeInterval timeSp = [date timeIntervalSince1970];
    CFTimeInterval dateNow = [datenow timeIntervalSince1970];
    CFTimeInterval deltaTimeInSeconds = dateNow - timeSp;
    NSString *dateString;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:deltaTimeInSeconds];
    if (deltaTimeInSeconds < 60&&deltaTimeInSeconds>=0) {
        dateString = @"刚刚";
    }else if (deltaTimeInSeconds < 60*60&&deltaTimeInSeconds > 60) {
        [formatter setDateFormat:@"m"];
        NSString *timeS = [formatter stringFromDate:confromTimesp];
        dateString = [NSString stringWithFormat:@"%@分钟前",timeS];
    }else if(deltaTimeInSeconds < 60*60*24&&deltaTimeInSeconds > 60*60){
        [formatter setDateFormat:@"H"];
        NSString *timeS = [formatter stringFromDate:confromTimesp];
        dateString = [NSString stringWithFormat:@"%@小时前",timeS];
    }else if (deltaTimeInSeconds > 60*60*24){
        [formatter setDateFormat:@"MM-dd HH:mm"];
        NSString *timeS = [formatter stringFromDate:confromTimesp];
        dateString = timeS;
    }
    
    return dateString;
}

@end
