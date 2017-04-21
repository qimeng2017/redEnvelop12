//
//  TopInvitationCell.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/7.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopInvitationCellDelegate <NSObject>

- (void)viewYourInvitationHistory;

@end
@interface TopInvitationCell : UITableViewCell
@property (nonatomic,weak)id<TopInvitationCellDelegate>delegate;
@property (nonatomic,strong)NSString *money;
@end
