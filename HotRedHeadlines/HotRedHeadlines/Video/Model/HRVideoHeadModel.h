//
//  HRVideoHeadModel.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/8.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRModel.h"

@interface HRVideoHeadModel : HRModel<NSCoding>
@property (nonatomic, copy) NSString *name;/**<解释*/
@property (nonatomic, strong) NSString *category;/**<解释*/
@property (nonatomic, copy) NSString *icon;
@end
