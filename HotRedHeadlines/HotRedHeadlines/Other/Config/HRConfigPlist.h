//
//  HRConfigPlist.h
//  HotRed
//
//  Created by 邹壮壮 on 2016/12/1.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRCategoryM.h"
#import "VideoModel.h"
@interface HRConfigPlist : NSObject
+ (HRConfigPlist *)sharedInstance;
+ (NSString *)path;
+ (void)saveIsApproved:(BOOL)approved;
+ (BOOL)readeIsApproved;
+ (NSArray *)localHeaderData;
+ (NSArray *)localVideoHeaderData;
@end
