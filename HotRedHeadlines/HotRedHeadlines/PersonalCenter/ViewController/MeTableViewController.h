//
//  MeTableViewController.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MeTableViewControllerDelegate <NSObject>
@optional
- (void)shakeCanChangeSkin:(BOOL)status;

@end
@interface MeTableViewController : UITableViewController
@property(nonatomic, weak) id<MeTableViewControllerDelegate> delegate;
@property (nonatomic, weak) UISwitch *changeSkinSwitch;
@end
