//
//  HRWebViewController.h
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/22.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WDSocialShareType) {
    WDSHARE_WEIXIN = 33,
    WDSHARE_FRIEND_CIRCLE,
    WDSHARE_SINA,
    WDSHARE_DOUBAN,
    EXTRA_BTN_REPORT,
    EXTRA_BTN_DELETE,
    EXTRA_BTN_RENAME
    
};
@interface HRWebViewController : UIViewController
- (instancetype)initWithURL:(NSURL *)url;
@property (nonatomic,strong)NSURL *aUrl;
@property (nonatomic,strong)NSString *image_url;

@property (nonatomic, assign) BOOL showSubTitle;/**<默认显示子标题>*/
@property (nonatomic, strong) NSString *navigationTitle;/**<导航栏标题*/
@end
