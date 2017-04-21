//
//  HRVideoCell.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/8.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@protocol HRVideoCellDelegate <NSObject>

- (void)shareVideo:(VideoModel *)videoModel;

@end
@interface HRVideoCell : UITableViewCell
@property (nonatomic,weak)id<HRVideoCellDelegate>delegate;
@property (nonatomic,strong)VideoModel *videoModel;
@end
