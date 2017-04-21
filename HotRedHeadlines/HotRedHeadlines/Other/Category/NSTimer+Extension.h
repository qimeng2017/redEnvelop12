//
//  NSTimer+Extension.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/16.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Extension)
- (void)pause;
- (void)resume;
- (void)resumeWithTimeInterval:(NSTimeInterval)time;
@end
