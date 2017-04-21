//
//  HRSettings.h
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/22.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRModel.h"

@interface HRSettings : HRModel
+ (HRSettings *)sharedInstance;

@property (nonatomic, strong) NSArray  *tags;/**<解释*/
@property (nonatomic)         BOOL     isApproved;
@property (nonatomic,strong)  NSNumber *countNumber;
@end
