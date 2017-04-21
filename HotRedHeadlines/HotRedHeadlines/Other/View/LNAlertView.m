//
//  LNAlertView.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2016/12/28.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "LNAlertView.h"
#import <objc/runtime.h>
static CGFloat const kDefaultContainerWidth = 280.;
static CGFloat const kTitleMessageSpace = 12;
static CGFloat const kAlertContentViewMinHeight = 80.0;
static CGFloat const kAlertButtonHeight = 44.0;
static CGFloat const kMaxMessageHeight = 220;

#define kAlertLineSpace 0.5
#define kButtonTitleColor [UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f]
#define kDestructiveButtonTitleColor [UIColor colorWithRed:0.988 green:0.239 blue:0.224 alpha:1.00]
#define kDefaultAnimationDuration 0.25
#define kDefaultCustomViewSize CGSizeMake(280, 240)

CGSize LNAlertView_SizeOfLabel(NSString *text, UIFont *font, CGSize constraintSize){
    NSDictionary *attrs = @{NSFontAttributeName:font};
    CGSize aSize = [text boundingRectWithSize:constraintSize
                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                   attributes:attrs
                                      context:nil].size;
    return CGSizeMake(aSize.width, aSize.height+1);
}

#define SIZE_LABEL(text, font, constraintSize) LNAlertView_SizeOfLabel(text, font, constraintSize)

@interface UIViewController (__backgroundView)
- (UIView *)backgroundView;
@end

