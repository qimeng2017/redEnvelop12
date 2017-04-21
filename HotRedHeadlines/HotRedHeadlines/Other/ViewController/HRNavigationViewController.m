//
//  HRNavigationViewController.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRNavigationViewController.h"

@interface HRNavigationViewController ()

@end

@implementation HRNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    UIColor *color = [UIColor grayColor];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:color   forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes = dic;
    self.navigationBar.translucent = NO;
    self.navigationBar.hidden = NO;

    
}

-(void)dealloc {
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateHighlighted];
        button.frame = CGRectMake(0, 0, 30, 30);
        // 让按钮内部的所有内容左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        [button sizeToFit];
        // 让按钮的内容往左边偏移10
        //        button.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
        
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        // 修改导航栏左边的item
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

-(void)didReceiveMemoryWarning {
    [[SDImageCache sharedImageCache] clearDisk];
    
}


@end
