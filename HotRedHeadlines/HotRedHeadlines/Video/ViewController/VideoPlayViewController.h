//
//  VideoPlayViewController.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/8.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoPlayViewController : UIViewController
- (instancetype)initWithURL:(NSURL *)url;
@property (nonatomic,strong)NSURL *aUrl;
@property (nonatomic, assign) BOOL showSubTitle;/**<默认显示子标题>*/
@property (nonatomic, strong) NSString *navigationTitle;/**<导航栏标题*/
@end
