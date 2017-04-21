//
//  CenterInvitationCell.h
//  
//
//  Created by 邹壮壮 on 2016/12/7.
//
//

#import <UIKit/UIKit.h>

@protocol CenterInvitationCellDelegate <NSObject>

- (void)tap:(NSInteger)index view:(UIView *)view;

@end
@interface CenterInvitationCell : UITableViewCell
@property (nonatomic,weak)id<CenterInvitationCellDelegate>delegate;
@property (nonatomic,strong)NSString *conten;
@end
