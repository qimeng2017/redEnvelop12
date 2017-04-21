//
//  HRTextfieldView.h
//  HotRed
//
//  Created by 邹壮壮 on 2016/12/1.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRTextfieldView : UIView
@property (nonatomic,strong)UILabel *desLable;
@property (nonatomic,strong)UITextField *textfield;
@property (nonatomic,strong)UILabel *contentLable;
- (instancetype)initWithFrame:(CGRect)frame desLableText:(NSString *)desLableText placeholder:(NSString *)placeholder isHidden:(BOOL)isHidden;
@end
