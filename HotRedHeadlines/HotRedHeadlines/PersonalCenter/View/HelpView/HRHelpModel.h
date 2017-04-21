//
//  HRHelpModel.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/15.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRHelpModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *problem;
@property (nonatomic, strong) NSString *answer;
- (void)readFromJSONDictionary:(NSDictionary *)d;
@end
