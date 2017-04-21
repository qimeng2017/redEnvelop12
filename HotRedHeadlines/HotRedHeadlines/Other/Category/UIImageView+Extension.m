//
//  UIImageView+Extension.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/5.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "UIImageView+Extension.h"
#import "HRJudgeNetworking.h"
@implementation UIImageView (Extension)
-(void)TT_setImageWithURL:(NSURL *)url {
    if ([self currentImageDownLoadMode] == NO || url == nil) {
        self.image = [UIImage imageNamed:@"allplaceholderImage"];
        return;
    }
    [self sd_setImageWithURL:url];
}

-(void)TT_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(void (^)(UIImage *image, NSError *error))complete {
    if ([self currentImageDownLoadMode] == NO || url == nil) {
        NSError *error = [NSError errorWithDomain:@"example.com" code:500 userInfo:nil];
        complete(placeholder,error);
        return;
    }
    
    [self sd_setImageWithURL:url placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        complete(image,error);
    }];
}

- (void)TT_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(NSInteger)options progress:(void (^)(NSInteger receivedSize, NSInteger expectedSize))progressBlock completed:(void (^)(UIImage *image, NSError *error))complete {
    if ([self currentImageDownLoadMode] == NO || url == nil) {
        NSError *error = [NSError errorWithDomain:@"example.com" code:500 userInfo:nil];
        progressBlock(100, 100);
        complete(placeholder,error);
        return;
    }
    
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        progressBlock(receivedSize, expectedSize);
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        complete(image,error);
    }];
    
}

- (void)TT_setImageAfterClickWithURL:(NSURL *)url {
    [self sd_setImageWithURL:url];
}

- (BOOL)currentImageDownLoadMode {
    BOOL isDownLoadNoImageIn3G = [[NSUserDefaults standardUserDefaults] boolForKey:IsDownLoadNoImageIn3GKey];
    if (isDownLoadNoImageIn3G == YES && [HRJudgeNetworking currentNetworkingType] != NetworkingTypeWiFi) {//在设置中选择了智能无图，并且当前网络非Wifi
        return NO;
    }
    return YES;
}

@end