static void* __backgroundViewKey = &__backgroundViewKey;
@implementation UIViewController (__backgroundView)
- (UIView *)backgroundView
{
    UIView *v = objc_getAssociatedObject(self, __backgroundViewKey);
    if(!v){
        v = [[UIView alloc] initWithFrame:self.view.bounds];
        v.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
        v.autoresizingMask = self.view.autoresizingMask;
        [self.view addSubview:v];
        
        objc_setAssociatedObject(self, __backgroundViewKey, v, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return v;
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

#pragma Mark-- Private classes headers

@interface LNBlurSupportedBackgroundView : UIView
@property(nonatomic, strong) UIView *backgroundView;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
@property(nonatomic, strong) UIVisualEffectView *blurView;
#endif
@property(nonatomic, assign) BOOL blurEnabled;
- (void)prepareViews;
+ (BOOL)canBlur;
- (void)applyBlurEffect;
@end

@interface LNAlertButtonItem : UIButton
@property(nonatomic, weak) LNAlertView *alertView;
@property(nonatomic, strong) LNBlurSupportedBackgroundView *backgroundView;
@property(nonatomic, copy) void(^actionHanlder)(LNAlertView *alertView, LNAlertButtonItem *buttonItem);
@end

@interface LNAlertContentView : LNBlurSupportedBackgroundView
@property(nonatomic, weak) LNAlertView *alertView;
@property(nonatomic, strong, readonly) UILabel *titleLabel;
@property(nonatomic, strong, readonly) UILabel *messageLabel;
@property(nonatomic, assign) CGSize preferredFrameSize;
@property(nonatomic, assign) UIEdgeInsets contentInsets;
- (void)setTitle:(NSString *)title message:(NSString *)message;
- (CGSize)getFitSize;
@end

@interface LNAlertViewController : UIViewController
@property (nonatomic, weak) LNAlertView *alertView;
@property (nonatomic, assign) BOOL rootViewControllerPrefersStatusBarHidden;
@end

@interface LNAlertViewQueue : NSObject
@property(nonatomic, strong) LNAlertView *currentAlertView;
@property(nonatomic, assign, getter=isAnimating) BOOL animating;
+ (instancetype)sharedQueue;
- (BOOL)contains:(LNAlertView *)alertView;
- (LNAlertView *)dequeue;
- (void)enqueue:(LNAlertView *)alertView;
- (void)remove:(LNAlertView *)alertView;
@end

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

@interface LNAlertView ()
{
    LNAlertContentView *_contentView;
}
@property(nonatomic, strong) NSMutableArray *buttons;
@property(nonatomic, strong) UIWindow *lastKeyWindow;
@property(nonatomic, strong) UIWindow *currentKeyWindow;
@property(nonatomic, assign, getter = isVisible) BOOL visible;
@property(nonatomic, strong) UIFont *appearanceMessageFontBeforeChanging;
@property(nonatomic, assign) BOOL customViewVisible;
@property(nonatomic, assign) LNCustomViewPresentationStyle customViewPresentationStyle;
@end

@implementation LNAlertView

+ (void)initialize
{
    if (self == [LNAlertView class]) {
        [LNAlertView appearance].titleColor = [UIColor blackColor];
        [LNAlertView appearance].messageColor = [UIColor blackColor];
        [LNAlertView appearance].titleFont = [UIFont boldSystemFontOfSize:17.0];
        [LNAlertView appearance].messageFont = [UIFont systemFontOfSize:14.0];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame]){
        self.userInteractionEnabled = YES;
        self.layer.cornerRadius = 8;
        self.clipsToBounds = YES;
        
        _buttons = @[].mutableCopy;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
{
    if(self=[self initWithFrame:CGRectZero]){
        
        self.customViewVisible = NO;
        
        _contentView = [[LNAlertContentView alloc] initWithFrame:CGRectZero];
        _contentView.alertView = self;
        _contentView.contentInsets = UIEdgeInsetsMake(20, 15, 20, 15);
        [self addSubview:_contentView];
        [_contentView setTitle:[title copy] message:[message copy]];
        
        if(cancelButtonTitle&&cancelButtonTitle.length>0){
            [self addButtonWithTitle:cancelButtonTitle style:LNAlertActionStyleCancel handler:^(LNAlertView *alertView, LNAlertButtonItem *buttonItem) {
                [alertView dismiss];
            }];
        }
    }
    return self;
}

- (instancetype)initWithCustomView:(UIView *)customView
{
    if(self=[self initWithCustomView:customView withPresentationStyle:Default]){
        
    }
    return self;
}

- (instancetype)initWithCustomView:(UIView *)customView withPresentationStyle:(LNCustomViewPresentationStyle)style
{
    if(self=[self initWithFrame:CGRectZero]){
        self.customViewPresentationStyle = style;
        self.customViewVisible = YES;
        
        _contentView = [[LNAlertContentView alloc] initWithFrame:CGRectZero];
        _contentView.alertView = self;
        [self addSubview:_contentView];
        if(CGSizeEqualToSize(customView.frame.size, CGSizeZero)){
            _contentView.preferredFrameSize = kDefaultCustomViewSize;
        }
        else{
            _contentView.preferredFrameSize = customView.frame.size;
        }
        _contentView.frame = CGRectMake(0, 0, _contentView.preferredFrameSize.width, _contentView.preferredFrameSize.height);
        [_contentView addSubview:customView];
        customView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)addButtonWithTitle:(NSString *)title style:(LNAlertActionStyle)style handler:(void(^)(LNAlertView *alertView, LNAlertButtonItem *buttonItem))handler
{
    if(self.customViewVisible){
        return;
    }
    LNAlertButtonItem *button = [[LNAlertButtonItem alloc] initWithFrame:CGRectZero];
    button.alertView = self;
    button.actionHanlder = handler;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:kButtonTitleColor forState:UIControlStateNormal];
    [self addSubview:button];
    switch (style) {
        case LNAlertActionStyleCancel:
            button.titleLabel.font = [UIFont boldSystemFontOfSize:button.titleLabel.font.pointSize];
            break;
        case LNAlertActionStyleDestructive:
            [button setTitleColor:kDestructiveButtonTitleColor forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    [_buttons addObject:button];
    
    [self updateUILayouts];
}

- (void)addDefaultStyleButtonWithTitle:(NSString *)title handler:(void(^)(LNAlertView *alertView, LNAlertButtonItem *buttonItem))handler
{
    [self addButtonWithTitle:title style:LNAlertActionStyleDefault handler:handler];
}

- (void)updateUILayouts
{
    if(self.customViewVisible){
        return;
    }
    
    CGSize size = [_contentView getFitSize];
    _contentView.frame = CGRectMake(0, 0, kDefaultContainerWidth, size.height);
    
    if(_buttons.count==1){
        LNAlertButtonItem *button = _buttons[0];
        button.frame = CGRectMake(0, CGRectGetMaxY(_contentView.frame)+kAlertLineSpace, kDefaultContainerWidth, kAlertButtonHeight);
    }
    else if(_buttons.count==2){
        
        CGFloat originY = CGRectGetMaxY(_contentView.frame)+kAlertLineSpace;
        
        NSInteger leftItemWidth = (kDefaultContainerWidth-kAlertLineSpace)/2;
        LNAlertButtonItem *button = _buttons[0];
        button.frame = CGRectMake(0, originY, leftItemWidth, kAlertButtonHeight);
        
        CGFloat originX = leftItemWidth + kAlertLineSpace;
        CGFloat rightItemWidth = kDefaultContainerWidth-originX;
        button = _buttons[1];
        button.frame = CGRectMake(originX, originY, rightItemWidth, kAlertButtonHeight);
    }
    else if(_buttons.count>2){
        
        UIView *lastView = _contentView;
        
        for(int i=0;i<_buttons.count;i++){
            LNAlertButtonItem *button = _buttons[i];
            button.translatesAutoresizingMaskIntoConstraints = YES;
            button.frame = CGRectMake(0, CGRectGetMaxY(lastView.frame)+kAlertLineSpace, kDefaultContainerWidth, kAlertButtonHeight);
            lastView = button;
        }
    }
    
    [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize
{
    if(self.customViewVisible){
        return _contentView.frame.size;
    }
    
    CGFloat maxHeight;
    CGSize size = [_contentView getFitSize];
    maxHeight = size.height;
    
    if(_buttons.count<3){
        maxHeight += kAlertButtonHeight+kAlertLineSpace;
    }
    else{
        maxHeight += _buttons.count*(kAlertLineSpace+kAlertButtonHeight);
    }
    return CGSizeMake(kDefaultContainerWidth, maxHeight);
}

- (void)applyBlurEffect
{
    [_contentView applyBlurEffect];
    for(LNAlertButtonItem *item in _buttons){
        [item.backgroundView applyBlurEffect];
    }
}

- (void)showWithAnimation:(BOOL)animated completion:(dispatch_block_t)completion
{
    if(animated){
        NSTimeInterval _duration = kDefaultAnimationDuration;
        if(self.currentKeyWindow.rootViewController.view){
            self.currentKeyWindow.rootViewController.backgroundView.alpha = 0;
        }
        if(self.customViewVisible){
            
            if(self.customViewPresentationStyle==Default){
                self.transform = CGAffineTransformMakeScale(1.2, 1.2);
            }
            else if(self.customViewPresentationStyle==MoveUp){
                _duration = 0.35;
                self.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height);
            }
            else if (self.customViewPresentationStyle==MoveDown){
                _duration = 0.35;
                self.transform = CGAffineTransformMakeTranslation(0, -[UIScreen mainScreen].bounds.size.height);
            }
        }
        else{
            self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }
        
        [UIView animateWithDuration:_duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if(self.customViewVisible){
                if(self.customViewPresentationStyle==Default){
                    
                }
                else if(self.customViewPresentationStyle==MoveUp){
                    
                }
            }
            self.transform = CGAffineTransformIdentity;
            if(self.currentKeyWindow.rootViewController.view){
                self.currentKeyWindow.rootViewController.backgroundView.alpha = 1;
            }
        } completion:^(BOOL finished) {
            if(completion){
                completion();
            }
        }];
    }
    else{
        if(completion){
            completion();
        }
    }
}

- (void)hideWithAnimation:(BOOL)animated completion:(dispatch_block_t)completion
{
    [[LNAlertViewQueue sharedQueue] remove:self];
    self.visible = NO;
    
    if(animated){
        [LNAlertViewQueue sharedQueue].animating = YES;
        NSTimeInterval _duration = kDefaultAnimationDuration;
        if(self.customViewVisible){
            if(self.customViewPresentationStyle==Default){
                
            }
            else if(self.customViewPresentationStyle==MoveUp){
                _duration = 0.35;
            }
            else if (self.customViewPresentationStyle==MoveDown){
                _duration = 0.35;
            }
        }
        
        [UIView animateWithDuration:_duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if(self.customViewVisible){
                if(self.customViewPresentationStyle==Default){
                    self.alpha = 0;
                    self.transform = CGAffineTransformMakeScale(0.75,0.75);
                }
                else if(self.customViewPresentationStyle==MoveUp){
                    self.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height);
                }
                else if (self.customViewPresentationStyle==MoveDown){
                    self.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height);
                }
            }
            if(self.currentKeyWindow.rootViewController.view){
                self.currentKeyWindow.rootViewController.backgroundView.alpha = 0;
            }
        } completion:^(BOOL finished) {
            [LNAlertViewQueue sharedQueue].animating = NO;
            [LNAlertViewQueue sharedQueue].currentAlertView = nil;
            if(completion){
                completion();
            }
        }];
    }
    else{
        self.alpha = 0;
        [LNAlertViewQueue sharedQueue].animating = NO;
        [LNAlertViewQueue sharedQueue].currentAlertView = nil;
        if(completion){
            completion();
        }
    }
}

- (void)show
{
    if(_buttons.count==0 && !self.customViewVisible){
        [self addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:LNAlertActionStyleCancel handler:^(LNAlertView *alertView, LNAlertButtonItem *buttonItem) {
            [alertView dismiss];
        }];
    }
    
    if(![[LNAlertViewQueue sharedQueue] contains:self]){
        [[LNAlertViewQueue sharedQueue] enqueue:self];
    }
    
    if([LNAlertViewQueue sharedQueue].isAnimating){
        return;
    }
    
    if(self.isVisible){
        return;
    }
    
    if([LNAlertViewQueue sharedQueue].currentAlertView.isVisible){
        return;
    }
    
    self.visible = YES;
    [LNAlertViewQueue sharedQueue].currentAlertView = self;
    [LNAlertViewQueue sharedQueue].animating = YES;
    
    self.lastKeyWindow = [UIApplication sharedApplication].keyWindow;
    LNAlertViewController *viewController = [[LNAlertViewController alloc] initWithNibName:nil bundle:nil];
    viewController.alertView = self;
    if ([self.lastKeyWindow.rootViewController respondsToSelector:@selector(prefersStatusBarHidden)]) {
        viewController.rootViewControllerPrefersStatusBarHidden = self.lastKeyWindow.rootViewController.prefersStatusBarHidden;
    }
    if (!self.currentKeyWindow) {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        window.opaque = NO;
        window.windowLevel = UIWindowLevelAlert;
        window.rootViewController = viewController;
        self.currentKeyWindow = window;
    }
    self.currentKeyWindow.frame = [UIScreen mainScreen].bounds;
    [self.currentKeyWindow makeKeyAndVisible];
    
    [self showWithAnimation:YES completion:^{
        [LNAlertViewQueue sharedQueue].animating = NO;
        
        [self applyBlurEffect];
        
    }];
}

- (void)dismiss
{
    [self hideWithAnimation:YES completion:^{
        
        [self removeFromSuperview];
        self.currentKeyWindow.rootViewController = nil;
        
        [self.currentKeyWindow removeFromSuperview];
        self.currentKeyWindow = nil;
        
        if(self.appearanceMessageFontBeforeChanging){
            [LNAlertView appearance].messageFont = self.appearanceMessageFontBeforeChanging;
        }
        
        LNAlertView *nextAlertView = [[LNAlertViewQueue sharedQueue] dequeue];
        if(nextAlertView){
            [nextAlertView show];
        }
    }];
    
    [self.lastKeyWindow makeKeyWindow];
    self.lastKeyWindow.hidden = NO;
}

@end

@implementation LNAlertView (Appearance)

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    if(_contentView){
        _contentView.titleLabel.textColor = _titleColor;
    }
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    if(_contentView){
        _contentView.titleLabel.font = _titleFont;
        
        [_contentView setNeedsUpdateConstraints];
        [_contentView invalidateIntrinsicContentSize];
    }
    [self setNeedsUpdateConstraints];
    [self invalidateIntrinsicContentSize];
}

- (void)setMessageColor:(UIColor *)messageColor
{
    _messageColor = messageColor;
    if(_contentView){
        _contentView.messageLabel.textColor = _messageColor;
    }
}

- (void)setMessageFont:(UIFont *)messageFont
{
    _messageFont = messageFont;
    if(_contentView){
        _contentView.messageLabel.font = _messageFont;
        
        [_contentView setNeedsUpdateConstraints];
        [_contentView invalidateIntrinsicContentSize];
    }
    [self setNeedsUpdateConstraints];
    [self invalidateIntrinsicContentSize];
}

@end

@implementation LNAlertContentView
{
    UILabel *_titleLabel;
    UILabel *_messageLabel;
    NSMutableArray *_constraints;
}
@synthesize titleLabel=_titleLabel;
@synthesize messageLabel=_messageLabel;

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame]){
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        self.blurEnabled = [LNAlertContentView canBlur];
        _constraints = @[].mutableCopy;
        _preferredFrameSize = CGSizeZero;
    }
    return self;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [LNAlertView appearance].titleFont?:[UIFont boldSystemFontOfSize:17.0f];
        [self addSubview:_titleLabel];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
       [_titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel
{
    if(!_messageLabel){
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [LNAlertView appearance].messageFont?:[UIFont systemFontOfSize:15.0f];
        [self addSubview:_messageLabel];
        _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_messageLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    }
    return _messageLabel;
}

- (void)setTitle:(NSString *)title message:(NSString *)message
{
    self.titleLabel.text = title;
    
    if(!title||title.length==0){
        self.alertView.appearanceMessageFontBeforeChanging = [LNAlertView appearance].messageFont;
        [LNAlertView appearance].messageFont = [LNAlertView appearance].titleFont?:[UIFont boldSystemFontOfSize:17.0f];
    }
    else{
        self.alertView.appearanceMessageFontBeforeChanging = nil;
    }
    self.messageLabel.font = [LNAlertView appearance].messageFont;
    self.messageLabel.text = message;
    
    [self setNeedsUpdateConstraints];
    [self invalidateIntrinsicContentSize];
}

// 是否显示自定义的视图
- (BOOL)isCustomContentView
{
    return !CGSizeEqualToSize(self.preferredFrameSize, CGSizeZero);
}

- (CGSize)intrinsicContentSize
{
    if([self isCustomContentView]){
        return [super intrinsicContentSize];
    }
    return [self getFitSize];
}

- (CGSize)getFitSize
{
    CGFloat resHeight = 0;
    CGSize aSize;
    CGFloat preferredTextWidth = kDefaultContainerWidth-self.contentInsets.left-self.contentInsets.right;
    if(self.titleLabel.text&&self.titleLabel.text.length>0){
        aSize = SIZE_LABEL(self.titleLabel.text, self.titleLabel.font, CGSizeMake(preferredTextWidth, MAXFLOAT));
        resHeight += aSize.height;
    }
    
    if(self.messageLabel.text&&self.messageLabel.text.length>0){
        aSize = SIZE_LABEL(self.messageLabel.text, self.messageLabel.font, CGSizeMake(preferredTextWidth, MAXFLOAT));
        if(aSize.height>kMaxMessageHeight){
            aSize.height = kMaxMessageHeight;
        }
        resHeight += aSize.height;
    }
    
    if(self.titleLabel.text.length>0&&self.messageLabel.text.length>0){
        resHeight += kTitleMessageSpace;
    }
    resHeight += self.contentInsets.top+self.contentInsets.bottom;
    if(resHeight<kAlertContentViewMinHeight){
        resHeight = kAlertContentViewMinHeight;
    }
    // The 'resHeight' must be rounded, or else it may cause UI issue.
    return CGSizeMake(kDefaultContainerWidth, round(resHeight));
}

- (void)setNeedsUpdateConstraints
{
    if([self isCustomContentView]){
        return [super setNeedsUpdateConstraints];
    }
    
    if(_constraints.count>0){
        [self removeConstraints:_constraints];
    }
    [_constraints removeAllObjects];
    [super setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    if([self isCustomContentView]){
        return [super updateConstraints];
    }
    
    if (_constraints.count>0) {
        [super updateConstraints];
        return;
    }
    if(_titleLabel.text&&_titleLabel.text.length>0){
        [_constraints addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1
                                                              constant:self.contentInsets.left]];
        [_constraints addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:-self.contentInsets.right]];
        [_constraints addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1
                                                              constant:self.contentInsets.top]];
        
        if(_messageLabel.text.length>0){
            [_constraints addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_messageLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1
                                                                  constant:-kTitleMessageSpace]];
        }
        else{
            [_constraints addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:-self.contentInsets.bottom]];
        }
    }
    
    if(_messageLabel.text&&_messageLabel.text.length>0){
        if(_titleLabel.text&&_titleLabel.text.length>0){
            [_constraints addObject:[NSLayoutConstraint constraintWithItem:_messageLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_titleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:kTitleMessageSpace]];
        }
        else{
            [_constraints addObject:[NSLayoutConstraint constraintWithItem:_messageLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1
                                                                  constant:self.contentInsets.top]];
        }
        [_constraints addObject:[NSLayoutConstraint constraintWithItem:_messageLabel
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1
                                                              constant:self.contentInsets.left]];
        [_constraints addObject:[NSLayoutConstraint constraintWithItem:_messageLabel
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:-self.contentInsets.right]];
        [_constraints addObject:[NSLayoutConstraint constraintWithItem:_messageLabel
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationLessThanOrEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1
                                                              constant:-self.contentInsets.bottom]];
        
        CGFloat preferredTextWidth = kDefaultContainerWidth-self.contentInsets.left-self.contentInsets.right;
        CGSize aSize = SIZE_LABEL(_messageLabel.text, _messageLabel.font, CGSizeMake(preferredTextWidth, MAXFLOAT));
        if(aSize.height>kMaxMessageHeight){
            aSize.height = kMaxMessageHeight;
        }
        [_constraints addObject:[NSLayoutConstraint constraintWithItem:_messageLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:aSize.height]];
    }
    
    [self addConstraints:_constraints];
    [super updateConstraints];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

