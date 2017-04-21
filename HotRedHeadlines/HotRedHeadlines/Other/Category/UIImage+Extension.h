//
//  UIImage+Extension.h
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/16.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size;
+ (UIImage *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;
+ (UIImage *)filerWithOriginalImage:(UIImage *)image fileterName:(NSString *)name;
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image saturation:(CGFloat)saturation brightness:(CGFloat)brightness contrast:(CGFloat)contrast;
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame;
+ (UIImage *)shotWithView:(UIView *)view;
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope;
@end
