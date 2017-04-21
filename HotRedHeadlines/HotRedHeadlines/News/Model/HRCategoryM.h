//
//  HRCategoryM.h
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/22.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRModel.h"

@interface HRCategoryM : HRModel<NSCoding>
@property (nonatomic, copy) NSString *name;/**<解释*/
@property (nonatomic, strong) NSString *categoryId;/**<解释*/
@property (nonatomic, copy) NSString *icon;
@end
