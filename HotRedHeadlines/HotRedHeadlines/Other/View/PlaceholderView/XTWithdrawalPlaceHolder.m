//
//  XTWithdrawalPlaceHolder.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/14.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//
static float const kUIemptyOverlayWLabelX         = 0;
static float const kUIemptyOverlayWLabelY         = 0;
static float const kUIemptyOverlayWLabelHeight    = 20;


#import "XTWithdrawalPlaceHolder.h"
@interface XTWithdrawalPlaceHolder ()

@property (nonatomic, strong) UIImageView *emptyOverlayImageView;

@end
@implementation XTWithdrawalPlaceHolder
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (instancetype)sharedInit {
    self.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    self.contentMode =   UIViewContentModeTop;
    [self addUIemptyOverlayImageView];
    [self addUIemptyOverlayLabel];
    [self setupUIemptyOverlay];
    return self;
}

- (void)addUIemptyOverlayImageView {
    self.emptyOverlayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    self.emptyOverlayImageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2 - 100);
    self.emptyOverlayImageView.image = [UIImage imageNamed:@"WebView_LoadFail_Refresh_Icon"];
    [self addSubview:self.emptyOverlayImageView];
}

- (void)addUIemptyOverlayLabel {
    CGRect emptyOverlayViewFrame = CGRectMake(kUIemptyOverlayWLabelX, kUIemptyOverlayWLabelY, CGRectGetWidth(self.frame), kUIemptyOverlayWLabelHeight);
    UILabel *emptyOverlayLabel = [[UILabel alloc] initWithFrame:emptyOverlayViewFrame];
    emptyOverlayLabel.textAlignment = NSTextAlignmentCenter;
    emptyOverlayLabel.numberOfLines = 0;
    emptyOverlayLabel.backgroundColor = [UIColor clearColor];
    emptyOverlayLabel.text = @"你还没有任何提现记录！！";
    emptyOverlayLabel.font = [UIFont boldSystemFontOfSize:15];
    emptyOverlayLabel.frame = ({
        CGRect frame = emptyOverlayLabel.frame;
        frame.origin.y = CGRectGetMaxY(self.emptyOverlayImageView.frame) + 10;
        frame;
    });
    emptyOverlayLabel.textColor = [UIColor grayColor];
    [self addSubview:emptyOverlayLabel];
}

- (void)setupUIemptyOverlay {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPressUIemptyOverlay = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressUIemptyOverlay:)];
    [longPressUIemptyOverlay setMinimumPressDuration:0.001];
    [self addGestureRecognizer:longPressUIemptyOverlay];
    self.userInteractionEnabled = YES;
}

- (void)longPressUIemptyOverlay:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.emptyOverlayImageView.alpha = 0.4;
    }
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        self.emptyOverlayImageView.alpha = 1;
        if ([self.delegate respondsToSelector:@selector(emptyOverlayClicked:)]) {
            [self.delegate emptyOverlayClicked:nil];
        }
    }
}


@end