@implementation LNBlurSupportedBackgroundView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareViews];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self prepareViews];
    }
    return self;
}

+ (BOOL)canBlur
{
    id class = NSClassFromString(@"UIVisualEffectView");
    return class?YES:NO;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    _blurView.frame = self.bounds;
#endif
    _backgroundView.frame = self.bounds;
}

- (void)setBlurEnabled:(BOOL)enabled
{
    _blurEnabled = enabled;
    if(_backgroundView){
        _backgroundView.alpha = _blurEnabled?0.15:0.98;
    }
}

- (void)prepareViews
{
    self.backgroundColor = [UIColor whiteColor];
    _blurEnabled = YES;
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.alpha = 1;
        _backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backgroundView];
    }
}

- (void)applyBlurEffect{
    self.backgroundColor = [UIColor clearColor];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if(!_blurView){
        _blurView = [[UIVisualEffectView alloc] initWithFrame:self.bounds];
        _blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        [self addSubview:_blurView];
        [self sendSubviewToBack:_blurView];
    }
#endif
    self.blurEnabled = [[self class] canBlur];
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

@implementation LNAlertButtonItem
{
    UIButton *button;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(touchDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
        
        _backgroundView = [[LNBlurSupportedBackgroundView alloc] initWithFrame:self.bounds];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_backgroundView];
        _backgroundView.blurEnabled = [LNBlurSupportedBackgroundView canBlur];
        
        button = [[UIButton alloc] initWithFrame:self.bounds];
        button.backgroundColor = [UIColor clearColor];
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:button];
        [button addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [button addTarget:self action:@selector(touchDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
        
    }
    return self;
}

- (void)touchDown:(UIButton *)btn
{
    if([btn titleForState:UIControlStateNormal]){
        if([LNBlurSupportedBackgroundView canBlur]){
            _backgroundView.backgroundView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1.];
        }
        else{
            _backgroundView.backgroundView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        }
    }
    else{
        [self sendActionsForControlEvents:UIControlEventTouchDown];
    }
}

- (void)touchUpInside:(UIButton *)btn
{
    if([btn titleForState:UIControlStateNormal]){
        if(_actionHanlder){
            _actionHanlder(self.alertView, self);
        }
        _backgroundView.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    else{
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)touchUpOutside:(UIButton *)btn
{
    if([btn titleForState:UIControlStateNormal]){
        _backgroundView.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    else{
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
    }
}

- (void)touchDragOutside:(UIButton *)btn
{
    if([btn titleForState:UIControlStateNormal]){
        _backgroundView.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    else{
        [self sendActionsForControlEvents:UIControlEventTouchDragOutside];
    }
}

@end


////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

@implementation LNAlertViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    //[self.view addSubview:self.alertView];
    [self.view insertSubview:self.alertView aboveSubview:self.backgroundView];
    
    self.alertView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.alertView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.alertView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.alertView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.alertView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1
                                                           constant:0]];
    
    [UIApplication sharedApplication].statusBarHidden = _rootViewControllerPrefersStatusBarHidden;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = _rootViewControllerPrefersStatusBarHidden;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = _rootViewControllerPrefersStatusBarHidden;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}
- (BOOL)prefersStatusBarHidden
{
    return _rootViewControllerPrefersStatusBarHidden;
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

@implementation LNAlertViewQueue
{
    NSMutableArray *_allAlerts;
}

+ (instancetype)sharedQueue{
    static LNAlertViewQueue *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LNAlertViewQueue alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if(self=[super init]){
        _allAlerts = @[].mutableCopy;
    }
    return self;
}

- (BOOL)contains:(LNAlertView *)alertView
{
    return [_allAlerts containsObject:alertView];
}

- (LNAlertView *)dequeue
{
    if(_allAlerts.count>0){
        return [_allAlerts firstObject];
    }
    return nil;
}

- (void)enqueue:(LNAlertView *)alertView
{
    [_allAlerts addObject:alertView];
}

- (void)remove:(LNAlertView *)alertView
{
    if(_allAlerts.count>0){
        if([self contains:alertView]){
            [_allAlerts removeObject:alertView];
        }
    }
}

@end

@implementation LNAlertView (Creations)

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
{
    LNAlertView *alert = [[LNAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle];
    return alert;
}

+ (instancetype)alertWithCustomView:(UIView *)customView
              withPresentationStyle:(LNCustomViewPresentationStyle)style
{
    LNAlertView *alert = [[LNAlertView alloc] initWithCustomView:customView withPresentationStyle:style];
    [alert show];
    return alert;
}

@end

