//
//  HRWebProgressLayer.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/16.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRWebProgressLayer.h"
#import "NSTimer+Extension.h"
static NSTimeInterval const kFastTimeInterval = 0.003;
@implementation HRWebProgressLayer
{
    CAShapeLayer *_layer;
    
    NSTimer *_timer;
    CGFloat _plusWidth; ///< 增加点
}
- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}


- (void)initialize {
    self.lineWidth = 2;
    self.strokeColor = [UIColor greenColor].CGColor;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:kFastTimeInterval target:self selector:@selector(pathChanged:) userInfo:nil repeats:YES];
    [_timer pause];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 2)];
    [path addLineToPoint:CGPointMake(kScreenWidth, 2)];
    
    self.path = path.CGPath;
    self.strokeEnd = 0;
    _plusWidth = 0.01;
}

- (void)pathChanged:(NSTimer *)timer {
    self.strokeEnd += _plusWidth;
    
    if (self.strokeEnd > 0.8) {
        _plusWidth = 0.002;
    }
}

- (void)startLoad {
    [_timer resumeWithTimeInterval:kFastTimeInterval];
}

- (void)finishedLoad {
    [self closeTimer];
    
    self.strokeEnd = 1.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        [self removeFromSuperlayer];
    });
}

- (void)dealloc {
    //    NSLog(@"progressView dealloc");
    [self closeTimer];
}

#pragma mark - private
- (void)closeTimer {
    [_timer invalidate];
    _timer = nil;
}

@end
