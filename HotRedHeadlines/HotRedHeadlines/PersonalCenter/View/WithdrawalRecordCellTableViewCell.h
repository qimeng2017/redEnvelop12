//
//  WithdrawalRecordCellTableViewCell.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/12.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WithdrawalRecordCellTableViewCellDelegate <NSObject>

- (void)didSelectView:(UIView *)view content:(NSDictionary *)contentDict;

@end
@interface WithdrawalRecordCellTableViewCell : UITableViewCell
@property (nonatomic,weak)id<WithdrawalRecordCellTableViewCellDelegate>delegate;
@property (nonatomic,strong)NSDictionary *contentDict;
@end
