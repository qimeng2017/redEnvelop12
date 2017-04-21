//
//  LoginViewController.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginSucess:(BOOL)isaApp;

@end
@interface LoginViewController : UIViewController
@property (nonatomic,weak)id<LoginViewControllerDelegate>delegate;
@end
