//
//  MultiPictureTableViewCell.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRNormalNews.h"
@interface MultiPictureTableViewCell : UITableViewCell
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *source;
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSString *imageUrl;
@property (nonatomic,strong)HRNormalNews *normalNews;
@end
