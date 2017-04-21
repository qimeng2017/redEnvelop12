//
//  VideoViewController.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/8.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoContentTableVC.h"
#import "HRVideoHeadModel.h"
#import "HRConfigPlist.h"
@interface VideoViewController ()<UINavigationControllerDelegate>

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航控制器的代理为self
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpAllViewController];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

// 添加所有子控制器
- (void)setUpAllViewController
{

    
    NSArray *arr = [HRConfigPlist localVideoHeaderData];
    for (HRVideoHeadModel *categoryM in arr) {
        VideoContentTableVC *wordVc1 = [[VideoContentTableVC alloc] init];
        wordVc1.title = categoryM.category;
        [self addChildViewController:wordVc1];
    }
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
