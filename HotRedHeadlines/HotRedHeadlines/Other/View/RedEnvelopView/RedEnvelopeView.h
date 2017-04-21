//
//  RedEnvelopeView.h
//  HotRed
//
//  Created by 邹壮壮 on 2016/11/23.
//  Copyright © 2016年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum RobRedEnvelopType {
    RobRedEnvelopFirstApp=0,
    RobRedEnvelopShare,
    RobRedEnvelopRead,
    RobRedEnvelopSign,
    RobRedEnvelopInvitation,
    RobRedEnvelopComment=5,
    RobRedEnvelopVideo=6
} RobRedEnvelopType;
@protocol  RedEnvelopeViewDelegate<NSObject>

- (void)removeFrom:(RobRedEnvelopType)type;
- (void)robSucess:(RobRedEnvelopType)type;
- (void)robSeverFailer;

@end
@interface RedEnvelopeView : UIView
@property (nonatomic,weak)id<RedEnvelopeViewDelegate>delegate;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *congratulationsL;
@property (nonatomic,strong) UILabel *goldL;
@property (nonatomic) RobRedEnvelopType type;
- (void)showType:(RobRedEnvelopType)type info:(NSString *)info;
@end
