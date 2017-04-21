//
//  XTInvitationHostoryView.m
//  HotRedHeadlines
//
//  Created by 邹壮壮 on 2016/12/7.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//
static float const kUIemptyOverlayLabelX         = 0;
static float const kUIemptyOverlayLabelY         = 0;
static float const kUIemptyOverlayLabelHeight    = 20;
#import "XTInvitationHostoryView.h"
#import "KBRoundedButton.h"
@interface XTInvitationHostoryView ()
@property (nonatomic, strong) UIImageView *emptyOverlayImageView;
@end
@implementation XTInvitationHostoryView
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
    self.emptyOverlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_invitation_people"]];
    self.emptyOverlayImageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2 - 100);
//    self.emptyOverlayImageView.image = [UIImage imageNamed:@"no_invitation_people"];
    [self addSubview:self.emptyOverlayImageView];
}

- (void)addUIemptyOverlayLabel {
    CGRect emptyOverlayViewFrame = CGRectMake(kUIemptyOverlayLabelX, kUIemptyOverlayLabelY, CGRectGetWidth(self.frame), kUIemptyOverlayLabelHeight);
    UILabel *emptyOverlayLabel = [[UILabel alloc] initWithFrame:emptyOverlayViewFrame];
    emptyOverlayLabel.textAlignment = NSTextAlignmentCenter;
    emptyOverlayLabel.numberOfLines = 0;
    emptyOverlayLabel.textColor = [UIColor grayColor];
    emptyOverlayLabel.backgroundColor = [UIColor clearColor];
    emptyOverlayLabel.text = @"你还没有邀请成功任何人";
    emptyOverlayLabel.font = [UIFont boldSystemFontOfSize:15];
    emptyOverlayLabel.frame = ({
        CGRect frame = emptyOverlayLabel.frame;
        frame.origin.y = CGRectGetMaxY(self.emptyOverlayImageView.frame) + 10;
        frame;
    });
    emptyOverlayLabel.textColor = [UIColor grayColor];
    [self addSubview:emptyOverlayLabel];
    
    //btn
    CGRect emptyOverlayViewFrameBtn = CGRectMake((kScreenWidth - 150)/2, kUIemptyOverlayLabelY, 150, 40);
    KBRoundedButton *emptyOverlayBtn = [[KBRoundedButton alloc] initWithFrame:emptyOverlayViewFrameBtn];
    
    emptyOverlayBtn.backgroundColor = [UIColor redColor];
    
    [emptyOverlayBtn setTitle:@"马上去邀请" forState:UIControlStateNormal];
    emptyOverlayBtn.frame = ({
        CGRect frame = emptyOverlayBtn.frame;
        frame.origin.y = CGRectGetMaxY(emptyOverlayLabel.frame) + 30;
        frame;
    });
    [self addSubview:emptyOverlayBtn];
}
- (void)UIemptyOverlayBtn{
    
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
