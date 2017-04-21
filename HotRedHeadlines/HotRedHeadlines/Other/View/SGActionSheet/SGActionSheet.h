//
//  SGActionSheet.h
//  SGActionSheetExample
//
//  Created by Sorgle on 16/9/17.
//  Copyright © 2016年 Sorgle. All rights reserved.
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //
//
//  - - 如在使用中, 遇到什么问题或者有更好建议者, 请于kingsic@126.com邮箱联系 - - - - //
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - GitHub下载地址 https://github.com/kingsic/SGActionSheet.git - - - - - //
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

#import <UIKit/UIKit.h>
@class SGActionSheet;

@protocol SGActionSheetDelegate <NSObject>

- (void)SGActionSheet:(SGActionSheet *)actionSheet didSelectRowAtIndexPath:(NSInteger)indexPath;

@end

@interface SGActionSheet : UIView

/** 提示信息文字颜色设置(系统默认是黑色)*/
@property (nonatomic, strong) UIColor *messageTextColor;

/** 提示信息文字大小设置(系统默认是17)*/
@property (nonatomic, strong) UIFont *messageTextFont;

/** 其他标题文字颜色设置(系统默认是黑色)*/
@property (nonatomic, strong) UIColor *otherTitleColor;

/** 其他标题文字大小设置(系统默认是17)*/
@property (nonatomic, strong) UIFont *otherTitleFont;

/** 取消标题文字颜色设置(系统默认是黑色)*/
@property (nonatomic, strong) UIColor *cancelButtonTitleColor;

/** 取消标题文字大小设置(系统默认是17)*/
@property (nonatomic, strong) UIFont *cancelButtonTitleFont;

@property (nonatomic, weak) id<SGActionSheetDelegate> delegate_SG;


- (instancetype)initWithTitle:(NSString *)title delegate:(id<SGActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitleArray:(NSArray *)otherButtonTitleArray;

+ (instancetype)actionSheetWithTitle:(NSString *)title delegate:(id<SGActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitleArray:(NSArray *)otherButtonTitleArray;

- (void)show;

@end
