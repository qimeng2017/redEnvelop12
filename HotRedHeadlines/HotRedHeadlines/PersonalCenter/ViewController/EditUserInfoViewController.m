//
//  EditUserInfoViewController.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "EditUserInfoViewController.h"

@interface EditUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation EditUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    [self setupBasic];
    // Do any additional setup after loading the view from its nib.
}
-(void)setupBasic {
    self.title = @"个人信息";
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"headerImage"];
    self.headerImageView.image = [UIImage imageWithContentsOfFile:path];
    self.headerImageView.userInteractionEnabled = YES;
//    [self.headerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeaderImage)]];
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width *0.5;
    self.headerImageView.layer.masksToBounds = YES;
    self.nameTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:UserNameKey];
  
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:self.nameTextField.text forKey:UserNameKey];
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
