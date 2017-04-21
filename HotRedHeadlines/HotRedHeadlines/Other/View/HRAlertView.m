//
//  HRAlertView.m
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/21.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import "HRAlertView.h"
static NSInteger kPopUpAView = 12340;

@interface HRAlertView()
@property (nonatomic, strong) UIView      *bgView;
@property (nonatomic, assign) BOOL        shouldShow;
@property (nonatomic, strong) UIImageView *starImageView;
@end
@implementation HRAlertView

+ (HRAlertView *)sharedAlert
{
    static HRAlertView  *sharedAlert = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAlert = [[HRAlertView alloc] init];
    });
    return sharedAlert;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)pTitle message:(NSString *)pMessage delegate:(id)pDelegate andButtons:(NSArray *)pButtons{
    CGFloat frameHeight;
    if (pButtons.count == 3) {
        frameHeight = pMessage ? 172.f : 147.f;
    }else{
       frameHeight = pMessage ? 124.f : 99.f;
    }
    
    if (!pTitle) {
        frameHeight -= 25.f;
    }
    self = [super initWithFrame:CGRectMake(0.f, 0.f, 270.f, frameHeight)];
    if (self) {
        
        if (pMessage.length > 0) {
            _shouldShow = YES;
        }
        self.layer.backgroundColor = [UIColor colorWithRed:245.f/255.f green:245.f/255.f blue:245.f/255.f alpha:1.f].CGColor;
        self.layer.cornerRadius = 4.f;
        self.clipsToBounds = YES;
        
        _delegate = pDelegate;
        
        // Initialization code
        UILabel *titleLabel;
        if (pTitle) {
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 160.f, 18.f)];
            titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = pTitle;
            titleLabel.center = CGPointMake(CGRectGetMidX(self.frame), 23.f);
            [self addSubview:titleLabel];
        }
        if (pMessage) {
            UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 250.f, 15.f)];
           
            
            NSRange range = [pMessage rangeOfString:@"\n"];
            if (range.location != NSNotFound) {
                descLabel.frame = CGRectMake(0.f, 0.f, 250.f, 43.f);
                self.frame = CGRectMake(0.f, 0.f, 270.f, frameHeight + 16.f);
                descLabel.numberOfLines = 2;
                descLabel.center = CGPointMake(CGRectGetMidX(self.frame), titleLabel.frame.origin.y + 40.f);
            }else{
                CGFloat gap=(titleLabel)?38.0f:30.0f;
                
                
                descLabel.center = CGPointMake(CGRectGetMidX(self.frame), titleLabel.frame.origin.y + gap);
            }
            
