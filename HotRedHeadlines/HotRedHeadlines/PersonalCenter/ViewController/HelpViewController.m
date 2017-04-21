//
//  HelpViewController.m
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/26.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HelpViewController.h"
#import "HRHelpTableView.h"
@interface HelpViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    
        UIWebView *_webView;
        
        UIActivityIndicatorView     *_indicatorView;
}
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帮助";

    self.view.backgroundColor = [UIColor whiteColor];
    UIButton  *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    leftButton.frame = CGRectMake(0, 0, kLargeWidth, kLargeSize);
    UIBarButtonItem  *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    HRHelpTableView *tab = [[HRHelpTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:tab];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
    if (_webView == nil) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.view.frame))];
        webView.delegate = self;
        webView.scrollView.delegate = self;
        [self.view addSubview:webView];
        _webView = webView;
        
        //UIActivityIndicatorView
        {
            _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _indicatorView.frame = CGRectMake((CGRectGetWidth(self.view.frame) - CGRectGetWidth(_indicatorView.frame)) / 2, (CGRectGetHeight(self.view.frame) - CGRectGetHeight(_indicatorView.frame)) / 2, CGRectGetWidth(_indicatorView.frame), CGRectGetHeight(_indicatorView.frame));
            [self.view addSubview:_indicatorView];
            
        }
        NSString *url = [NSString stringWithFormat:@"%@/about/help",RED_ENVELOP_HOST_NAME];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
         [_indicatorView startAnimating];
        [_webView loadRequest:request];
    }
    


}
- (void)backAction{
    if ([_from isEqualToString:@"login"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
//- (void)webViewDidStartLoad:(UIWebView *)webView{
//     [_indicatorView startAnimating];
//}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
     [_indicatorView stopAnimating];
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
