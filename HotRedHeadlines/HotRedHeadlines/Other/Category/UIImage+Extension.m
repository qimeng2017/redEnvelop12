//
//  UIImage+Extension.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/16.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
/**
 *  压缩图片到指定尺寸大小
 *
 *  @param image 原始图片
 *  @param size  目标大小
 *
 *  @return 生成图片
 */
+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size{
    UIImage * resultImage = image;
    UIGraphicsBeginImageContext(size);
    [resultImage drawInRect:CGRectMake(00, 0, size.width, size.height)];
    UIGraphicsEndImageContext();
    return image;
}
/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片
 */
+ (UIImage *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1024.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1024.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}
/**
 *  对图片进行滤镜处理
 *
 *  @param image 目标图片
 *  @param name  滤镜名称
 *
 *  @return 完成图片
 */
+ (UIImage *)filerWithOriginalImage:(UIImage *)image fileterName:(NSString *)name{
    CIContext * context = [CIContext contextWithOptions:nil];
    CIImage * inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter * filter = [CIFilter filterWithName:name];
    [filter setValue:inputImage forKey:kCIInputEVKey];
    CIImage * result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage * resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return resultImage;
}
/**
 *  调整图片饱和度、亮度、对比度
 *
 *  @param image      目标图片
 *  @param saturation 饱和度
 *  @param brightness 亮度：-1.0 ~ 1.0
 *  @param contrast   对比度
 *
 *  @return 完成图片
 */
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image saturation:(CGFloat)saturation brightness:(CGFloat)brightness contrast:(CGFloat)contrast{
    CIContext * context = [CIContext contextWithOptions:nil];
    CIImage * inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter * filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    [filter setValue:@(saturation) forKey:@"inputSaturation"];
    [filter setValue:@(brightness) forKey:@"inputBrightness"];
    [filter setValue:@(contrast) forKey:@"inputContrast"];
    
    CIImage * result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage * resultImage = [UIImage imageWithCGImage:cgImage];;
    CGImageRelease(cgImage);
    return resultImage;
}
/**
 *  创建一张实时模糊效果 View (毛玻璃效果)
 *
 *  @param frame frame
 *
 *  @return effectView
 */
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame{
    UIBlurEffect * effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = frame;
    return effectView;
}
/**
 *  截取一张 view 生成图片
 *
 *  @param view 目标View
 *
 *  @return 生成的图片
 */
+ (UIImage *)shotWithView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/**
 *  截取view中某个区域生成一张图片(先截取View)
 *
 *  @param view  目标View
 *  @param scope 目标大小
 *
 *  @return 生成的图片
 */
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self shotWithView:view].CGImage, scope);
    UIGraphicsBeginImageContext(scope.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, scope.size.width, scope.size.height);
    CGContextTranslateCTM(context, 0, rect.size.height);//  下移
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextDrawImage(context, rect, imageRef);
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGContextRelease(context);
    return image;
}
@end