//            descLabel.font = pTitle ? [UIFont systemFontOfSize:14.f] : [UIFont boldSystemFontOfSize:14.f];
            descLabel.textAlignment = NSTextAlignmentJustified;
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.alignment = NSTextAlignmentJustified;
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[pMessage dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//            [attrStr setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, attrStr.length)];
              descLabel.attributedText = attrStr;
              
            
            
            //            [descLabel.layer setBorderWidth:1.0f];
            
            [self addSubview:descLabel];
        }
        
        
        
        
        if (pButtons.count == 1) {
            
            NSString *titleString = pButtons[0];
            
            UIButton *buttonL = [[UIButton alloc] initWithFrame:CGRectMake(-3.f, self.frame.size.height - 47.f, 276.f, 48.f)];
            [buttonL setTitle:titleString forState:UIControlStateNormal];
            buttonL.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.f];
            buttonL.layer.borderColor = [UIColor colorWithRed:217.f/255.f green:217.f/255.f blue:217.f/255.f alpha:1.f].CGColor;
            buttonL.layer.borderWidth = .5f;
            [buttonL setTitleColor:kColorM forState:UIControlStateNormal];
            //            [buttonL setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [buttonL setBackgroundImage:[self createImageWithColor:kColorCellSelected] forState:UIControlStateHighlighted];
            [buttonL addTarget:self action:@selector(doClick:) forControlEvents:UIControlEventTouchUpInside];
            buttonL.tag = 0;
            [self addSubview:buttonL];
        }else if (pButtons.count == 2){
            UIButton *buttonL = [[UIButton alloc] initWithFrame:CGRectMake(-3.f, self.frame.size.height - 47.f, 139.f, 48.f)];
            [buttonL setTitle:pButtons[0] forState:UIControlStateNormal];
            buttonL.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.f];
            buttonL.layer.borderColor = [UIColor colorWithRed:217.f/255.f green:217.f/255.f blue:217.f/255.f alpha:1.f].CGColor;
            buttonL.layer.borderWidth = .5f;
            [buttonL setTitleColor:RGBA(67, 181, 223, 1) forState:UIControlStateNormal];
            //            [buttonL setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [buttonL setBackgroundImage:[self createImageWithColor:kColorCellSelected] forState:UIControlStateHighlighted];
            [buttonL addTarget:self action:@selector(doClick:) forControlEvents:UIControlEventTouchUpInside];
            buttonL.tag = 0;
            [self addSubview:buttonL];
            
            UIButton *buttonR = [[UIButton alloc] initWithFrame:CGRectMake(135.f,  self.frame.size.height - 47.f, 136.f, 48.f)];
            [buttonR setTitle:pButtons[1] forState:UIControlStateNormal];
            buttonR.titleLabel.font =  [UIFont fontWithName:@"Helvetica" size:14.f];
            buttonR.layer.borderColor = [UIColor colorWithRed:217.f/255.f green:217.f/255.f blue:217.f/255.f alpha:1.f].CGColor;
            buttonR.layer.borderWidth = .5f;
            [buttonR setTitleColor:RGBA(67, 181, 223, 1) forState:UIControlStateNormal];
            //            [buttonR setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [buttonR setBackgroundImage:[self createImageWithColor:kColorCellSelected] forState:UIControlStateHighlighted];
            [buttonR addTarget:self action:@selector(doClick:) forControlEvents:UIControlEventTouchUpInside];
            buttonR.tag = 1;
            [self addSubview:buttonR];
        }else if (pButtons.count == 3){
            UIButton *buttonL = [[UIButton alloc] initWithFrame:CGRectMake(-3.f, self.frame.size.height - 95.f, 139.f, 48.f)];
            [buttonL setTitle:pButtons[0] forState:UIControlStateNormal];
            buttonL.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.f];
            buttonL.layer.borderColor = [UIColor colorWithRed:217.f/255.f green:217.f/255.f blue:217.f/255.f alpha:1.f].CGColor;
            buttonL.layer.borderWidth = .5f;
            [buttonL setTitleColor:RGBA(67, 181, 223, 1) forState:UIControlStateNormal];
            //            [buttonL setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [buttonL setBackgroundImage:[self createImageWithColor:kColorCellSelected] forState:UIControlStateHighlighted];
            [buttonL addTarget:self action:@selector(doClick:) forControlEvents:UIControlEventTouchUpInside];
            buttonL.tag = 0;
            [self addSubview:buttonL];
            
            UIButton *buttonR = [[UIButton alloc] initWithFrame:CGRectMake(135.f,  self.frame.size.height - 95.f, 136.f, 48.f)];
            [buttonR setTitle:pButtons[1] forState:UIControlStateNormal];
            buttonR.titleLabel.font =  [UIFont fontWithName:@"Helvetica" size:14.f];
            buttonR.layer.borderColor = [UIColor colorWithRed:217.f/255.f green:217.f/255.f blue:217.f/255.f alpha:1.f].CGColor;
            buttonR.layer.borderWidth = .5f;
            [buttonR setTitleColor:RGBA(67, 181, 223, 1) forState:UIControlStateNormal];
            //            [buttonR setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [buttonR setBackgroundImage:[self createImageWithColor:kColorCellSelected] forState:UIControlStateHighlighted];
            [buttonR addTarget:self action:@selector(doClick:) forControlEvents:UIControlEventTouchUpInside];
            buttonR.tag = 1;
            [self addSubview:buttonR];
            
            
            UIButton *buttonC = [[UIButton alloc] initWithFrame:CGRectMake(-3.f, self.frame.size.height - 47.f, 278.f, 48.f)];
            [buttonC setTitle:pButtons[2] forState:UIControlStateNormal];
            buttonC.titleLabel.font =  [UIFont fontWithName:@"Helvetica" size:14.f];
            buttonC.layer.borderColor = [UIColor colorWithRed:217.f/255.f green:217.f/255.f blue:217.f/255.f alpha:1.f].CGColor;
            buttonC.layer.borderWidth = .5f;
            [buttonC setTitleColor:RGBA(67, 181, 223, 1) forState:UIControlStateNormal];
            //            [buttonR setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [buttonC setBackgroundImage:[self createImageWithColor:kColorCellSelected] forState:UIControlStateHighlighted];
            [buttonC addTarget:self action:@selector(doClick:) forControlEvents:UIControlEventTouchUpInside];
            buttonC.tag = 2;
            [self addSubview:buttonC];
            
        }
    }
    return self;
}

- (void)show{
    if (!_shouldShow) return;
    if (!self.superview) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = .3f;
        _bgView.tag = kPopUpAView;
        [keyWindow addSubview:_bgView];
        self.center = CGPointMake(CGRectGetMidX(keyWindow.bounds), CGRectGetMidY(keyWindow.bounds));
        [keyWindow addSubview:self];
        [keyWindow bringSubviewToFront:self];
        
        UIImage *image = [UIImage imageNamed:@"star"];
        _starImageView = [[UIImageView alloc]initWithImage:image];
        [keyWindow addSubview:_starImageView];
        [_starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.mas_top).with.offset(-image.size.height*2/3);
            
        }];
        [keyWindow bringSubviewToFront:_starImageView];
        [self setTransform:CGAffineTransformMakeScale(0.5f, 0.5f)];
    }
//    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
//    
//    if ([window viewWithTag:kPopUpAView]) {
//        for (UIView *view in window.subviews) {
//            [view removeFromSuperview];
//        }
//        [[window viewWithTag:kPopUpAView] removeFromSuperview];
//    }
    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
   

    
  
    


    
    
    __weak HRAlertView *weakSelf = self;
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    } completion:NULL];
    
}

- (void)doClick:(UIButton *)sender{
    
    if (self.delegate) {
        [self.delegate popAlertView:self clickedButtonAtIndex:sender.tag];
    }
    
    __weak HRAlertView *weakSelf = self;
    [UIView animateWithDuration:.4f delay:.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.bgView.alpha = 0.f;
        weakSelf.starImageView.alpha = 0.f;
        weakSelf.alpha = 0.f;
    } completion:^(BOOL finished) {
        [weakSelf.starImageView removeFromSuperview];
        [weakSelf.bgView removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

- (void)setDelegate:(id<HRAlertViewDelegate>)delegate{
    if (_delegate == delegate) {
        return;
    }
    _delegate = delegate;
}

- (UIImage *)createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
